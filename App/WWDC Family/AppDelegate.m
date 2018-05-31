//
//  AppDelegate.m
//  WWDC Family
//
//  Created by Andrew Yates on 4/28/18.
//  Copyright © 2018 AndyDev. All rights reserved.
//

#import "AppDelegate.h"
#import "MapViewController.h"
#import "AuthViewController.h"
#import "INTULocationManager.h"
#import "FCTwitterAuthorization.h"
#import "NSUserDefaults+MKMapRect.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "DDFDateValueTransformer.h"

static const NSInteger MINUTES_STORAGE_THRESHHOLD = 1;

@interface AppDelegate ()

@property (assign, nonatomic) INTULocationRequestID locationRequestID;
@property (assign, nonatomic) INTULocationRequestID significantRequestID;
@property (nonatomic) NSInteger lastLocationUpdateTime;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [FIRApp configure];
    
    [Fabric with:@[[Crashlytics class]]];
    
    [[UINavigationBar appearance] setTranslucent:NO];
    [[UINavigationBar appearance] setTintColor:[UIColor fc_colorWithHexString:@"ff0066"]];
    [[UIWindow appearance] setTintColor:[UIColor fc_colorWithHexString:@"ff0066"]];
    [[UISearchBar appearance] setTintColor:[UIColor fc_colorWithHexString:@"ff0066"]];
    
    [NSValueTransformer setValueTransformer:[DDFDateValueTransformer new] forName:kPlankDateValueTransformerKey];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [MapViewController new];
    [self.window makeKeyAndVisible];
    
    if([[FIRAuth auth] currentUser] == nil){
        [self.window.rootViewController presentViewController:[AuthViewController new] animated:NO completion:nil];
    } else {
        if([launchOptions objectForKey:UIApplicationLaunchOptionsLocationKey]){
            [self fetchSignificantLocationChanges];
        } else {
            [self fetchLocationChanges];
        }
    }
    
    return YES;
}

- (void)fetchSignificantLocationChanges {
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"DDFLocationDisabled"]) return;

    INTULocationManager *locMgr = [INTULocationManager sharedInstance];
    self.significantRequestID = [locMgr subscribeToSignificantLocationChangesWithBlock:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
        if (status == INTULocationStatusSuccess) {
            [self storeLocation:currentLocation];
        }
    }];
}

- (void)fetchLocationChanges {
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"DDFLocationDisabled"]) return;
    
    INTULocationAccuracy accuracy = INTULocationAccuracyBlock;
    if([[NSUserDefaults standardUserDefaults] valueForKey:@"DDFAccuracy"]){
        accuracy = [[NSUserDefaults standardUserDefaults] integerForKey:@"DDFAccuracy"];
    }
    
    self.locationRequestID = [[INTULocationManager sharedInstance] subscribeToLocationUpdatesWithDesiredAccuracy:accuracy block:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
        if (status == INTULocationStatusSuccess) {
            [self storeLocation:currentLocation];
        } else {
            // TODO:
        }
    }];
}

- (void)storeLocation:(CLLocation *)currentLocation {
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"DDFLocationDisabled"]) return;

    if([[NSUserDefaults standardUserDefaults] valueForKey:@"DDFPrivacyZone"]){
        MKMapPoint currentMapPoint = MKMapPointForCoordinate(currentLocation.coordinate);
        if(MKMapRectContainsPoint([[NSUserDefaults standardUserDefaults] mapRectForKey:@"DDFPrivacyZone"], currentMapPoint)){
            return;
        }
    }
    
    // Only update if we have passed X minutes
    NSInteger currentSeconds = [[NSDate date] timeIntervalSince1970];
    NSInteger difference = (NSInteger)(currentSeconds - self.lastLocationUpdateTime);
    NSInteger minutes = (NSInteger)(difference/60);
    
    if(minutes < MINUTES_STORAGE_THRESHHOLD){
        return;
    }
    
    if([[[FIRAuth auth] currentUser] uid]){
        [[[[[FIRDatabase database] reference] child:@"users"] child:[[[FIRAuth auth] currentUser] uid]] updateChildValues:@{@"latitude":@(currentLocation.coordinate.latitude), @"longitude":@(currentLocation.coordinate.longitude), @"updatedAt":@([[NSDate new] timeIntervalSince1970])}];
    }
    
    self.lastLocationUpdateTime = [[NSDate date] timeIntervalSince1970];
}

- (void)stopLocationUpdates {
    [[INTULocationManager sharedInstance] cancelLocationRequest:self.locationRequestID];
    self.locationRequestID = NSNotFound;
    
    [[INTULocationManager sharedInstance] cancelLocationRequest:self.significantRequestID];
    self.significantRequestID = NSNotFound;
}

- (void)resetLocationUpdates {
    [self stopLocationUpdates];
    [self fetchLocationChanges];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [self stopLocationUpdates];
    [self fetchSignificantLocationChanges];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [self stopLocationUpdates];
    [self fetchLocationChanges];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    [FCTwitterAuthorization callbackURLReceived:url];
    return YES;
}


@end
