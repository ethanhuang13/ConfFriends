//
//  NSUserDefaults+MKMapRect.h
//  WWDC Family
//
//  Created by Andrew Yates on 5/16/18.
//  Copyright © 2018 AndyDev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface NSUserDefaults (MKMapRect)

- (void)setMapRect:(MKMapRect)mapRect forKey:(NSString *)key;
- (MKMapRect)mapRectForKey:(NSString *)key;

@end
