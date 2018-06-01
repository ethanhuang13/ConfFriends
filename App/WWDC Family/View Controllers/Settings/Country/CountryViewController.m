//
//  CountryViewController.m
//  WWDC Family
//
//  Created by Andrew Yates on 5/31/18.
//  Copyright © 2018 AndyDev. All rights reserved.
//

#import "CountryViewController.h"

@interface CountryViewController () <ASTableDataSource, ASTableDelegate>

@property (strong, nonatomic) ASTableNode *tableNode;

@end

@implementation CountryViewController

- (instancetype)init {
    ASTableNode *tableNode = [[ASTableNode alloc] initWithStyle:UITableViewStyleGrouped];
    if (!(self = [super initWithNode:tableNode]))
        return nil;
    
    self.title = @"Set Country";
    
    [self.node setBackgroundColor:[UIColor fc_colorWithHexString:@"#f7f7f7"]];
    [self.node setAutomaticallyManagesSubnodes:YES];
    
    self.tableNode = tableNode;
    self.tableNode.delegate = self;
    self.tableNode.dataSource = self;
    self.tableNode.displaysAsynchronously = NO;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(dismissView)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    return self;
}

#pragma mark - Table Data Source

- (NSInteger)numberOfSectionsInTableNode:(ASTableNode *)tableNode {
    return 1;
}

- (NSInteger)tableNode:(ASTableNode *)tableNode numberOfRowsInSection:(NSInteger)section {
    return [[self countryCodes] count];
}

- (ASCellNodeBlock)tableNode:(ASTableNode *)tableNode nodeBlockForRowAtIndexPath:(NSIndexPath *)indexPath {
    ASCellNode *(^ASCellNodeBlock)(void) = ^ASCellNode *() {
        ASTextCellNode *cell = [[ASTextCellNode alloc] init];
        [cell setText:[[self countryNames] objectAtIndex:indexPath.row]];
        [cell setBackgroundColor:[UIColor whiteColor]];
        return cell;
    };
    return ASCellNodeBlock;
}

- (void)tableNode:(ASTableNode *)tableNode didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *countryName = [[self countryNames] objectAtIndex:indexPath.row];
    NSString *countryCode = [[self countryCodes] objectAtIndex:indexPath.row];
    
    [[NSUserDefaults standardUserDefaults] setValue:countryName forKey:@"DDFUserCountry"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[[[[FIRDatabase database] reference] child:@"users"] child:[[[FIRAuth auth] currentUser] uid]] updateChildValues:@{@"countryCode":countryCode, @"country":countryName}];
    [self dismissViewControllerAnimated:YES completion:nil];
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


- (NSArray *)countryNames {
    static NSArray *_countryNames = nil;
    if (!_countryNames) {
        _countryNames = [[[self countryNamesByCode].allValues sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] copy];
    }
    return _countryNames;
}

- (NSArray *)countryCodes {
    static NSArray *_countryCodes = nil;
    if (!_countryCodes) {
        _countryCodes = [[[self countryCodesByName] objectsForKeys:[self countryNames] notFoundMarker:@""] copy];
    }
    return _countryCodes;
}

- (NSDictionary *)countryNamesByCode {
    static NSDictionary *_countryNamesByCode = nil;
    if (!_countryNamesByCode) {
        NSMutableDictionary *namesByCode = [NSMutableDictionary dictionary];
        for (NSString *code in [NSLocale ISOCountryCodes]) {
            NSString *countryName = [[NSLocale currentLocale] displayNameForKey:NSLocaleCountryCode value:code];
            
            //workaround for simulator bug
            if (!countryName) {
                countryName = [[NSLocale localeWithLocaleIdentifier:@"en_US"] displayNameForKey:NSLocaleCountryCode value:code];
            }
            
            namesByCode[code] = countryName ?: code;
        }
        _countryNamesByCode = [namesByCode copy];
    }
    return _countryNamesByCode;
}

- (NSDictionary *)countryCodesByName {
    static NSDictionary *_countryCodesByName = nil;
    if (!_countryCodesByName) {
        NSDictionary *countryNamesByCode = [self countryNamesByCode];
        NSMutableDictionary *codesByName = [NSMutableDictionary dictionary];
        for (NSString *code in countryNamesByCode) {
            codesByName[countryNamesByCode[code]] = code;
        }
        _countryCodesByName = [codesByName copy];
    }
    return _countryCodesByName;
}

@end
