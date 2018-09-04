//
//  PrivacyZoneViewController.m
//  WWDC Family
//
//  Created by Andrew Yates on 5/16/18.
//  Copyright © 2018 AndyDev. All rights reserved.
//

#import "PrivacyZoneViewController.h"
#import "NSUserDefaults+MKMapRect.h"

@interface PrivacyZoneViewController () <MKMapViewDelegate>

@property (strong, nonatomic) ASDisplayNode *mapNode;
@property (strong, nonatomic) MKMapView *mapView;

@end

@implementation PrivacyZoneViewController

- (instancetype)init {
    if (!(self = [super initWithNode:[[ASDisplayNode alloc] init]]))
        return nil;
    
    self.title = NSLocalizedString(@"privacyZoneVC.title", @"Privacy Zone");
    self.node.backgroundColor = [UIColor whiteColor];
    
    NSString *descriptionString = NSLocalizedString(@"privacyZoneVC.description", @"Adding a Privacy Zone to ConfFriends will stop the app from sharing your location within the selected area shown in the map below. Move & scale the map to adjust the zone.\n\nPlease avoid centering the map over your home or hotel or other location so it doesn’t allow people to discover your location over time.");
    
    NSMutableAttributedString *descriptionAttributedString = [[NSMutableAttributedString alloc] initWithString:descriptionString attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14 weight:UIFontWeightRegular], NSForegroundColorAttributeName:[UIColor colorWithWhite:0.0 alpha:0.6]}];
    
    ASTextNode *descriptionTextNode = [ASTextNode new];
    [descriptionTextNode setAttributedText:descriptionAttributedString];
    
    self.mapNode = [[ASDisplayNode alloc] initWithViewBlock:^UIView * _Nonnull{
        self.mapView = [[MKMapView alloc] init];
        [self.mapView setDelegate:self];
        [self.mapView setShowsPointsOfInterest:YES];
        [self.mapView setShowsCompass:NO];
        [self.mapView setShowsTraffic:NO];
        [self.mapView setShowsScale:NO];
        [self.mapView setShowsUserLocation:YES];
        if (@available(iOS 11.0, *)) {
            [self.mapView setMapType:MKMapTypeMutedStandard];
        } else {
            [self.mapView setMapType:MKMapTypeStandard];
        }
        
        if([[NSUserDefaults standardUserDefaults] valueForKey:@"DDFPrivacyZone"]){
            [self resizeRegionToPrivacyZone];
        } else {
            [self resizeRegionToSanJose];
        }
        return self.mapView;
    } didLoadBlock:^(__kindof ASDisplayNode * _Nonnull node) {
        
    }];
    
    self.mapNode.shadowOpacity = 0.1;
    self.mapNode.shadowRadius = 12;
    self.mapNode.shadowColor = [UIColor blackColor].CGColor;
    self.mapNode.shadowOffset = CGSizeMake(0, 6);
    self.mapNode.cornerRadius = 8.0;
    
    ASButtonNode *nextButton = [ASButtonNode new];
    [nextButton setTitle:NSLocalizedString(@"privacyZoneVC.setPrivacyZone", @"Set Privacy Zone") withFont:[UIFont systemFontOfSize:14.0 weight:UIFontWeightSemibold] withColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextButton setBackgroundImage:[UIImage fc_solidColorImageWithSize:CGSizeMake(1, 1) color:[UIColor fc_colorWithHexString:@"ff0066"]] forState:UIControlStateNormal];
    [nextButton setBackgroundImage:[UIImage fc_solidColorImageWithSize:CGSizeMake(1, 1) color:[UIColor fc_colorWithHexString:@"ff3686"]] forState:UIControlStateHighlighted];
    [nextButton addTarget:self action:@selector(saveZone) forControlEvents:ASControlNodeEventTouchUpInside];
    
    nextButton.cornerRadius = 22;
    nextButton.shadowOpacity = 0.1;
    nextButton.shadowRadius = 12;
    nextButton.shadowColor = [UIColor blackColor].CGColor;
    nextButton.shadowOffset = CGSizeMake(0, 6);
    [nextButton setClipsToBounds:YES];
    [nextButton setCornerRadius:4];

    
    NSAttributedString *deleteString = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"privacyZoneVC.deleteZone", @"Delete Zone") attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0 weight:UIFontWeightRegular], NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
    ASTextNode *deleteNode = [ASTextNode new];
    [deleteNode setAttributedText:deleteString];
    [deleteNode addTarget:self action:@selector(deleteZone) forControlEvents:ASControlNodeEventTouchUpInside];
    
    
    __weak typeof(self) weakSelf = self;
    [self.node setLayoutSpecBlock:^ASLayoutSpec * _Nonnull(__kindof ASDisplayNode * _Nonnull node, ASSizeRange constrainedSize) {
        [weakSelf.mapNode.style setPreferredSize:CGSizeMake(constrainedSize.max.width-64, constrainedSize.max.width-64)];
        
        ASInsetLayoutSpec *mapInsetSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(0, 0, 16, 0) child:weakSelf.mapNode];
        
        [nextButton.style setHeight:ASDimensionMake(44)];
        [nextButton.style setWidth:ASDimensionMake(150)];
        
        [deleteNode.style setHeight:ASDimensionMake(44)];
        
        ASCenterLayoutSpec *nextButtonCenterSpec = [ASCenterLayoutSpec centerLayoutSpecWithCenteringOptions:ASCenterLayoutSpecCenteringX sizingOptions:ASCenterLayoutSpecSizingOptionMinimumXY child:nextButton];
        
        ASCenterLayoutSpec *deleteButtonCenterSpec = [ASCenterLayoutSpec centerLayoutSpecWithCenteringOptions:ASCenterLayoutSpecCenteringX sizingOptions:ASCenterLayoutSpecSizingOptionMinimumXY child:deleteNode];
        
        ASStackLayoutSpec *stackSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:24 justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsStretch children:@[descriptionTextNode, mapInsetSpec, nextButtonCenterSpec, deleteButtonCenterSpec]];
        
        CGFloat topInset = 0;
        if(self.node.safeAreaInsets.top != 0) topInset = self.node.safeAreaInsets.top;
        
        ASInsetLayoutSpec *stackInsetSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(topInset+16, 16, 16, 16) child:stackSpec];
        
        return stackInsetSpec;
    }];
    
    [self.node setAutomaticallyManagesSubnodes:YES];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"general.close", @"Close") style:UIBarButtonItemStylePlain target:self action:@selector(dismissView)];
    
    return self;
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

#pragma mark - Privacy Zone Region

- (void)resizeRegionToPrivacyZone {
    MKMapRect mapRect = [[NSUserDefaults standardUserDefaults] mapRectForKey:@"DDFPrivacyZone"];
    [self.mapView setVisibleMapRect:mapRect animated:YES];
}

#pragma mark - Actions

- (void)saveZone {
    [[NSUserDefaults standardUserDefaults] setMapRect:self.mapView.visibleMapRect forKey:@"DDFPrivacyZone"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // Check if current stored location is within zone and delete if so.
    [[[[[FIRDatabase database] reference] child:@"users"] child:[[[FIRAuth auth] currentUser] uid]] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if(snapshot.exists){
            NSMutableDictionary *userValue = [snapshot.value mutableCopy];
            [userValue addEntriesFromDictionary:@{@"id":snapshot.key}];
            
            DDFUser *user = [[DDFUser alloc] initWithModelDictionary:userValue];
            
            CLLocation *location = [[CLLocation alloc] initWithLatitude:user.latitude longitude:user.longitude];
            MKMapPoint currentMapPoint = MKMapPointForCoordinate(location.coordinate);
            if(MKMapRectContainsPoint([[NSUserDefaults standardUserDefaults] mapRectForKey:@"DDFPrivacyZone"], currentMapPoint)){
                FIRDatabaseReference *userRef = [[[[FIRDatabase database] reference] child:@"users"] child:[[[FIRAuth auth] currentUser] uid]];
                [[userRef child:@"latitude"] removeValue];
                [[userRef child:@"longitude"] removeValue];
            }
        }
    }];
    
    [self dismissView];
}

- (void)deleteZone {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"DDFPrivacyZone"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self dismissView];
}

- (void)dismissView {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
