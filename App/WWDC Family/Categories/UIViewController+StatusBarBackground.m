//
//  UIViewController+StatusBarBackground.m
//  SF iOS
//
//  Created by Amit Jain on 8/8/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import "UIViewController+StatusBarBackground.h"

@implementation UIViewController (StatusBarBackground)

- (void)addStatusBarBlurBackground {
    UIVisualEffectView *statusBarBackground = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
    statusBarBackground.translatesAutoresizingMaskIntoConstraints = false;
    [self.view addSubview:statusBarBackground];
    
    [statusBarBackground.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = true;
    [statusBarBackground.leftAnchor constraintEqualToAnchor:self.view.leftAnchor].active = true;
    [statusBarBackground.rightAnchor constraintEqualToAnchor:self.view.rightAnchor].active = true;
    [statusBarBackground.heightAnchor constraintEqualToConstant:[[UIApplication sharedApplication] statusBarFrame].size.height].active = true;
}

@end
