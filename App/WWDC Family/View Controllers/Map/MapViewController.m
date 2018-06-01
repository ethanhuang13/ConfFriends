//
//  MapViewController.m
//  WWDC Family
//
//  Created by Andrew Yates on 4/28/18.
//  Copyright © 2018 AndyDev. All rights reserved.
//

#import "MapViewController.h"
#import "PINRemoteImageManager.h"
#import <SafariServices/SFSafariViewController.h>
#import "UserMapAnnotation.h"
#import "SettingsViewController.h"
#import "UsersViewController.h"
#import "AppDelegate.h"

@interface MapViewController () <MKMapViewDelegate, UsersViewControllerDelegate>

@property (nonatomic) BOOL shownUserLocation;
@property (strong, nonatomic) ASDisplayNode *mapNode;
@property (strong, nonatomic) MKMapView *mapView;
@property (strong, nonatomic) NSMutableDictionary *userAnnotations;
@property (strong, nonatomic) UISwitch *locationSwitch;

@end

@implementation MapViewController

- (instancetype)init {
    if (!(self = [super initWithNode:[[ASDisplayNode alloc] init]]))
        return nil;
    
    self.userAnnotations = [NSMutableDictionary new];
    
    [self.node setBackgroundColor:[UIColor whiteColor]];
    [self.node setAutomaticallyManagesSubnodes:YES];
    [self.node setAutomaticallyRelayoutOnSafeAreaChanges:YES];
    [self.node setAutomaticallyRelayoutOnLayoutMarginsChanges:YES];
    
    self.mapNode = [[ASDisplayNode alloc] initWithViewBlock:^UIView * _Nonnull{
        self.mapView = [[MKMapView alloc] init];
        [self.mapView setDelegate:self];
        [self.mapView setShowsPointsOfInterest:YES];
        [self.mapView setShowsCompass:NO];
        [self.mapView setShowsTraffic:NO];
        [self.mapView setShowsScale:NO];
        [self.mapView setShowsUserLocation:YES];
        if (@available(iOS 11.0, *)) {
            [self.mapView setMapType:MKMapTypeStandard];
        } else {
            [self.mapView setMapType:MKMapTypeStandard];
        }
        [self resizeRegionToSanJose];
        return self.mapView;
    } didLoadBlock:^(__kindof ASDisplayNode * _Nonnull node) {
        
    }];
    
    
    ASDisplayNode *userLocationBackgroundNode = [[ASDisplayNode alloc] initWithViewBlock:^UIView *{
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        UIVisualEffectView *fxView = [[UIVisualEffectView alloc] initWithEffect:blur];
        return fxView;
    }];
    [userLocationBackgroundNode setCornerRadius:22];
    [userLocationBackgroundNode setClipsToBounds:YES];
    
    ASButtonNode *userLocationButtonNode = [[ASButtonNode alloc] init];
    [userLocationButtonNode setTitle:@"" withFont:[UIFont fontWithName:@"FontAwesome5ProLight" size:15.0] withColor:[UIColor fc_colorWithHexString:@"ff0066"] forState:UIControlStateNormal];
    [userLocationButtonNode setTitle:@"" withFont:[UIFont fontWithName:@"FontAwesome5ProLight" size:15.0] withColor:[UIColor fc_colorWithHexString:@"ff3686"] forState:UIControlStateHighlighted];
    [userLocationButtonNode addTarget:self action:@selector(showUserLocation) forControlEvents:ASControlNodeEventTouchUpInside];
    
    
    ASDisplayNode *searchBackgroundNode = [[ASDisplayNode alloc] initWithViewBlock:^UIView *{
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        UIVisualEffectView *fxView = [[UIVisualEffectView alloc] initWithEffect:blur];
        return fxView;
    }];
    [searchBackgroundNode setCornerRadius:22];
    [searchBackgroundNode setClipsToBounds:YES];
    
    ASButtonNode *searchButtonNode = [[ASButtonNode alloc] init];
    [searchButtonNode setTitle:@"" withFont:[UIFont fontWithName:@"FontAwesome5ProLight" size:15.0] withColor:[UIColor fc_colorWithHexString:@"ff0066"] forState:UIControlStateNormal];
    [searchButtonNode setTitle:@"" withFont:[UIFont fontWithName:@"FontAwesome5ProLight" size:15.0] withColor:[UIColor fc_colorWithHexString:@"ff3686"] forState:UIControlStateHighlighted];
    [searchButtonNode addTarget:self action:@selector(presentUsers) forControlEvents:ASControlNodeEventTouchUpInside];
    
    
    
    ASDisplayNode *settingsBackgroundNode = [[ASDisplayNode alloc] initWithViewBlock:^UIView *{
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        UIVisualEffectView *fxView = [[UIVisualEffectView alloc] initWithEffect:blur];
        return fxView;
    }];
    [settingsBackgroundNode setCornerRadius:8.0];
    [settingsBackgroundNode setClipsToBounds:YES];
    
    
    ASDisplayNode *locationSwitch = [[ASDisplayNode alloc] initWithViewBlock:^UIView * _Nonnull{
        self.locationSwitch = [[UISwitch alloc] init];
        [self.locationSwitch setOn:[[NSUserDefaults standardUserDefaults] boolForKey:@"DDFLocationDisabled"]];
        [self.locationSwitch setBackgroundColor:[UIColor clearColor]];
        [self.locationSwitch addTarget:self action:@selector(locationSwitchChanged) forControlEvents:UIControlEventValueChanged];
        return self.locationSwitch;
    }];
    [locationSwitch setUserInteractionEnabled:YES];
    
    ASTextNode *switchTextNode = [[ASTextNode alloc] init];
    [switchTextNode setAttributedText:[[NSAttributedString alloc] initWithString:@"Disable & Hide Location" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0 weight:UIFontWeightRegular]}]];
    
    ASDisplayNode *dividerNode = [[ASDisplayNode alloc] init];
    [dividerNode setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.1]];
    
    ASButtonNode *settingsButtonNode = [[ASButtonNode alloc] init];
    [settingsButtonNode setTitle:@"" withFont:[UIFont fontWithName:@"FontAwesome5ProLight" size:20.0] withColor:[UIColor fc_colorWithHexString:@"ff0066"] forState:UIControlStateNormal];
    [settingsButtonNode setTitle:@"" withFont:[UIFont fontWithName:@"FontAwesome5ProLight" size:20.0] withColor:[UIColor fc_colorWithHexString:@"ff3686"] forState:UIControlStateHighlighted];
    [settingsButtonNode addTarget:self action:@selector(presentSettings) forControlEvents:ASControlNodeEventTouchUpInside];
    
    __weak typeof(self) weakSelf = self;
    self.node.layoutSpecBlock = ^ASLayoutSpec *(ASDisplayNode *_Nonnull node, ASSizeRange constrainedSize) {
        [weakSelf.mapNode.style setPreferredSize:CGSizeMake(constrainedSize.max.width, constrainedSize.max.height)];
        
        [userLocationBackgroundNode.style setPreferredSize:CGSizeMake(44, 44)];
        [userLocationButtonNode.style setPreferredSize:CGSizeMake(44, 44)];
        
        [searchBackgroundNode.style setPreferredSize:CGSizeMake(44, 44)];
        [searchButtonNode.style setPreferredSize:CGSizeMake(44, 44)];
        
        [locationSwitch.style setPreferredSize:CGSizeMake(50, 30)];
        [dividerNode.style setWidth:ASDimensionMake(1/[[UIScreen mainScreen] nativeScale])];
        [dividerNode.style setHeight:ASDimensionMake(44)];
        
        ASStackLayoutSpec *locationSettingStackSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal spacing:8 justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsCenter children:@[locationSwitch, switchTextNode]];
        
        ASInsetLayoutSpec *dividerInsetSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(0, 15, 0, 0) child:dividerNode];
        
        ASStackLayoutSpec *settingStackSpec;
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            [settingsButtonNode.style setWidth:ASDimensionMake(88)];
            
            settingStackSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal spacing:10 justifyContent:ASStackLayoutJustifyContentSpaceBetween alignItems:ASStackLayoutAlignItemsStretch children:@[locationSettingStackSpec, settingsButtonNode]];
        } else {
            [settingsButtonNode.style setFlexGrow:YES];

            settingStackSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal spacing:10 justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsStretch children:@[locationSettingStackSpec, dividerInsetSpec, settingsButtonNode]];
        }
            
        ASInsetLayoutSpec *settingsContentInsetSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(6, 12, 6, 12) child:settingStackSpec];
        
        ASBackgroundLayoutSpec *settingsBackgroundSpec = [ASBackgroundLayoutSpec backgroundLayoutSpecWithChild:settingsContentInsetSpec background:settingsBackgroundNode];
        
        CGFloat bottomInset = 16;
        if(self.node.safeAreaInsets.bottom != 0) bottomInset = self.node.safeAreaInsets.bottom;
        
        UIEdgeInsets settingsInsets = UIEdgeInsetsMake(INFINITY, 24, bottomInset, 24);
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) settingsInsets = UIEdgeInsetsMake(INFINITY, 300, bottomInset, 300);
        
        ASInsetLayoutSpec *settingsInsetSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets:settingsInsets child:settingsBackgroundSpec];
        
        ASOverlayLayoutSpec *userLocationButtonOverlaySpec = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:userLocationBackgroundNode overlay:userLocationButtonNode];
        [userLocationButtonOverlaySpec.style setPreferredSize:CGSizeMake(44, 44)];
        
        ASOverlayLayoutSpec *searchButtonOverlaySpec = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:searchBackgroundNode overlay:searchButtonNode];
        [searchButtonOverlaySpec.style setPreferredSize:CGSizeMake(44, 44)];
        
        
        CGFloat topInset = 16;
        if(self.node.safeAreaInsets.top != 0) topInset = self.node.safeAreaInsets.top;
        
        ASStackLayoutSpec *buttonStackSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:10 justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsStart children:@[userLocationButtonOverlaySpec, searchButtonOverlaySpec]];

        ASInsetLayoutSpec *buttonInsetSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(24+topInset, 0, 0, 24) child:buttonStackSpec];
        
        ASRelativeLayoutSpec *buttonRelativeSpec = [ASRelativeLayoutSpec relativePositionLayoutSpecWithHorizontalPosition:ASRelativeLayoutSpecPositionEnd verticalPosition:ASRelativeLayoutSpecPositionStart sizingOption:ASRelativeLayoutSpecSizingOptionMinimumSize child:buttonInsetSpec];
        
        ASOverlayLayoutSpec *buttonOverlaySpec = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:weakSelf.mapNode overlay:buttonRelativeSpec];
        
        return [ASOverlayLayoutSpec overlayLayoutSpecWithChild:buttonOverlaySpec overlay:settingsInsetSpec];
    };
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addStatusBarBlurBackground];
    
    // User Added
    [[[[FIRDatabase database] reference] child:@"users"] observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if(snapshot.exists){
            NSMutableDictionary *user = [snapshot.value mutableCopy];
            [user addEntriesFromDictionary:@{@"id":snapshot.key}];
            [self addUserMarker:[[DDFUser alloc] initWithModelDictionary:user]];
        }
    }];
    
    // User Changed (Could be that lat/long has also been removed to hide location)
    [[[[FIRDatabase database] reference] child:@"users"] observeEventType:FIRDataEventTypeChildChanged withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if(snapshot.exists){
            NSMutableDictionary *userSnapshot = [snapshot.value mutableCopy];
            [userSnapshot addEntriesFromDictionary:@{@"id":snapshot.key}];
            DDFUser *user = [[DDFUser alloc] initWithModelDictionary:userSnapshot];
            if(!user.latitude || !user.longitude){
                UserMapAnnotation *userAnnotation = [self.userAnnotations objectForKey:snapshot.key];
                [self.mapView removeAnnotation:userAnnotation];
                [self.userAnnotations removeObjectForKey:snapshot.key];
            } else {
                if([self.userAnnotations objectForKey:snapshot.key]){
                    UserMapAnnotation *userAnnotation = [self.userAnnotations objectForKey:snapshot.key];
                    userAnnotation.coordinate = CLLocationCoordinate2DMake(user.latitude, user.longitude);
                } else {
                    [self addUserMarker:user];
                }
            }
        }
    }];
    
    // User Removed
    [[[[FIRDatabase database] reference] child:@"users"] observeEventType:FIRDataEventTypeChildRemoved withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if([self.userAnnotations objectForKey:snapshot.key]){
            UserMapAnnotation *userAnnotation = [self.userAnnotations objectForKey:snapshot.key];
            [self.mapView removeAnnotation:userAnnotation];
            [self.userAnnotations removeObjectForKey:snapshot.key];
        }
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshLocationToggle) name:@"DDFOnboardingCompleted" object:nil];
}

#pragma mark - San Jose Region

- (void)resizeRegionToSanJose {
    CLLocationCoordinate2D coordinate1 = CLLocationCoordinate2DMake(37.342944, -121.921600);
    CLLocationCoordinate2D coordinate2 = CLLocationCoordinate2DMake(37.313885, -121.862034);
    
    MKMapPoint p1 = MKMapPointForCoordinate (coordinate1);
    MKMapPoint p2 = MKMapPointForCoordinate (coordinate2);
    
    MKMapRect mapRect = MKMapRectMake(fmin(p1.x,p2.x), fmin(p1.y,p2.y), fabs(p1.x-p2.x), fabs(p1.y-p2.y));
    
    [self.mapView setVisibleMapRect:mapRect animated:YES];
}

#pragma mark - User Location

- (void)showUserLocation {
    MKCoordinateRegion mapRegion;
    mapRegion.center = self.mapView.userLocation.coordinate;
    mapRegion.span.latitudeDelta = 0.2;
    mapRegion.span.longitudeDelta = 0.2;
    
    [self.mapView setRegion:mapRegion animated: YES];
}

#pragma mark - Annotations

- (void)addUserMarker:(DDFUser *)user {
    if([self.userAnnotations objectForKey:user.identifier]) return;
    if(!user.latitude || !user.longitude || !user.avatar) return;
    
    [[PINRemoteImageManager sharedImageManager] downloadImageWithURL:user.avatar options:PINRemoteImageManagerDownloadOptionsNone processorKey:@"wwdcfamily" processor:^UIImage * _Nullable(PINRemoteImageManagerResult * _Nonnull result, NSUInteger * _Nonnull cost) {
        return [self roundedRectImageFromImage:result.image size:CGSizeMake(30, 30) withCornerRadius:15];
    } completion:^(PINRemoteImageManagerResult * _Nonnull result) {
        if(result.image){
            UserMapAnnotation *annotation = [UserMapAnnotation new];
            annotation.coordinate = CLLocationCoordinate2DMake(user.latitude, user.longitude);
            annotation.title = user.name;
            annotation.subtitle = [NSString stringWithFormat:@"Last updated at %@", [[self dateFormatter] stringFromDate:user.updatedAt]];
            annotation.image = [self roundedRectImageFromImage:result.image size:CGSizeMake(30, 30) withCornerRadius:15];
            annotation.user = user;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.mapView addAnnotation:annotation];
                [self.userAnnotations setObject:annotation forKey:user.identifier];
            });
        }
    }];
}

- (NSDateFormatter *)dateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    return dateFormatter;
}

- (UIImage *)roundedRectImageFromImage:(UIImage *)image size:(CGSize)imageSize withCornerRadius:(float)cornerRadius {
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
    CGRect bounds=(CGRect){CGPointZero,imageSize};
    [[UIBezierPath bezierPathWithRoundedRect:bounds cornerRadius:cornerRadius] addClip];
    [image drawInRect:bounds];
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return finalImage;
}

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation {
    if([annotation isKindOfClass:[UserMapAnnotation class]]){
        MKAnnotationView *annotationView;
        
        if (!annotationView) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"user"];
            annotationView.image = [UIImage imageNamed:@"userLocation"];
        }
        
        annotationView.image = ((UserMapAnnotation *)annotation).image;
        
        if(((UserMapAnnotation *)annotation).user.country){
            UIImageView *flag = [[UIImageView alloc] initWithImage:[UIImage imageNamed:((UserMapAnnotation *)annotation).user.countryCode]];
            [flag setFrame:CGRectMake(0, 0, 25, 19)];
            annotationView.rightCalloutAccessoryView = flag;
        } else {
            annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        }
        
        annotationView.canShowCallout = YES;
        
        return annotationView;
    }
    return nil;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(calloutTapped:)];
    [view addGestureRecognizer:tapGesture];
}

-(void)calloutTapped:(UITapGestureRecognizer *)sender {
    MKAnnotationView *view = (MKAnnotationView*)sender.view;
    if([view.annotation isKindOfClass:[UserMapAnnotation class]]){
        UserMapAnnotation *annotation = (UserMapAnnotation *)view.annotation;
        DDFUser *user = annotation.user;
        
        NSString *handle = user.twitterUsername;
        
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetbot://"]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tweetbot://%@/user_profile/%@", handle, handle]] options:@{} completionHandler:^(BOOL success) {
                
            }];
        } else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter://"]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"twitter://user?screen_name=" stringByAppendingString:handle]] options:@{} completionHandler:^(BOOL success) {
                
            }];
        } else {
            SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://twitter.com/intent/user?user_id=%@", user.twitterID]]];
            [self presentViewController:safariVC animated:YES completion:nil];
        }
    }
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    UserMapAnnotation *annotation = (UserMapAnnotation *)view.annotation;
    DDFUser *user = annotation.user;
    
    NSString *handle = user.twitterUsername;
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetbot://"]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tweetbot://%@/user_profile/%@", handle, handle]] options:@{} completionHandler:^(BOOL success) {
            
        }];
    } else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter://"]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"twitter://user?screen_name=" stringByAppendingString:handle]] options:@{} completionHandler:^(BOOL success) {
            
        }];
    } else {
        SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://twitter.com/intent/user?user_id=%@", user.twitterID]]];
        [self presentViewController:safariVC animated:YES completion:nil];
    }
}


- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    if(!self.shownUserLocation){
        self.shownUserLocation = YES;
        [self showUserLocation];
    }
}

#pragma mark - Actions

#pragma mark - Disable Location

- (void)locationSwitchChanged {
    [[NSUserDefaults standardUserDefaults] setBool:[self.locationSwitch isOn] forKey:@"DDFLocationDisabled"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if(![self.locationSwitch isOn]){
        [appDelegate fetchLocationChanges];
    } else {
        [appDelegate stopLocationUpdates];
        
        FIRDatabaseReference *userRef = [[[[FIRDatabase database] reference] child:@"users"] child:[[[FIRAuth auth] currentUser] uid]];
        [[userRef child:@"latitude"] removeValue];
        [[userRef child:@"longitude"] removeValue];
    }
}

- (void)refreshLocationToggle {
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"DDFLocationDisabled"]){
        [self.locationSwitch setOn:YES];
    } else {
        [self.locationSwitch setOn:NO];
    }
}

#pragma mark - Settings

- (void)presentSettings {
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:[SettingsViewController new]];
    [self presentViewController:navController animated:YES completion:nil];
}

#pragma mark - Search

- (void)presentUsers {
    UsersViewController *usersView = [UsersViewController new];
    [usersView setDelegate:self];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:usersView];
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)ddf_didSelectUser:(DDFUser *)user {
    if([self.userAnnotations objectForKey:user.identifier]){
        [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(user.latitude, user.longitude), 200, 200) animated:YES];
        
        UserMapAnnotation *annotation = (UserMapAnnotation *)[self.userAnnotations objectForKey:user.identifier];
        [self.mapView selectAnnotation:annotation animated:YES];
    }
}

@end
