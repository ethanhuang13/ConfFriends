//
//  UserCellNode.m
//  WWDC Family
//
//  Created by Andrew Yates on 5/18/18.
//  Copyright © 2018 AndyDev. All rights reserved.
//

#import "UserCellNode.h"

@interface UserCellNode()

@property (strong, nonatomic) ASNetworkImageNode *avatarNode;
@property (strong, nonatomic) ASTextNode *nameTextNode;
@property (strong, nonatomic) ASTextNode *twitterUsernameTextNode;
@property (strong, nonatomic) ASTextNode *iconTextNode;

@end

@implementation UserCellNode

- (instancetype)initWithUser:(DDFUser *)user {
    self = [super init];
    if (self != nil) {
        
        self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        
        self.avatarNode = [[ASNetworkImageNode alloc] init];
        [self.avatarNode setCornerRadius:20];
        
        if(user.avatar){
            [self.avatarNode setURL:user.avatar];
        }
        
        
        NSString *nameString;
        if(user.twitterUsername){
            nameString = [NSString stringWithFormat:@"%@", user.name];
        } else {
            nameString = @"Unknown";
        }
        
        NSAttributedString *nameAttributedString = [[NSAttributedString alloc] initWithString:nameString attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0 weight:UIFontWeightMedium], NSForegroundColorAttributeName:[UIColor blackColor]}];
        
        self.nameTextNode = [[ASTextNode alloc] init];
        [self.nameTextNode setAttributedText:nameAttributedString];
        
        
        NSString *usernameString;
        if(user.twitterUsername){
            usernameString = [NSString stringWithFormat:@"@%@", user.twitterUsername];
        } else {
            usernameString = @"Unknown";
        }
        
        NSAttributedString *usernameAttributedString = [[NSAttributedString alloc] initWithString:usernameString attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0 weight:UIFontWeightRegular], NSForegroundColorAttributeName:[UIColor colorWithWhite:0.0 alpha:0.6]}];
        
        self.twitterUsernameTextNode = [[ASTextNode alloc] init];
        [self.twitterUsernameTextNode setAttributedText:usernameAttributedString];
        
        
        NSString *iconString = @"";
        UIFont *iconFont = [UIFont fontWithName:@"FontAwesome5BrandsRegular" size:18.0];
        
        if(user.latitude && user.longitude){
            iconString = @"";
            iconFont = [UIFont fontWithName:@"FontAwesome5ProLight" size:18.0];
        }
        
        NSAttributedString *iconAttributedString = [[NSAttributedString alloc] initWithString:iconString attributes:@{NSFontAttributeName:iconFont, NSForegroundColorAttributeName:[UIColor colorWithWhite:0.0 alpha:0.2]}];
        
        self.iconTextNode = [[ASTextNode alloc] init];
        [self.iconTextNode setAttributedText:iconAttributedString];
        
        [self setAutomaticallyManagesSubnodes:YES];
    }
    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    [self.avatarNode.style setPreferredSize:CGSizeMake(40, 40)];
    
    ASAbsoluteLayoutSpec *avatarAbsoluteSpec = [ASAbsoluteLayoutSpec absoluteLayoutSpecWithChildren:@[self.avatarNode]];
    [avatarAbsoluteSpec.style setPreferredSize:CGSizeMake(40, 40)];
    
    ASCenterLayoutSpec *centerAvatarSpec = [ASCenterLayoutSpec centerLayoutSpecWithCenteringOptions:ASCenterLayoutSpecCenteringY sizingOptions:ASCenterLayoutSpecSizingOptionDefault child:avatarAbsoluteSpec];
    
    ASStackLayoutSpec *labelStackSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:8 justifyContent:ASStackLayoutJustifyContentSpaceBetween alignItems:ASStackLayoutAlignItemsStart children:@[self.nameTextNode, self.twitterUsernameTextNode]];
    labelStackSpec.style.flexGrow = YES;
    labelStackSpec.style.flexShrink = YES;
    
    
    ASInsetLayoutSpec *iconInsetSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(11, 0, 0, 0) child:self.iconTextNode];
    
    ASStackLayoutSpec *layoutStackSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal spacing:10 justifyContent:ASStackLayoutJustifyContentCenter alignItems:ASStackLayoutAlignItemsStretch children:@[centerAvatarSpec, labelStackSpec, iconInsetSpec]];
    
    ASInsetLayoutSpec *insetSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(12, 16, 12, 16) child:layoutStackSpec];
    
    return insetSpec;
}

@end
