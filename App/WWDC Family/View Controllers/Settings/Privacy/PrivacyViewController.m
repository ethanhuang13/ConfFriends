//
//  PrivacyViewController.m
//  WWDC Family
//
//  Created by Andrew Yates on 5/17/18.
//  Copyright © 2018 AndyDev. All rights reserved.
//

#import "PrivacyViewController.h"

@interface PrivacyViewController ()

@property (strong, nonatomic) ASScrollNode *scrollNode;

@end

@implementation PrivacyViewController

- (instancetype)init {
    if (!(self = [super initWithNode:[[ASDisplayNode alloc] init]]))
        return nil;
    
    self.title = @"Privacy";
    self.node.backgroundColor = [UIColor whiteColor];
    
    self.scrollNode = [ASScrollNode new];
    self.scrollNode.automaticallyManagesContentSize = YES;
    
    NSString *descriptionString = @"This Privacy Policy applies to all information collected by the ConfFriends app for iPhone.\n\nInformation we collect\nTwitter\nConfFriends uses Twitter authentication to create an account. We store a read-only Twitter login token to look up and store your Twitter username, display name and avatar, these details are used when others view ConfFriends. ConfFriends cannot post tweets, adjust your account or read direct messages. You can revoke access to your Twitter account at any time via Twitter.com.\n\nLocation\nIf you enable location services, we store your location to share with other users of ConfFriends. Only your most recent position is stored, no historical location information is saved.\n\nYou are able disable & hide your location at any point, doing so will stop location tracking and remove the currently stored location.\n\nIf you set up a privacy zone in the app, any time you enter this zone your location will no longer be updated until you exit the zone. The location of the privacy zone is stored on your device and is not stored remotely or synced to other devices.\n\nInformation Usage\nWe use the information we collect to operate and improve ConfFriends.\n\nWe do not share personal information with outside parties aside from those needed to accomplish ConfFriend's functionality. We share anonymous usage data with outside parties to improve the app.\n\nSecurity\nAll communication from the app to backend services is done using HTTPS.\n\nAccessing, changing or deleting your information.\nYou may access or change your information or delete your account within the ConfFriends app.\n\nDeleted data may be kept in backups for up-to 30 days. Backups are encrypted and only accessed if needed for disaster recovery.\n\nThird-party links\nConfFriends displays content from Twitter, which has it's own independent privacy policy. We take no responsibility or liability for content or activities on these third-party links.\n\nYour Consent\nBy using and signing up to the ConfFriends app, you consent to our privacy policy.\n\nChildrens Privacy\nWe never collect or maintain information at our website from those we actually know are under 13, and no part of our app is structured to attract anyone under 13.\n\nCalifornia Privacy Rights\nWe comply with the California Online Privacy Protection Act. We therefore will not distribute your personal information to outside parties without your consent.\n\nChanges to our Privacy Policy\nIf we decide to change our privacy policy, we will include those changes on this page.\n\nContact Us\nIf you have any questions regarding this privacy policy, you can email contact@andydev.co.uk. Please note that account deletion should be done within the ConfFriends app, not via email requests, for security reasons.";
    
    NSMutableAttributedString *descriptionAttributedString = [[NSMutableAttributedString alloc] initWithString:descriptionString attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14 weight:UIFontWeightRegular], NSForegroundColorAttributeName:[UIColor colorWithWhite:0.0 alpha:0.6]}];
    
    [descriptionAttributedString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17 weight:UIFontWeightBold], NSForegroundColorAttributeName:[UIColor colorWithWhite:0.0 alpha:1.0]} range:[descriptionString rangeOfString:@"Information we collect"]];
    [descriptionAttributedString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15 weight:UIFontWeightMedium], NSForegroundColorAttributeName:[UIColor colorWithWhite:0.0 alpha:0.8]} range:[descriptionString rangeOfString:@"Twitter"]];
    [descriptionAttributedString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15 weight:UIFontWeightMedium], NSForegroundColorAttributeName:[UIColor colorWithWhite:0.0 alpha:0.8]} range:[descriptionString rangeOfString:@"Location"]];
    [descriptionAttributedString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17 weight:UIFontWeightBold], NSForegroundColorAttributeName:[UIColor colorWithWhite:0.0 alpha:1.0]} range:[descriptionString rangeOfString:@"Information Usage"]];
    [descriptionAttributedString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17 weight:UIFontWeightBold], NSForegroundColorAttributeName:[UIColor colorWithWhite:0.0 alpha:1.0]} range:[descriptionString rangeOfString:@"Security"]];
    [descriptionAttributedString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17 weight:UIFontWeightBold], NSForegroundColorAttributeName:[UIColor colorWithWhite:0.0 alpha:1.0]} range:[descriptionString rangeOfString:@"Third-party links"]];
    [descriptionAttributedString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17 weight:UIFontWeightBold], NSForegroundColorAttributeName:[UIColor colorWithWhite:0.0 alpha:1.0]} range:[descriptionString rangeOfString:@"Your Consent"]];
    [descriptionAttributedString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17 weight:UIFontWeightBold], NSForegroundColorAttributeName:[UIColor colorWithWhite:0.0 alpha:1.0]} range:[descriptionString rangeOfString:@"Childrens Privacy"]];
    [descriptionAttributedString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17 weight:UIFontWeightBold], NSForegroundColorAttributeName:[UIColor colorWithWhite:0.0 alpha:1.0]} range:[descriptionString rangeOfString:@"California Privacy Rights"]];
    [descriptionAttributedString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17 weight:UIFontWeightBold], NSForegroundColorAttributeName:[UIColor colorWithWhite:0.0 alpha:1.0]} range:[descriptionString rangeOfString:@"Changes to our Privacy Policy"]];
    [descriptionAttributedString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17 weight:UIFontWeightBold], NSForegroundColorAttributeName:[UIColor colorWithWhite:0.0 alpha:1.0]} range:[descriptionString rangeOfString:@"Contact Us"]];

    
    
    ASTextNode *descriptionTextNode = [ASTextNode new];
    [descriptionTextNode setAttributedText:descriptionAttributedString];
    
    __weak typeof(self) weakSelf = self;
    [self.scrollNode setLayoutSpecBlock:^ASLayoutSpec * _Nonnull(__kindof ASDisplayNode * _Nonnull node, ASSizeRange constrainedSize) {
        ASStackLayoutSpec *stackSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:24 justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsStretch children:@[descriptionTextNode]];

        ASInsetLayoutSpec *stackInsetSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(16, 16, 16, 16) child:stackSpec];

        return stackInsetSpec;
    }];
    [self.scrollNode setAutomaticallyManagesSubnodes:YES];
    
    self.node.layoutSpecBlock = ^ASLayoutSpec *(ASDisplayNode *_Nonnull node, ASSizeRange constrainedSize) {
        ASInsetLayoutSpec *stackInsetSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(0, 0, 0, 0) child:weakSelf.scrollNode];
        
        return stackInsetSpec;
    };
    [self.node setAutomaticallyManagesSubnodes:YES];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"general.close", @"Close") style:UIBarButtonItemStylePlain target:self action:@selector(dismissView)];
    
    return self;
}

- (void)dismissView {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
