//
//  AuthViewController.m
//  WWDC Family
//
//  Created by Andrew Yates on 4/28/18.
//  Copyright © 2018 AndyDev. All rights reserved.
//

#import "AuthViewController.h"
#import "FCTwitterAuthorization.h"
#import "AppDelegate.h"
#import "PrivacyViewController.h"
#import "MBProgressHUD.h"

@interface AuthViewController ()

@end

@implementation AuthViewController

- (instancetype)init {
    if (!(self = [super initWithNode:[[ASDisplayNode alloc] init]]))
        return nil;
    
    [self.node setBackgroundColor:[UIColor whiteColor]];
    [self.node setAutomaticallyManagesSubnodes:YES];
    
    ASTextNode *headerTextNode = [ASTextNode new];
    [headerTextNode setAttributedText:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"authVC.welcome", @"Welcome to\nConfFriends") attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:30 weight:UIFontWeightHeavy]}]];
    
    
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    ASTextNode *placesIconNode = [ASTextNode new];
    [placesIconNode setAttributedText:[[NSAttributedString alloc] initWithString:@"" attributes:@{NSFontAttributeName:[UIFont fontWithName:@"FontAwesome5ProLight" size:30.0], NSForegroundColorAttributeName:[UIColor colorWithWhite:0.0 alpha:0.6], NSParagraphStyleAttributeName:paragraphStyle}]];
    
    ASTextNode *placesTextNode = [ASTextNode new];
    [placesTextNode setAttributedText:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"authVC.findHappeningSpots", @"Find the happening spots around San Jose during the week.") attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14 weight:UIFontWeightRegular], NSForegroundColorAttributeName:[UIColor colorWithWhite:0.0 alpha:0.6]}]];
    
    
    ASTextNode *meetIconNode = [ASTextNode new];
    [meetIconNode setAttributedText:[[NSAttributedString alloc] initWithString:@"" attributes:@{NSFontAttributeName:[UIFont fontWithName:@"FontAwesome5ProLight" size:30.0], NSForegroundColorAttributeName:[UIColor colorWithWhite:0.0 alpha:0.6], NSParagraphStyleAttributeName:paragraphStyle}]];
    
    ASTextNode *meetTextNode = [ASTextNode new];
    [meetTextNode setAttributedText:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"authVC.meetNewPeople", @"Meet new people in town for the week, get in touch via their Twitter account by tapping their avatar.") attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14 weight:UIFontWeightRegular], NSForegroundColorAttributeName:[UIColor colorWithWhite:0.0 alpha:0.6]}]];
    
    
    ASTextNode *disableLocationIconNode = [ASTextNode new];
    [disableLocationIconNode setAttributedText:[[NSAttributedString alloc] initWithString:@"" attributes:@{NSFontAttributeName:[UIFont fontWithName:@"FontAwesome5ProLight" size:30.0], NSForegroundColorAttributeName:[UIColor colorWithWhite:0.0 alpha:0.6], NSParagraphStyleAttributeName:paragraphStyle}]];
    
    ASTextNode *disableLocationTextNode = [ASTextNode new];
    [disableLocationTextNode setAttributedText:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"authVC.disableAndHide", @"Disable & hide your location at any point using the toggle below the map.") attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14 weight:UIFontWeightRegular], NSForegroundColorAttributeName:[UIColor colorWithWhite:0.0 alpha:0.6]}]];
    
    
    ASTextNode *batteryIconNode = [ASTextNode new];
    [batteryIconNode setAttributedText:[[NSAttributedString alloc] initWithString:@"" attributes:@{NSFontAttributeName:[UIFont fontWithName:@"FontAwesome5ProLight" size:30.0], NSForegroundColorAttributeName:[UIColor colorWithWhite:0.0 alpha:0.6], NSParagraphStyleAttributeName:paragraphStyle}]];
    
    ASTextNode *batteryPerformanceTextNode = [ASTextNode new];
    [batteryPerformanceTextNode setAttributedText:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"authVC.adjustLocationAccuracy", @"Adjust location accuracy to minimise battery usage when it suits you.") attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14 weight:UIFontWeightRegular], NSForegroundColorAttributeName:[UIColor colorWithWhite:0.0 alpha:0.6]}]];
    
    
    
    ASButtonNode *authenticateButton = [ASButtonNode new];
    [authenticateButton setTitle:NSLocalizedString(@"authVC.signInWithTwitter", @"Sign in with Twitter") withFont:[UIFont systemFontOfSize:14.0 weight:UIFontWeightSemibold] withColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [authenticateButton setBackgroundImage:[UIImage fc_solidColorImageWithSize:CGSizeMake(1, 1) color:[UIColor fc_colorWithHexString:@"ff0066"]] forState:UIControlStateNormal];
    [authenticateButton setBackgroundImage:[UIImage fc_solidColorImageWithSize:CGSizeMake(1, 1) color:[UIColor fc_colorWithHexString:@"ff3686"]] forState:UIControlStateHighlighted];
    [authenticateButton addTarget:self action:@selector(startTwitterAuthentication) forControlEvents:ASControlNodeEventTouchUpInside];
    
    [authenticateButton setClipsToBounds:YES];
    [authenticateButton setCornerRadius:4];
    [authenticateButton setShadowOpacity:0.1];
    [authenticateButton setShadowRadius:8];
    [authenticateButton setShadowColor:[UIColor blackColor].CGColor];
    [authenticateButton setShadowOffset:CGSizeMake(0, 6)];
    
    
    ASTextNode *privacyTextNode = [ASTextNode new];
    NSString *privacyString = NSLocalizedString(@"authVC.bySigningIn", @"By signing in you agree to our Privacy Policy.");
    NSMutableAttributedString *privacyAttributedString = [[NSMutableAttributedString alloc] initWithString:privacyString attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13 weight:UIFontWeightRegular], NSForegroundColorAttributeName:[UIColor colorWithWhite:0.0 alpha:0.5]}];
    [privacyAttributedString addAttributes:@{NSForegroundColorAttributeName:[UIColor fc_colorWithHexString:@"ff0066"]} range:[privacyString rangeOfString:NSLocalizedString(@"", @"Privacy Policy")]];
    [privacyTextNode setAttributedText:privacyAttributedString];
    [privacyTextNode setUserInteractionEnabled:YES];
    [privacyTextNode addTarget:self action:@selector(presentPrivacyPolicy) forControlEvents:ASControlNodeEventTouchUpInside];
    
    self.node.layoutSpecBlock = ^ASLayoutSpec *(ASDisplayNode *_Nonnull node, ASSizeRange constrainedSize) {
        [authenticateButton.style setHeight:ASDimensionMake(44)];
        
        [placesIconNode.style setWidth:ASDimensionMake(55)];
        [meetIconNode.style setWidth:ASDimensionMake(55)];
        [disableLocationIconNode.style setWidth:ASDimensionMake(55)];
        [batteryIconNode.style setWidth:ASDimensionMake(55)];
        
        ASStackLayoutSpec *placesStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal spacing:16 justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsStart children:@[placesIconNode, placesTextNode]];
        [placesTextNode.style setFlexShrink:YES];

        ASStackLayoutSpec *meetStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal spacing:16 justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsStart children:@[meetIconNode, meetTextNode]];
        [meetTextNode.style setFlexShrink:YES];
        
        ASStackLayoutSpec *disableLocationStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal spacing:16 justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsStart children:@[disableLocationIconNode, disableLocationTextNode]];
        [disableLocationTextNode.style setFlexShrink:YES];
        
        ASStackLayoutSpec *batteryStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal spacing:16 justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsStart children:@[batteryIconNode, batteryPerformanceTextNode]];
        [batteryPerformanceTextNode.style setFlexShrink:YES];

        
        CGFloat infoStackSpacing = 24;
        if(self.node.constrainedSizeForCalculatedLayout.max.height < 1334){
            infoStackSpacing = 16;
        }
        
        ASStackLayoutSpec *infoStackSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:infoStackSpacing justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsStretch children:@[placesStack, meetStack, disableLocationStack, batteryStack]];
        
        
        CGFloat infoInset = 32;
        if(self.node.constrainedSizeForCalculatedLayout.max.height < 1334){
            infoInset = 16;
        }
        
        ASInsetLayoutSpec *infoInsetSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(infoInset, 0, infoInset, 0) child:infoStackSpec];
        
        ASStackLayoutSpec *stackSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:16 justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsStretch children:@[headerTextNode, infoInsetSpec, privacyTextNode, authenticateButton]];
        
        ASInsetLayoutSpec *insetSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(0, 32, 0, 32) child:stackSpec];
        
        ASCenterLayoutSpec *centerSpec = [ASCenterLayoutSpec centerLayoutSpecWithCenteringOptions:ASCenterLayoutSpecCenteringY sizingOptions:ASCenterLayoutSpecSizingOptionMinimumY child:insetSpec];
        
        return centerSpec;
    };
    return self;
}

- (void)startTwitterAuthentication {
    NSDictionary *twitterConfig = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"TwitterService-Info" ofType:@"plist"]];
    
    [FCTwitterAuthorization authorizeWithConsumerKey:[twitterConfig valueForKey:@"CONSUMER_KEY"] consumerSecret:[twitterConfig valueForKey:@"CONSUMER_SECRET"] callbackURLScheme:[twitterConfig valueForKey:@"URL_SCHEME"] completion:^(FCTwitterCredentials *credentials) {
        if(credentials){
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD showHUDAddedTo:self.node.view animated:YES];
            });
            
            FIRAuthCredential *credential = [FIRTwitterAuthProvider credentialWithToken:credentials.token secret:credentials.secret];
            [[FIRAuth auth] signInWithCredential:credential completion:^(FIRUser *user, NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.node.view animated:YES];
                });
                
                if (error) {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"general.whoops", @"Whoops") message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
                    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"general.gotIt", @"Got it") style:UIAlertActionStyleCancel handler:nil]];
                    [self presentViewController:alert animated:YES completion:nil];
                    return;
                }
                
                if(!user.providerData[0].uid){
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"general.whoops", @"Whoops") message:NSLocalizedString(@"authVC.alert.twitterIDMissing.message", @"Your Twitter ID is missing, please try signing in again.") preferredStyle:UIAlertControllerStyleAlert];
                    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"general.gotIt", @"Got it") style:UIAlertActionStyleCancel handler:nil]];
                    [self presentViewController:alert animated:YES completion:nil];
                    
                    [[FIRAuth auth] signOut:nil];
                    return;
                }
                
                if(!user.providerData[0].displayName){
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"general.whoops", @"Whoops") message:NSLocalizedString(@"authVC.alert.twitterDisplayNameMissing.message", @"Your Twitter display name is missing, please try signing in again.") preferredStyle:UIAlertControllerStyleAlert];
                    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"general.gotIt", @"Got it") style:UIAlertActionStyleCancel handler:nil]];
                    [self presentViewController:alert animated:YES completion:nil];
                    
                    [[FIRAuth auth] signOut:nil];
                    return;
                }
                
                if(!credentials.username){
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"general.whoops", @"Whoops") message:NSLocalizedString(@"authVC.alert.twitterUsername.message", @"Your Twitter username is missing, please try signing in again.") preferredStyle:UIAlertControllerStyleAlert];
                    [alert addAction:[UIAlertAction actionWithTitle:@"Got it" style:UIAlertActionStyleCancel handler:nil]];
                    [self presentViewController:alert animated:YES completion:nil];
                    
                    [[FIRAuth auth] signOut:nil];
                    return;
                }
                
                [[[[[FIRDatabase database] reference] child:@"users"] child:[[[FIRAuth auth] currentUser] uid]] updateChildValues:@{@"name":user.providerData[0].displayName, @"avatar":user.providerData[0].photoURL.absoluteString, @"twitterID":user.providerData[0].uid, @"twitterUsername":credentials.username}];
                
                BOOL privacyOptionEnabled = YES;
                
                if(privacyOptionEnabled){
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"authVC.alert.locationSharing", @"Location Sharing") message:NSLocalizedString(@"authVC.alert.locationSharing.message", @"ConfFriends shares your location with other ConfFriends users. If you wish to simply share your location with friends only, we'd suggest using Find my Friends.\n\nYou can continue to use ConfFriends without sharing your location if you wish.") preferredStyle:UIAlertControllerStyleAlert];
                    
                    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"authVC.alert.locationSharing.share", @"Share My Location") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"DDFLocationDisabled"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        
                        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                        [appDelegate fetchLocationChanges];
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"DDFOnboardingCompleted" object:nil];

                        [self dismissViewControllerAnimated:YES completion:nil];
                    }]];
                    
                    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"authVC.alert.locationSharing.dontShare", @"Don't Share Location") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"DDFLocationDisabled"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        
                        FIRDatabaseReference *userRef = [[[[FIRDatabase database] reference] child:@"users"] child:[[[FIRAuth auth] currentUser] uid]];
                        [[userRef child:@"latitude"] removeValue];
                        [[userRef child:@"longitude"] removeValue];
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"DDFOnboardingCompleted" object:nil];
                        
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }]];
                    [self presentViewController:alert animated:YES completion:nil];
                } else {
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
            }];
        } else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"general.whoops", @"Whoops") message:NSLocalizedString(@"authVC.alert.otherError.message", @"An error occured authenticating.") preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"general.gotIt", @"Got it") style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
}

- (void)presentPrivacyPolicy {
    PrivacyViewController *privacyView = [[PrivacyViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:privacyView];
    [self presentViewController:navController animated:YES completion:nil];
}

@end
