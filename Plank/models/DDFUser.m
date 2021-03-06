//
//  DDFUser.m
//  Autogenerated by plank
//
//  DO NOT EDIT - EDITS WILL BE OVERWRITTEN
//  @generated
//

#import "DDFUser.h"

struct DDFUserDirtyProperties {
    unsigned int DDFUserDirtyPropertyAvatar:1;
    unsigned int DDFUserDirtyPropertyCountry:1;
    unsigned int DDFUserDirtyPropertyCountryCode:1;
    unsigned int DDFUserDirtyPropertyCreatedAt:1;
    unsigned int DDFUserDirtyPropertyIdentifier:1;
    unsigned int DDFUserDirtyPropertyLatitude:1;
    unsigned int DDFUserDirtyPropertyLongitude:1;
    unsigned int DDFUserDirtyPropertyName:1;
    unsigned int DDFUserDirtyPropertyTwitterID:1;
    unsigned int DDFUserDirtyPropertyTwitterUsername:1;
    unsigned int DDFUserDirtyPropertyUpdatedAt:1;
};

@interface DDFUser ()
@property (nonatomic, assign, readwrite) struct DDFUserDirtyProperties userDirtyProperties;
@end

@interface DDFUserBuilder ()
@property (nonatomic, assign, readwrite) struct DDFUserDirtyProperties userDirtyProperties;
@end

@implementation DDFUser
+ (NSString *)className
{
    return @"DDFUser";
}
+ (NSString *)polymorphicTypeIdentifier
{
    return @"user";
}
+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dictionary
{
    return [[self alloc] initWithModelDictionary:dictionary];
}
- (instancetype)init
{
    return [self initWithModelDictionary:@{}];
}
- (instancetype)initWithModelDictionary:(NS_VALID_UNTIL_END_OF_SCOPE NSDictionary *)modelDictionary
{
    NSParameterAssert(modelDictionary);
    if (!modelDictionary) {
        return self;
    }
    if (!(self = [super init])) {
        return self;
    }
        {
            __unsafe_unretained id value = modelDictionary[@"avatar"]; // Collection will retain.
            if (value != nil) {
                if (value != (id)kCFNull) {
                    self->_avatar = [NSURL URLWithString:value];
                }
                self->_userDirtyProperties.DDFUserDirtyPropertyAvatar = 1;
            }
        }
        {
            __unsafe_unretained id value = modelDictionary[@"country"]; // Collection will retain.
            if (value != nil) {
                if (value != (id)kCFNull) {
                    self->_country = [value copy];
                }
                self->_userDirtyProperties.DDFUserDirtyPropertyCountry = 1;
            }
        }
        {
            __unsafe_unretained id value = modelDictionary[@"countryCode"]; // Collection will retain.
            if (value != nil) {
                if (value != (id)kCFNull) {
                    self->_countryCode = [value copy];
                }
                self->_userDirtyProperties.DDFUserDirtyPropertyCountryCode = 1;
            }
        }
        {
            __unsafe_unretained id value = modelDictionary[@"createdAt"]; // Collection will retain.
            if (value != nil) {
                if (value != (id)kCFNull) {
                    self->_createdAt = [[NSValueTransformer valueTransformerForName:kPlankDateValueTransformerKey] transformedValue:value];
                }
                self->_userDirtyProperties.DDFUserDirtyPropertyCreatedAt = 1;
            }
        }
        {
            __unsafe_unretained id value = modelDictionary[@"id"]; // Collection will retain.
            if (value != nil) {
                if (value != (id)kCFNull) {
                    self->_identifier = [value copy];
                }
                self->_userDirtyProperties.DDFUserDirtyPropertyIdentifier = 1;
            }
        }
        {
            __unsafe_unretained id value = modelDictionary[@"latitude"]; // Collection will retain.
            if (value != nil) {
                if (value != (id)kCFNull) {
                    self->_latitude = [value doubleValue];
                }
                self->_userDirtyProperties.DDFUserDirtyPropertyLatitude = 1;
            }
        }
        {
            __unsafe_unretained id value = modelDictionary[@"longitude"]; // Collection will retain.
            if (value != nil) {
                if (value != (id)kCFNull) {
                    self->_longitude = [value doubleValue];
                }
                self->_userDirtyProperties.DDFUserDirtyPropertyLongitude = 1;
            }
        }
        {
            __unsafe_unretained id value = modelDictionary[@"name"]; // Collection will retain.
            if (value != nil) {
                if (value != (id)kCFNull) {
                    self->_name = [value copy];
                }
                self->_userDirtyProperties.DDFUserDirtyPropertyName = 1;
            }
        }
        {
            __unsafe_unretained id value = modelDictionary[@"twitterID"]; // Collection will retain.
            if (value != nil) {
                if (value != (id)kCFNull) {
                    self->_twitterID = [value copy];
                }
                self->_userDirtyProperties.DDFUserDirtyPropertyTwitterID = 1;
            }
        }
        {
            __unsafe_unretained id value = modelDictionary[@"twitterUsername"]; // Collection will retain.
            if (value != nil) {
                if (value != (id)kCFNull) {
                    self->_twitterUsername = [value copy];
                }
                self->_userDirtyProperties.DDFUserDirtyPropertyTwitterUsername = 1;
            }
        }
        {
            __unsafe_unretained id value = modelDictionary[@"updatedAt"]; // Collection will retain.
            if (value != nil) {
                if (value != (id)kCFNull) {
                    self->_updatedAt = [[NSValueTransformer valueTransformerForName:kPlankDateValueTransformerKey] transformedValue:value];
                }
                self->_userDirtyProperties.DDFUserDirtyPropertyUpdatedAt = 1;
            }
        }
    if ([self class] == [DDFUser class]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kPlankDidInitializeNotification object:self userInfo:@{ kPlankInitTypeKey : @(PlankModelInitTypeDefault) }];
    }
    return self;
}
- (instancetype)initWithBuilder:(DDFUserBuilder *)builder
{
    NSParameterAssert(builder);
    return [self initWithBuilder:builder initType:PlankModelInitTypeDefault];
}
- (instancetype)initWithBuilder:(DDFUserBuilder *)builder initType:(PlankModelInitType)initType
{
    NSParameterAssert(builder);
    if (!(self = [super init])) {
        return self;
    }
    _avatar = builder.avatar;
    _country = builder.country;
    _countryCode = builder.countryCode;
    _createdAt = builder.createdAt;
    _identifier = builder.identifier;
    _latitude = builder.latitude;
    _longitude = builder.longitude;
    _name = builder.name;
    _twitterID = builder.twitterID;
    _twitterUsername = builder.twitterUsername;
    _updatedAt = builder.updatedAt;
    _userDirtyProperties = builder.userDirtyProperties;
    if ([self class] == [DDFUser class]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kPlankDidInitializeNotification object:self userInfo:@{ kPlankInitTypeKey : @(initType) }];
    }
    return self;
}
- (NSString *)debugDescription
{
    NSArray<NSString *> *parentDebugDescription = [[super debugDescription] componentsSeparatedByString:@"\n"];
    NSMutableArray *descriptionFields = [NSMutableArray arrayWithCapacity:11];
    [descriptionFields addObject:parentDebugDescription];
    struct DDFUserDirtyProperties props = _userDirtyProperties;
    if (props.DDFUserDirtyPropertyAvatar) {
        [descriptionFields addObject:[@"_avatar = " stringByAppendingFormat:@"%@", _avatar]];
    }
    if (props.DDFUserDirtyPropertyCountry) {
        [descriptionFields addObject:[@"_country = " stringByAppendingFormat:@"%@", _country]];
    }
    if (props.DDFUserDirtyPropertyCountryCode) {
        [descriptionFields addObject:[@"_countryCode = " stringByAppendingFormat:@"%@", _countryCode]];
    }
    if (props.DDFUserDirtyPropertyCreatedAt) {
        [descriptionFields addObject:[@"_createdAt = " stringByAppendingFormat:@"%@", _createdAt]];
    }
    if (props.DDFUserDirtyPropertyIdentifier) {
        [descriptionFields addObject:[@"_identifier = " stringByAppendingFormat:@"%@", _identifier]];
    }
    if (props.DDFUserDirtyPropertyLatitude) {
        [descriptionFields addObject:[@"_latitude = " stringByAppendingFormat:@"%@", @(_latitude)]];
    }
    if (props.DDFUserDirtyPropertyLongitude) {
        [descriptionFields addObject:[@"_longitude = " stringByAppendingFormat:@"%@", @(_longitude)]];
    }
    if (props.DDFUserDirtyPropertyName) {
        [descriptionFields addObject:[@"_name = " stringByAppendingFormat:@"%@", _name]];
    }
    if (props.DDFUserDirtyPropertyTwitterID) {
        [descriptionFields addObject:[@"_twitterID = " stringByAppendingFormat:@"%@", _twitterID]];
    }
    if (props.DDFUserDirtyPropertyTwitterUsername) {
        [descriptionFields addObject:[@"_twitterUsername = " stringByAppendingFormat:@"%@", _twitterUsername]];
    }
    if (props.DDFUserDirtyPropertyUpdatedAt) {
        [descriptionFields addObject:[@"_updatedAt = " stringByAppendingFormat:@"%@", _updatedAt]];
    }
    return [NSString stringWithFormat:@"DDFUser = {\n%@\n}", debugDescriptionForFields(descriptionFields)];
}
- (instancetype)copyWithBlock:(PLANK_NOESCAPE void (^)(DDFUserBuilder *builder))block
{
    NSParameterAssert(block);
    DDFUserBuilder *builder = [[DDFUserBuilder alloc] initWithModel:self];
    block(builder);
    return [builder build];
}
- (BOOL)isEqual:(id)anObject
{
    if (self == anObject) {
        return YES;
    }
    if ([anObject isKindOfClass:[DDFUser class]] == NO) {
        return NO;
    }
    return [self isEqualToUser:anObject];
}
- (BOOL)isEqualToUser:(DDFUser *)anObject
{
    return (
        (anObject != nil) &&
        (_longitude == anObject.longitude) &&
        (_latitude == anObject.latitude) &&
        (_avatar == anObject.avatar || [_avatar isEqual:anObject.avatar]) &&
        (_country == anObject.country || [_country isEqualToString:anObject.country]) &&
        (_countryCode == anObject.countryCode || [_countryCode isEqualToString:anObject.countryCode]) &&
        (_createdAt == anObject.createdAt || [_createdAt isEqualToDate:anObject.createdAt]) &&
        (_identifier == anObject.identifier || [_identifier isEqualToString:anObject.identifier]) &&
        (_name == anObject.name || [_name isEqualToString:anObject.name]) &&
        (_twitterID == anObject.twitterID || [_twitterID isEqualToString:anObject.twitterID]) &&
        (_twitterUsername == anObject.twitterUsername || [_twitterUsername isEqualToString:anObject.twitterUsername]) &&
        (_updatedAt == anObject.updatedAt || [_updatedAt isEqualToDate:anObject.updatedAt])
    );
}
- (NSUInteger)hash
{
    NSUInteger subhashes[] = {
        17,
        [_avatar hash],
        [_country hash],
        [_countryCode hash],
        [_createdAt hash],
        [_identifier hash],
         [@(_latitude) hash],
         [@(_longitude) hash],
        [_name hash],
        [_twitterID hash],
        [_twitterUsername hash],
        [_updatedAt hash]
    };
    return PINIntegerArrayHash(subhashes, sizeof(subhashes) / sizeof(subhashes[0]));
}
- (instancetype)mergeWithModel:(DDFUser *)modelObject
{
    return [self mergeWithModel:modelObject initType:PlankModelInitTypeFromMerge];
}
- (instancetype)mergeWithModel:(DDFUser *)modelObject initType:(PlankModelInitType)initType
{
    NSParameterAssert(modelObject);
    DDFUserBuilder *builder = [[DDFUserBuilder alloc] initWithModel:self];
    [builder mergeWithModel:modelObject];
    return [[DDFUser alloc] initWithBuilder:builder initType:initType];
}
- (NSDictionary *)dictionaryObjectRepresentation
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:11];
    if (_userDirtyProperties.DDFUserDirtyPropertyAvatar) {
        if (_avatar != (id)kCFNull) {
            [dict setObject:[_avatar absoluteString] forKey:@"avatar"];
        } else {
            [dict setObject:[NSNull null] forKey:@"avatar"];
        }
    }
    if (_userDirtyProperties.DDFUserDirtyPropertyCountry) {
        if (_country != (id)kCFNull) {
            [dict setObject:_country forKey:@"country"];
        } else {
            [dict setObject:[NSNull null] forKey:@"country"];
        }
    }
    if (_userDirtyProperties.DDFUserDirtyPropertyCountryCode) {
        if (_countryCode != (id)kCFNull) {
            [dict setObject:_countryCode forKey:@"countryCode"];
        } else {
            [dict setObject:[NSNull null] forKey:@"countryCode"];
        }
    }
    if (_userDirtyProperties.DDFUserDirtyPropertyCreatedAt) {
        if (_createdAt != (id)kCFNull) {
            NSValueTransformer *valueTransformer = [NSValueTransformer valueTransformerForName:kPlankDateValueTransformerKey];
            if ([[valueTransformer class] allowsReverseTransformation]) {
                [dict setObject:[valueTransformer reverseTransformedValue:_createdAt] forKey:@"createdAt"];
            } else {
                [dict setObject:[NSNull null] forKey:@"createdAt"];
            }
        } else {
            [dict setObject:[NSNull null] forKey:@"createdAt"];
        }
    }
    if (_userDirtyProperties.DDFUserDirtyPropertyIdentifier) {
        if (_identifier != (id)kCFNull) {
            [dict setObject:_identifier forKey:@"id"];
        } else {
            [dict setObject:[NSNull null] forKey:@"id"];
        }
    }
    if (_userDirtyProperties.DDFUserDirtyPropertyLatitude) {
        [dict setObject:@(_latitude) forKey: @"latitude"];
    }
    if (_userDirtyProperties.DDFUserDirtyPropertyLongitude) {
        [dict setObject:@(_longitude) forKey: @"longitude"];
    }
    if (_userDirtyProperties.DDFUserDirtyPropertyName) {
        if (_name != (id)kCFNull) {
            [dict setObject:_name forKey:@"name"];
        } else {
            [dict setObject:[NSNull null] forKey:@"name"];
        }
    }
    if (_userDirtyProperties.DDFUserDirtyPropertyTwitterID) {
        if (_twitterID != (id)kCFNull) {
            [dict setObject:_twitterID forKey:@"twitterID"];
        } else {
            [dict setObject:[NSNull null] forKey:@"twitterID"];
        }
    }
    if (_userDirtyProperties.DDFUserDirtyPropertyTwitterUsername) {
        if (_twitterUsername != (id)kCFNull) {
            [dict setObject:_twitterUsername forKey:@"twitterUsername"];
        } else {
            [dict setObject:[NSNull null] forKey:@"twitterUsername"];
        }
    }
    if (_userDirtyProperties.DDFUserDirtyPropertyUpdatedAt) {
        if (_updatedAt != (id)kCFNull) {
            NSValueTransformer *valueTransformer = [NSValueTransformer valueTransformerForName:kPlankDateValueTransformerKey];
            if ([[valueTransformer class] allowsReverseTransformation]) {
                [dict setObject:[valueTransformer reverseTransformedValue:_updatedAt] forKey:@"updatedAt"];
            } else {
                [dict setObject:[NSNull null] forKey:@"updatedAt"];
            }
        } else {
            [dict setObject:[NSNull null] forKey:@"updatedAt"];
        }
    }
    return dict;
}
#pragma mark - NSCopying
- (id)copyWithZone:(NSZone *)zone
{
    return self;
}
#pragma mark - NSSecureCoding
+ (BOOL)supportsSecureCoding
{
    return YES;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (!(self = [super init])) {
        return self;
    }
    _avatar = [aDecoder decodeObjectOfClass:[NSURL class] forKey:@"avatar"];
    _country = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"country"];
    _countryCode = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"countryCode"];
    _createdAt = [aDecoder decodeObjectOfClass:[NSDate class] forKey:@"createdAt"];
    _identifier = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"id"];
    _latitude = [aDecoder decodeDoubleForKey:@"latitude"];
    _longitude = [aDecoder decodeDoubleForKey:@"longitude"];
    _name = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"name"];
    _twitterID = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"twitterID"];
    _twitterUsername = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"twitterUsername"];
    _updatedAt = [aDecoder decodeObjectOfClass:[NSDate class] forKey:@"updatedAt"];
    _userDirtyProperties.DDFUserDirtyPropertyAvatar = [aDecoder decodeIntForKey:@"avatar_dirty_property"] & 0x1;
    _userDirtyProperties.DDFUserDirtyPropertyCountry = [aDecoder decodeIntForKey:@"country_dirty_property"] & 0x1;
    _userDirtyProperties.DDFUserDirtyPropertyCountryCode = [aDecoder decodeIntForKey:@"countryCode_dirty_property"] & 0x1;
    _userDirtyProperties.DDFUserDirtyPropertyCreatedAt = [aDecoder decodeIntForKey:@"createdAt_dirty_property"] & 0x1;
    _userDirtyProperties.DDFUserDirtyPropertyIdentifier = [aDecoder decodeIntForKey:@"id_dirty_property"] & 0x1;
    _userDirtyProperties.DDFUserDirtyPropertyLatitude = [aDecoder decodeIntForKey:@"latitude_dirty_property"] & 0x1;
    _userDirtyProperties.DDFUserDirtyPropertyLongitude = [aDecoder decodeIntForKey:@"longitude_dirty_property"] & 0x1;
    _userDirtyProperties.DDFUserDirtyPropertyName = [aDecoder decodeIntForKey:@"name_dirty_property"] & 0x1;
    _userDirtyProperties.DDFUserDirtyPropertyTwitterID = [aDecoder decodeIntForKey:@"twitterID_dirty_property"] & 0x1;
    _userDirtyProperties.DDFUserDirtyPropertyTwitterUsername = [aDecoder decodeIntForKey:@"twitterUsername_dirty_property"] & 0x1;
    _userDirtyProperties.DDFUserDirtyPropertyUpdatedAt = [aDecoder decodeIntForKey:@"updatedAt_dirty_property"] & 0x1;
    if ([self class] == [DDFUser class]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kPlankDidInitializeNotification object:self userInfo:@{ kPlankInitTypeKey : @(PlankModelInitTypeDefault) }];
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.avatar forKey:@"avatar"];
    [aCoder encodeObject:self.country forKey:@"country"];
    [aCoder encodeObject:self.countryCode forKey:@"countryCode"];
    [aCoder encodeObject:self.createdAt forKey:@"createdAt"];
    [aCoder encodeObject:self.identifier forKey:@"id"];
    [aCoder encodeDouble:self.latitude forKey:@"latitude"];
    [aCoder encodeDouble:self.longitude forKey:@"longitude"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.twitterID forKey:@"twitterID"];
    [aCoder encodeObject:self.twitterUsername forKey:@"twitterUsername"];
    [aCoder encodeObject:self.updatedAt forKey:@"updatedAt"];
    [aCoder encodeInt:_userDirtyProperties.DDFUserDirtyPropertyAvatar forKey:@"avatar_dirty_property"];
    [aCoder encodeInt:_userDirtyProperties.DDFUserDirtyPropertyCountry forKey:@"country_dirty_property"];
    [aCoder encodeInt:_userDirtyProperties.DDFUserDirtyPropertyCountryCode forKey:@"countryCode_dirty_property"];
    [aCoder encodeInt:_userDirtyProperties.DDFUserDirtyPropertyCreatedAt forKey:@"createdAt_dirty_property"];
    [aCoder encodeInt:_userDirtyProperties.DDFUserDirtyPropertyIdentifier forKey:@"id_dirty_property"];
    [aCoder encodeInt:_userDirtyProperties.DDFUserDirtyPropertyLatitude forKey:@"latitude_dirty_property"];
    [aCoder encodeInt:_userDirtyProperties.DDFUserDirtyPropertyLongitude forKey:@"longitude_dirty_property"];
    [aCoder encodeInt:_userDirtyProperties.DDFUserDirtyPropertyName forKey:@"name_dirty_property"];
    [aCoder encodeInt:_userDirtyProperties.DDFUserDirtyPropertyTwitterID forKey:@"twitterID_dirty_property"];
    [aCoder encodeInt:_userDirtyProperties.DDFUserDirtyPropertyTwitterUsername forKey:@"twitterUsername_dirty_property"];
    [aCoder encodeInt:_userDirtyProperties.DDFUserDirtyPropertyUpdatedAt forKey:@"updatedAt_dirty_property"];
}
@end

@implementation DDFUserBuilder
- (instancetype)initWithModel:(DDFUser *)modelObject
{
    NSParameterAssert(modelObject);
    if (!(self = [super init])) {
        return self;
    }
    struct DDFUserDirtyProperties userDirtyProperties = modelObject.userDirtyProperties;
    if (userDirtyProperties.DDFUserDirtyPropertyAvatar) {
        _avatar = modelObject.avatar;
    }
    if (userDirtyProperties.DDFUserDirtyPropertyCountry) {
        _country = modelObject.country;
    }
    if (userDirtyProperties.DDFUserDirtyPropertyCountryCode) {
        _countryCode = modelObject.countryCode;
    }
    if (userDirtyProperties.DDFUserDirtyPropertyCreatedAt) {
        _createdAt = modelObject.createdAt;
    }
    if (userDirtyProperties.DDFUserDirtyPropertyIdentifier) {
        _identifier = modelObject.identifier;
    }
    if (userDirtyProperties.DDFUserDirtyPropertyLatitude) {
        _latitude = modelObject.latitude;
    }
    if (userDirtyProperties.DDFUserDirtyPropertyLongitude) {
        _longitude = modelObject.longitude;
    }
    if (userDirtyProperties.DDFUserDirtyPropertyName) {
        _name = modelObject.name;
    }
    if (userDirtyProperties.DDFUserDirtyPropertyTwitterID) {
        _twitterID = modelObject.twitterID;
    }
    if (userDirtyProperties.DDFUserDirtyPropertyTwitterUsername) {
        _twitterUsername = modelObject.twitterUsername;
    }
    if (userDirtyProperties.DDFUserDirtyPropertyUpdatedAt) {
        _updatedAt = modelObject.updatedAt;
    }
    _userDirtyProperties = userDirtyProperties;
    return self;
}
- (DDFUser *)build
{
    return [[DDFUser alloc] initWithBuilder:self];
}
- (void)mergeWithModel:(DDFUser *)modelObject
{
    NSParameterAssert(modelObject);
    DDFUserBuilder *builder = self;
    if (modelObject.userDirtyProperties.DDFUserDirtyPropertyAvatar) {
        builder.avatar = modelObject.avatar;
    }
    if (modelObject.userDirtyProperties.DDFUserDirtyPropertyCountry) {
        builder.country = modelObject.country;
    }
    if (modelObject.userDirtyProperties.DDFUserDirtyPropertyCountryCode) {
        builder.countryCode = modelObject.countryCode;
    }
    if (modelObject.userDirtyProperties.DDFUserDirtyPropertyCreatedAt) {
        builder.createdAt = modelObject.createdAt;
    }
    if (modelObject.userDirtyProperties.DDFUserDirtyPropertyIdentifier) {
        builder.identifier = modelObject.identifier;
    }
    if (modelObject.userDirtyProperties.DDFUserDirtyPropertyLatitude) {
        builder.latitude = modelObject.latitude;
    }
    if (modelObject.userDirtyProperties.DDFUserDirtyPropertyLongitude) {
        builder.longitude = modelObject.longitude;
    }
    if (modelObject.userDirtyProperties.DDFUserDirtyPropertyName) {
        builder.name = modelObject.name;
    }
    if (modelObject.userDirtyProperties.DDFUserDirtyPropertyTwitterID) {
        builder.twitterID = modelObject.twitterID;
    }
    if (modelObject.userDirtyProperties.DDFUserDirtyPropertyTwitterUsername) {
        builder.twitterUsername = modelObject.twitterUsername;
    }
    if (modelObject.userDirtyProperties.DDFUserDirtyPropertyUpdatedAt) {
        builder.updatedAt = modelObject.updatedAt;
    }
}
- (void)setAvatar:(NSURL *)avatar
{
    _avatar = [avatar copy];
    _userDirtyProperties.DDFUserDirtyPropertyAvatar = 1;
}
- (void)setCountry:(NSString *)country
{
    _country = [country copy];
    _userDirtyProperties.DDFUserDirtyPropertyCountry = 1;
}
- (void)setCountryCode:(NSString *)countryCode
{
    _countryCode = [countryCode copy];
    _userDirtyProperties.DDFUserDirtyPropertyCountryCode = 1;
}
- (void)setCreatedAt:(NSDate *)createdAt
{
    _createdAt = [createdAt copy];
    _userDirtyProperties.DDFUserDirtyPropertyCreatedAt = 1;
}
- (void)setIdentifier:(NSString *)identifier
{
    _identifier = [identifier copy];
    _userDirtyProperties.DDFUserDirtyPropertyIdentifier = 1;
}
- (void)setLatitude:(double)latitude
{
    _latitude = latitude;
    _userDirtyProperties.DDFUserDirtyPropertyLatitude = 1;
}
- (void)setLongitude:(double)longitude
{
    _longitude = longitude;
    _userDirtyProperties.DDFUserDirtyPropertyLongitude = 1;
}
- (void)setName:(NSString *)name
{
    _name = [name copy];
    _userDirtyProperties.DDFUserDirtyPropertyName = 1;
}
- (void)setTwitterID:(NSString *)twitterID
{
    _twitterID = [twitterID copy];
    _userDirtyProperties.DDFUserDirtyPropertyTwitterID = 1;
}
- (void)setTwitterUsername:(NSString *)twitterUsername
{
    _twitterUsername = [twitterUsername copy];
    _userDirtyProperties.DDFUserDirtyPropertyTwitterUsername = 1;
}
- (void)setUpdatedAt:(NSDate *)updatedAt
{
    _updatedAt = [updatedAt copy];
    _userDirtyProperties.DDFUserDirtyPropertyUpdatedAt = 1;
}
@end
