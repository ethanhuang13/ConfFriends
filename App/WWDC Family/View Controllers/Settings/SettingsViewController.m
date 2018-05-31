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
#import "PrivacyViewController.h"

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
    return 4;
}

- (NSInteger)tableNode:(ASTableNode *)tableNode numberOfRowsInSection:(NSInteger)section {
    if(section == 0) return 1;
    if(section == 1) return 1;
    if(section == 2) return 2;
    if(section == 3) return 4;
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(section == 0) return @"Privacy Zone";
    if(section == 1) return @"Location";
    if(section == 2) return @"Account Options";
    if(section == 3) return @"Misc";
    return @"";
}

- (ASCellNodeBlock)tableNode:(ASTableNode *)tableNode nodeBlockForRowAtIndexPath:(NSIndexPath *)indexPath {
    ASCellNode *(^ASCellNodeBlock)(void) = ^ASCellNode *() {
        ASTextCellNode *cell = [[ASTextCellNode alloc] init];
        if(indexPath.section == 0){
            if([[NSUserDefaults standardUserDefaults] valueForKey:@"DDFPrivacyZone"]){
                [cell setText:@"Change Privacy Zone"];
            } else {
                [cell setText:@"Set Privacy Zone"];
            }
        } else if(indexPath.section == 1){
            [cell setText:@"Change Location Accuracy"];
        } else if(indexPath.section == 2){
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
        PrivacyZoneViewController *privacyZoneView = [[PrivacyZoneViewController alloc] init];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:privacyZoneView];
        [self presentViewController:navController animated:YES completion:nil];
    } else if(indexPath.section == 1){
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
    } else if(indexPath.section == 2){
        if(indexPath.row == 0){
            [self deleteUser];
        } else {
            [self signoutUser];
        }
    } else if(indexPath.section == 3){
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
            SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:@"https://twitter.com/intent/user?screen_name=ay8s"]];
            [self presentViewController:safariVC animated:YES completion:nil];
        } else if(indexPath.row == 2){
            UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:@[[NSURL URLWithString:@"https://wwdc.family"]] applicationActivities:nil];
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
                ASCellNode *node = [self tableNode:tableNode nodeForRowAtIndexPath:indexPath];
                activityVC.popoverPresentationController.sourceView = node.view;
            } else {
                [self presentViewController:activityVC animated:YES completion:nil];
            }
        } else {
            [self presentPrivacyPolicy];
        }
    }
    [self.tableNode deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)deleteUser {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Are you sure?" message:@"Your account will be deleted along with your user profile. You'll be able to signup again at anytime." preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
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

- (void)presentPrivacyPolicy {
    PrivacyViewController *privacyView = [[PrivacyViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:privacyView];
    [self presentViewController:navController animated:YES completion:nil];
}


- (void)dismissView {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
