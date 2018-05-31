//
//  DDFDateValueTransformer.m
//  WWDC Family
//
//  Created by Andrew Yates on 5/21/18.
//  Copyright © 2018 AndyDev. All rights reserved.
//

#import "DDFDateValueTransformer.h"

@implementation DDFDateValueTransformer

+ (Class)transformedValueClass {
    return [NSDate class];
}

+ (BOOL)allowsReverseTransformation {
    return NO; // Optional, plank does not use this
}

- (id)transformedValue:(id)value {
     return [NSDate dateWithTimeIntervalSince1970:[value doubleValue]];
}


@end
