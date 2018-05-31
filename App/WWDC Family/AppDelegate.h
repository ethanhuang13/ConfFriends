//
//  AppDelegate.h
//  WWDC Family
//
//  Created by Andrew Yates on 4/28/18.
//  Copyright © 2018 AndyDev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)fetchLocationChanges;
- (void)stopLocationUpdates;
- (void)resetLocationUpdates;

@end

