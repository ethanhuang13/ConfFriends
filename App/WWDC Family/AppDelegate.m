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
    
    [FIRDatabase database].persistenceEnabled = YES;
    [[[FIRDatabase database] referenceWithPath:@"users"] keepSynced:YES];
    
    [[UINavigationBar appearance] setTranslucent:NO];
    [[UINavigationBar appearance] setTintColor:[UIColor fc_colorWithHexString:@"ff0066"]];
    [[UIWindow appearance] setTintColor:[UIColor fc_colorWithHexString:@"ff0066"]];
    [[UISearchBar appearance] setTintColor:[UIColor fc_colorWithHexString:@"ff0066"]];
    [[UISegmentedControl appearance] setTintColor:[UIColor fc_colorWithHexString:@"ff0066"]];
    [[UISwitch appearance] setOnTintColor:[UIColor fc_colorWithHexString:@"ff0066"]];
    [[UISlider appearance] setTintColor:[UIColor fc_colorWithHexString:@"ff0066"]];

    
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
    CLLocation *location = currentLocation;
    
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
    
    // Fuzz the location
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"DDFLocationFuzzingEnabled"]){
        // Are we within the radius set?
        NSInteger radius = [[NSUserDefaults standardUserDefaults] integerForKey:@"DDFLocationFuzzingRadius"];
        CLLocationDistance distance = [location distanceFromLocation:[[CLLocation alloc] initWithLatitude:37.328979 longitude:-121.888955]];
        if(distance > radius){
            // Fluff
            if(![[NSUserDefaults standardUserDefaults] integerForKey:@"DDFLocationFuzzingBearing"]){
                NSInteger randomNumber = arc4random() % 359;

                [[NSUserDefaults standardUserDefaults] setInteger:randomNumber forKey:@"DDFLocationFuzzingBearing"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            
            NSInteger bearing = [[NSUserDefaults standardUserDefaults] integerForKey:@"DDFLocationFuzzingBearing"];
            NSInteger distance = [[NSUserDefaults standardUserDefaults] integerForKey:@"DDFLocationFuzzingDistance"];
            
            CLLocationCoordinate2D coord = [self locationWithBearing:bearing distance:distance fromLocation:location.coordinate];
            location = [[CLLocation alloc] initWithLatitude:coord.latitude longitude:coord.longitude];
        }
    }
    
    if([[[FIRAuth auth] currentUser] uid]){
        [[[[[FIRDatabase database] reference] child:@"users"] child:[[[FIRAuth auth] currentUser] uid]] updateChildValues:@{@"latitude":@(location.coordinate.latitude), @"longitude":@(location.coordinate.longitude), @"updatedAt":@([[NSDate new] timeIntervalSince1970])}];
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

- (CLLocationCoordinate2D)locationWithBearing:(float)bearing distance:(float)distanceMeters fromLocation:(CLLocationCoordinate2D)origin {
    CLLocationCoordinate2D target;
    const double distRadians = distanceMeters / (6372797.6); // earth radius in meters
    
    float lat1 = origin.latitude * M_PI / 180;
    float lon1 = origin.longitude * M_PI / 180;
    
    float lat2 = asin( sin(lat1) * cos(distRadians) + cos(lat1) * sin(distRadians) * cos(bearing));
    float lon2 = lon1 + atan2( sin(bearing) * sin(distRadians) * cos(lat1),
                              cos(distRadians) - sin(lat1) * sin(lat2) );
    
    target.latitude = lat2 * 180 / M_PI;
    target.longitude = lon2 * 180 / M_PI; // no need to normalize a heading in degrees to be within -179.999999° to 180.00000°
    
    return target;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    [FCTwitterAuthorization callbackURLReceived:url];
    return YES;
}


@end
