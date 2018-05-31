//
//  NSUserDefaults+MKMapRect.m
//  WWDC Family
//
//  Created by Andrew Yates on 5/16/18.
//  Copyright © 2018 AndyDev. All rights reserved.
//

#import "NSUserDefaults+MKMapRect.h"

@implementation NSUserDefaults (MKMapRect)

- (void)setMapRect:(MKMapRect)mapRect forKey:(NSString *)key {
    NSMutableDictionary *d = [NSMutableDictionary dictionary];
    [d setObject:[NSNumber numberWithDouble:mapRect.origin.x] forKey:@"x"];
    [d setObject:[NSNumber numberWithDouble:mapRect.origin.y] forKey:@"y"];
    [d setObject:[NSNumber numberWithDouble:mapRect.size.width] forKey:@"width"];
    [d setObject:[NSNumber numberWithDouble:mapRect.size.height] forKey:@"height"];
    
    [self setObject:d forKey:key];
}

- (MKMapRect)mapRectForKey:(NSString *)key {
    NSDictionary *d = [self dictionaryForKey:key];
    if(!d){
        return MKMapRectNull;
    }
    return MKMapRectMake([[d objectForKey:@"x"] doubleValue],
                         [[d objectForKey:@"y"] doubleValue],
                         [[d objectForKey:@"width"] doubleValue],
                         [[d objectForKey:@"height"] doubleValue]);
}

@end
