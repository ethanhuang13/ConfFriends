//
//  UsersViewController.h
//  WWDC Family
//
//  Created by Andrew Yates on 5/18/18.
//  Copyright © 2018 AndyDev. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

@protocol UsersViewControllerDelegate <NSObject>

@optional

- (void)ddf_didSelectUser:(DDFUser *)user;

@end

@interface UsersViewController : ASViewController

@property (nonatomic, weak) id<UsersViewControllerDelegate> delegate;

@end
