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

@end

@implementation UserCellNode

- (instancetype)initWithUser:(DDFUser *)user {
    self = [super init];
    if (self != nil) {
        
        self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        
        self.avatarNode = [[ASNetworkImageNode alloc] init];
        [self.avatarNode setURL:user.avatar];
        [self.avatarNode setCornerRadius:20];
        
        NSAttributedString *nameAttributedString = [[NSAttributedString alloc] initWithString:user.name attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0 weight:UIFontWeightMedium], NSForegroundColorAttributeName:[UIColor blackColor]}];
        
        self.nameTextNode = [[ASTextNode alloc] init];
        [self.nameTextNode setAttributedText:nameAttributedString];
        
        
        NSAttributedString *usernameAttributedString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"@%@", user.twitterUsername] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0 weight:UIFontWeightRegular], NSForegroundColorAttributeName:[UIColor colorWithWhite:0.0 alpha:0.6]}];
        
        self.twitterUsernameTextNode = [[ASTextNode alloc] init];
        [self.twitterUsernameTextNode setAttributedText:usernameAttributedString];
        
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
    

    ASStackLayoutSpec *layoutStackSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal spacing:10 justifyContent:ASStackLayoutJustifyContentSpaceBetween alignItems:ASStackLayoutAlignItemsStretch children:@[centerAvatarSpec, labelStackSpec]];
    
    ASInsetLayoutSpec *insetSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(12, 16, 12, 16) child:layoutStackSpec];
    
    return insetSpec;
}

@end
