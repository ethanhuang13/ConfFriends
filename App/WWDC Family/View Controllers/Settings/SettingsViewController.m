//
//  SettingsViewController.m
//  WWDC Family
//
//  Created by Andrew Yates on 5/12/18.
//  Copyright © 2018 AndyDev. All rights reserved.
//

#import "SettingsViewController.h"
#import "AuthViewController.h"
#import "AppDelegate.h"
#import <SafariServices/SFSafariViewController.h>
#import "PrivacyZoneViewController.h"
#import "CountryViewController.h"
#import "FuzzingViewController.h"
#import "FCTwitterAuthorization.h"
#import "MBProgressHUD.h"
#import "Archiver.h"
#import "STTwitterAPI.h"

@interface SettingsViewController () <ASTableDataSource, ASTableDelegate>

@property (strong, nonatomic) ASTableNode *tableNode;

@end

@implementation SettingsViewController

- (instancetype)init {
    ASTableNode *tableNode = [[ASTableNode alloc] initWithStyle:UITableViewStyleGrouped];
    if (!(self = [super initWithNode:tableNode]))
        return nil;
    
    self.title = @"Settings";
    
    [self.node setBackgroundColor:[UIColor fc_colorWithHexString:@"#f7f7f7"]];
    [self.node setAutomaticallyManagesSubnodes:YES];
    
    self.tableNode = tableNode;
    self.tableNode.delegate = self;
    self.tableNode.dataSource = self;
    [self.tableNode.view setSeparatorInset:UIEdgeInsetsMake(0, 16, 0, 0)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(dismissView)];
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableNode reloadData];
}

#pragma mark - Table Data Source

- (NSInteger)numberOfSectionsInTableNode:(ASTableNode *)tableNode {
    return 5;
}

- (NSInteger)tableNode:(ASTableNode *)tableNode numberOfRowsInSection:(NSInteger)section {
    if(section == 0) return 2;
    if(section == 1){
        if([[NSUserDefaults standardUserDefaults] boolForKey:@"DDFTwitterFriendFilter"]){
            return 2;
        } else {
            return 1;
        }
    }
    if(section == 2) return 2;
    if(section == 3) return 1;
    if(section == 4) return 2;
    if(section == 5) return 4;
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(section == 0) return @"Profile";
    if(section == 1) return @"Filter";
    if(section == 2) return @"Privacy";
    if(section == 3) return @"Location";
    if(section == 4) return @"Account Options";
    if(section == 5) return @"Misc";
    return @"";
}

- (ASCellNodeBlock)tableNode:(ASTableNode *)tableNode nodeBlockForRowAtIndexPath:(NSIndexPath *)indexPath {
    ASCellNode *(^ASCellNodeBlock)(void) = ^ASCellNode *() {
        ASTextCellNode *cell = [[ASTextCellNode alloc] init];
        if(indexPath.section == 0){
            if(indexPath.row == 0){
                [cell setText:@"Change Name"];
            } else if(indexPath.row == 1){
                [cell setText:@"Set Country"];
            }
        } else if(indexPath.section == 1){
            if([[NSUserDefaults standardUserDefaults] boolForKey:@"DDFTwitterFriendFilter"]){
                if(indexPath.row == 0){
                    [cell setText:@"Disable Twitter Following Filter"];
                } else {
                    [cell setText:@"Refresh Twitter Following List"];
                }
            } else {
                if([Archiver retrieve:@"DDFTwitterFriends"]){
                    [cell setText:@"Enable Twitter Following Filter"];
                } else {
                    [cell setText:@"Setup Twitter Following Filter"];
                }
            }
        } else if(indexPath.section == 2){
            if(indexPath.row == 0){
                if([[NSUserDefaults standardUserDefaults] valueForKey:@"DDFPrivacyZone"]){
                    [cell setText:@"Change/Remove Privacy Zone"];
                } else {
                    [cell setText:@"Set Privacy Zone"];
                }
            } else if(indexPath.row == 1){
                [cell setText:@"Location Fuzzing"];
            }
        } else if(indexPath.section == 3){
            [cell setText:@"Change Location Accuracy"];
        } else if(indexPath.section == 4){
            if(indexPath.row == 0){
                [cell setText:@"Delete Account"];
            } else if(indexPath.row == 1){
                [cell setText:@"Signout"];
            }
        } else {
            if(indexPath.row == 0){
                [cell setText:@"About ConfFriends"];
            } else if(indexPath.row == 1){
                [cell setText:@"Send Feedback"];
            } else if(indexPath.row == 2){
                [cell setText:@"Share ConfFriends"];
            } else if(indexPath.row == 3){
                [cell setText:@"Privacy Policy"];
            }
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [cell setBackgroundColor:[UIColor whiteColor]];
        return cell;
    };
    return ASCellNodeBlock;
}

- (void)tableNode:(ASTableNode *)tableNode didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0){
        if(indexPath.row == 0){
            [self presentNameAlert];
        } else {
            CountryViewController *countryView = [[CountryViewController alloc] init];
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:countryView];
            [self presentViewController:navController animated:YES completion:nil];
        }
    } else if(indexPath.section == 1){
        if([[NSUserDefaults standardUserDefaults] boolForKey:@"DDFTwitterFriendFilter"]){
            if(indexPath.row == 0){
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"DDFTwitterFriendFilter"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"DDFFilterChanged" object:nil];
                
                [self.tableNode reloadData];
            } else {
                [self setupTwitterFilter];
            }
        } else {
            if([Archiver retrieve:@"DDFTwitterFriends"]){
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"DDFTwitterFriendFilter"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"DDFFilterChanged" object:nil];
                
                [self.tableNode reloadData];
            } else {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Setup Filter" message:@"The Twitter Following Filter will allow you to see only people you follow on Twitter that also use ConfFriends. We'll need to re-authenticate you to fetch your following list to store on the device.\n\nYou can disable/enable anytime once setup." preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"Setup" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self setupTwitterFilter];
                }]];
                [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }
    } else if(indexPath.section == 2){
        if(indexPath.row == 0){
            PrivacyZoneViewController *privacyZoneView = [[PrivacyZoneViewController alloc] init];
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:privacyZoneView];
            [self presentViewController:navController animated:YES completion:nil];
        } else {
            FuzzingViewController *fuzzingView = [[FuzzingViewController alloc] init];
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:fuzzingView];
            [self presentViewController:navController animated:YES completion:nil];
        }
    } else if(indexPath.section == 3){
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        UIAlertController *alert;
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            alert = [UIAlertController alertControllerWithTitle:@"Location Accuracy" message:@"Select a location accuracy, higher accuracy options will use more power." preferredStyle:UIAlertControllerStyleAlert];
        } else {
            alert = [UIAlertController alertControllerWithTitle:@"Location Accuracy" message:@"Select a location accuracy, higher accuracy options will use more power." preferredStyle:UIAlertControllerStyleActionSheet];
        }
            
        [alert addAction:[UIAlertAction actionWithTitle:@"5 meters or better" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[NSUserDefaults standardUserDefaults] setValue:@(INTULocationAccuracyRoom) forKey:@"DDFAccuracy"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [appDelegate resetLocationUpdates];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"15 meters or better" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[NSUserDefaults standardUserDefaults] setValue:@(INTULocationAccuracyHouse) forKey:@"DDFAccuracy"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [appDelegate resetLocationUpdates];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"100 meters or better" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[NSUserDefaults standardUserDefaults] setValue:@(INTULocationAccuracyBlock) forKey:@"DDFAccuracy"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [appDelegate resetLocationUpdates];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"1000 meters or better" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[NSUserDefaults standardUserDefaults] setValue:@(INTULocationAccuracyNeighborhood) forKey:@"DDFAccuracy"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [appDelegate resetLocationUpdates];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"5000 Meters or better" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[NSUserDefaults standardUserDefaults] setValue:@(INTULocationAccuracyCity) forKey:@"DDFAccuracy"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [appDelegate resetLocationUpdates];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
        
        [self presentViewController:alert animated:YES completion:nil];
    } else if(indexPath.section == 4){
        if(indexPath.row == 0){
            [self deleteUser];
        } else {
            [self signoutUser];
        }
    } else if(indexPath.section == 5){
        if(indexPath.row == 0){
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"About" message:@"Building upon past WWDC Family apps, ConfFriends was built for privacy and performance in mind by Andrew Yates (@ay8s) using Texture & Firebase, inspired by Felix Krause's (@KrauseFx) past iteration.\n\nConfFriends will be available on GitHub shortly." preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"@ay8s on Twitter" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSString *handle = @"ay8s";
                
                if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetbot://"]]) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tweetbot://%@/user_profile/%@", handle, handle]] options:@{} completionHandler:^(BOOL success) {
                        
                    }];
                } else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter://"]]) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"twitter://user?screen_name=" stringByAppendingString:handle]] options:@{} completionHandler:^(BOOL success) {
                        
                    }];
                } else {
                    SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://twitter.com/intent/user?screen_name=%@", handle]]];
                    [self presentViewController:safariVC animated:YES completion:nil];
                }
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"@KrauseFx on Twitter" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSString *handle = @"KrauseFx";
                
                if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetbot://"]]) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tweetbot://%@/user_profile/%@", handle, handle]] options:@{} completionHandler:^(BOOL success) {
                        
                    }];
                } else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter://"]]) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"twitter://user?screen_name=" stringByAppendingString:handle]] options:@{} completionHandler:^(BOOL success) {
                        
                    }];
                } else {
                    SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://twitter.com/intent/user?screen_name=%@", handle]]];
                    [self presentViewController:safariVC animated:YES completion:nil];
                }
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
        } else if(indexPath.row == 1){
            NSString *handle = @"ay8s";
            
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetbot://"]]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tweetbot://%@/user_profile/%@", handle, handle]] options:@{} completionHandler:^(BOOL success) {
                    
                }];
            } else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter://"]]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"twitter://user?screen_name=" stringByAppendingString:handle]] options:@{} completionHandler:^(BOOL success) {
                    
                }];
            } else {
                SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://twitter.com/intent/user?screen_name=%@", handle]]];
                [self presentViewController:safariVC animated:YES completion:nil];
            }
        } else if(indexPath.row == 2){
            UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:@[[NSURL URLWithString:@"https://wwdc.family"]] applicationActivities:nil];
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
                ASCellNode *node = [self tableNode:tableNode nodeForRowAtIndexPath:indexPath];
                activityVC.popoverPresentationController.sourceView = node.view;
            } else {
                [self presentViewController:activityVC animated:YES completion:nil];
            }
        } else {
            SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:@"https://wwdc.family/privacy.html"]];
            [self presentViewController:safariVC animated:YES completion:nil];
        }
    }
    [self.tableNode deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)deleteUser {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Are you sure?" message:@"Your account will be deleted along with your user profile. You'll be able to signup again at anytime." preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [appDelegate stopLocationUpdates];
        
        [[[[[FIRDatabase database] reference] child:@"users"] child:[[[FIRAuth auth] currentUser] uid]] removeValue];
        
        [[[FIRAuth auth] currentUser] deleteWithCompletion:^(NSError * _Nullable error) {
            if(error){
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Whoops" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
                [self presentViewController:alert animated:YES completion:nil];
            } else {
                [self dismissViewControllerAnimated:YES completion:^{
                    [appDelegate.window.rootViewController presentViewController:[AuthViewController new] animated:YES completion:nil];
                }];
            }
        }];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)signoutUser {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    [[FIRAuth auth] signOut:nil];
    [self dismissViewControllerAnimated:YES completion:^{
        [appDelegate.window.rootViewController presentViewController:[AuthViewController new] animated:YES completion:nil];
    }];
}

- (void)presentNameAlert {
    [[[[[FIRDatabase database] reference] child:@"users"] child:[[[FIRAuth auth] currentUser] uid]] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if(snapshot.exists){
            DDFUser *user = [[DDFUser alloc] initWithModelDictionary:snapshot.value];
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Change Name" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            
            [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                [textField setPlaceholder:@"Name"];
                [textField setText:user.name];
            }];
            
            UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if([alertController.textFields.firstObject.text isEqualToString:@""]){
                    return;
                }
                [[[[[FIRDatabase database] reference] child:@"users"] child:[[[FIRAuth auth] currentUser] uid]] updateChildValues:@{@"name":alertController.textFields.firstObject.text}];

            }];
            [alertController addAction:saveAction];

            [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }];
}

- (void)setupTwitterFilter {
    NSDictionary *twitterConfig = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"TwitterService-Info" ofType:@"plist"]];

    [FCTwitterAuthorization authorizeWithConsumerKey:[twitterConfig valueForKey:@"CONSUMER_KEY"] consumerSecret:[twitterConfig valueForKey:@"CONSUMER_SECRET"] callbackURLScheme:[twitterConfig valueForKey:@"URL_SCHEME"] completion:^(FCTwitterCredentials *credentials) {
        if(credentials){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD showHUDAddedTo:self.node.view animated:YES];
            });
            
            STTwitterAPI *twitter = [STTwitterAPI twitterAPIWithOAuthConsumerKey:[twitterConfig valueForKey:@"CONSUMER_KEY"] consumerSecret:[twitterConfig valueForKey:@"CONSUMER_SECRET"] oauthToken:credentials.token oauthTokenSecret:credentials.secret];
            
            [twitter getFriendsIDsForUserID:nil orScreenName:credentials.username cursor:nil count:@"5000" successBlock:^(NSArray *ids, NSString *previousCursor, NSString *nextCursor) {
                
                if([ids count] != 0){                    
                    [Archiver persist:ids key:@"DDFTwitterFriends"];
                    
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"DDFTwitterFriendFilter"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"DDFFilterChanged" object:nil];
                    
                    [self.tableNode reloadData];
                }
                    
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.node.view animated:YES];
                });
            } errorBlock:^(NSError *error) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Whoops" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"Got it" style:UIAlertActionStyleCancel handler:nil]];
                [self presentViewController:alert animated:YES completion:nil];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.node.view animated:YES];
                });
            }];
        } else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Whoops" message:@"An error occured authenticating." preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"Got it" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
}

- (void)dismissView {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
