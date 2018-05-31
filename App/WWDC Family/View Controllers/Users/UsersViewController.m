//
//  UsersViewController.m
//  WWDC Family
//
//  Created by Andrew Yates on 5/18/18.
//  Copyright © 2018 AndyDev. All rights reserved.
//

#import "UsersViewController.h"
#import "UserCellNode.h"
#import <SafariServices/SFSafariViewController.h>

@interface UsersViewController () <ASTableDataSource, ASTableDelegate, UISearchResultsUpdating>

@property (strong, nonatomic) NSString *previousSearch;
@property (strong, nonatomic) ASTableNode *tableNode;
@property (strong, nonatomic) NSMutableArray<DDFUser *> *allUsers;
@property (strong, nonatomic) NSArray<DDFUser *> *filteredUsers;

@end

@implementation UsersViewController

- (instancetype)init {
    ASTableNode *tableNode = [[ASTableNode alloc] initWithStyle:UITableViewStyleGrouped];
    if (!(self = [super initWithNode:tableNode]))
        return nil;
    
    self.title = @"Users";
    self.previousSearch = @"";
    
    [self.node setBackgroundColor:[UIColor fc_colorWithHexString:@"#f7f7f7"]];
    [self.node setAutomaticallyManagesSubnodes:YES];
    
    self.tableNode = tableNode;
    self.tableNode.delegate = self;
    self.tableNode.dataSource = self;
    self.tableNode.displaysAsynchronously = NO;
    
    UISearchController *searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    [searchController setSearchResultsUpdater:self];
    [searchController setDimsBackgroundDuringPresentation:NO];
    [searchController setHidesNavigationBarDuringPresentation:NO];
    [searchController setDefinesPresentationContext:NO];
    self.navigationItem.searchController = searchController;
    self.navigationItem.hidesSearchBarWhenScrolling = NO;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(dismissView)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.allUsers = [NSMutableArray new];
    self.filteredUsers = [NSMutableArray new];
    
    // User Added
    [[[[FIRDatabase database] reference] child:@"users"] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if(snapshot.exists){
            for(NSString *userID in [snapshot.value allKeys]){
                NSMutableDictionary *user = [snapshot.value valueForKey:userID];
                [user addEntriesFromDictionary:@{@"id":userID}];
                [self.allUsers addObject:[[DDFUser alloc] initWithModelDictionary:user]];
            }
            
            // Sort Users
            NSSortDescriptor *userSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
            self.allUsers = [[self.allUsers sortedArrayUsingDescriptors:@[userSortDescriptor]] mutableCopy];
            self.filteredUsers = [self.allUsers copy];
            
            [self.tableNode reloadData];
        }
    }];
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    if(![self.previousSearch isEqualToString:searchController.searchBar.text]){
        self.previousSearch = searchController.searchBar.text;
        
        if(![searchController.searchBar.text isEqualToString:@""]){
            NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"name contains[c] %@ OR twitterUsername contains[c] %@", searchController.searchBar.text, searchController.searchBar.text];
            self.filteredUsers = [self.allUsers filteredArrayUsingPredicate:searchPredicate];
        } else {
            self.filteredUsers = [self.allUsers copy];
        }
        [self.tableNode reloadData];
    }
}

#pragma mark - Table Data Source

- (NSInteger)numberOfSectionsInTableNode:(ASTableNode *)tableNode {
    return 1;
}

- (NSInteger)tableNode:(ASTableNode *)tableNode numberOfRowsInSection:(NSInteger)section {
    return [self.filteredUsers count];
}

- (ASCellNodeBlock)tableNode:(ASTableNode *)tableNode nodeBlockForRowAtIndexPath:(NSIndexPath *)indexPath {
    DDFUser *user = [self.filteredUsers objectAtIndex:indexPath.row];
        
    ASCellNode *(^ASCellNodeBlock)(void) = ^ASCellNode *() {
        UserCellNode *cell = [[UserCellNode alloc] initWithUser:user];
        return cell;
    };
    return ASCellNodeBlock;
}

- (void)tableNode:(ASTableNode *)tableNode didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if([self.navigationItem.searchController isActive]){
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    DDFUser *user = [self.filteredUsers objectAtIndex:indexPath.row];
    if(user.latitude && user.longitude){
        [self dismissViewControllerAnimated:YES completion:^{
            if([self.delegate respondsToSelector:@selector(ddf_didSelectUser:)]){
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                    [self.delegate ddf_didSelectUser:user];
                });
            }
        }];
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Whoops" message:@"This user doesn't currently have a location shared." preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"View on Twitter" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self openUsersTwitter:user];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)openUsersTwitter:(DDFUser *)user {
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

#pragma mark - Keyboard

- (void)keyboardWillShow:(NSNotification *)notification {
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets;
    if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])) {
        contentInsets = UIEdgeInsetsMake(0.0, 0.0, (keyboardSize.height), 0.0);
    } else {
        contentInsets = UIEdgeInsetsMake(0.0, 0.0, (keyboardSize.width), 0.0);
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.tableNode.contentInset = contentInsets;
        self.tableNode.view.scrollIndicatorInsets = contentInsets;
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [UIView animateWithDuration:0.3 animations:^{
        self.tableNode.contentInset = UIEdgeInsetsZero;
        self.tableNode.view.scrollIndicatorInsets = UIEdgeInsetsZero;
    }];
}


- (void)dismissView {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
