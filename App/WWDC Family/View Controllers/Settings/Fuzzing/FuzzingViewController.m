//
//  FuzzingViewController.m
//  WWDC Family
//
//  Created by Andrew Yates on 6/1/18.
//  Copyright © 2018 AndyDev. All rights reserved.
//

#import "FuzzingViewController.h"

@interface FuzzingViewController () <MKMapViewDelegate>

@property (strong, nonatomic) UISwitch *fuzzSwitch;

@property (strong, nonatomic) ASDisplayNode *mapNode;
@property (strong, nonatomic) MKMapView *mapView;

@end

@implementation FuzzingViewController

- (instancetype)init {
    if (!(self = [super initWithNode:[[ASDisplayNode alloc] init]]))
        return nil;
    
    self.title = NSLocalizedString(@"fuzzingVC.title", @"Location Fuzzing");
    self.node.backgroundColor = [UIColor whiteColor];
    
    NSString *descriptionString = NSLocalizedString(@"fuzzingVC.description", @"Location fuzzing will throw off your location when away from WWDC.");
    
    NSMutableAttributedString *descriptionAttributedString = [[NSMutableAttributedString alloc] initWithString:descriptionString attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14 weight:UIFontWeightRegular], NSForegroundColorAttributeName:[UIColor colorWithWhite:0.0 alpha:0.6]}];
    
    ASTextNode *descriptionTextNode = [ASTextNode new];
    [descriptionTextNode setAttributedText:descriptionAttributedString];
    
    // Enable/Disable
    ASDisplayNode *fuzzSwitchNode = [[ASDisplayNode alloc] initWithViewBlock:^UIView * _Nonnull{
        self.fuzzSwitch = [[UISwitch alloc] init];
        [self.fuzzSwitch setOn:[[NSUserDefaults standardUserDefaults] boolForKey:@"DDFLocationFuzzingEnabled"]];
        [self.fuzzSwitch setBackgroundColor:[UIColor clearColor]];
        [self.fuzzSwitch addTarget:self action:@selector(fuzzSwitchChanged:) forControlEvents:UIControlEventValueChanged];
        return self.fuzzSwitch;
    }];
    [fuzzSwitchNode setUserInteractionEnabled:YES];
    
    ASTextNode *enableTextNode = [ASTextNode new];
    [enableTextNode setAttributedText:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"fuzzingVC.enableLocationFuzzing", @"Enable Location Fuzzing") attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13 weight:UIFontWeightRegular], NSForegroundColorAttributeName:[UIColor colorWithWhite:0.0 alpha:0.6]}]];
    
    
    // Map
    
    self.mapNode = [[ASDisplayNode alloc] initWithViewBlock:^UIView * _Nonnull{
        self.mapView = [[MKMapView alloc] init];
        [self.mapView setDelegate:self];
        [self.mapView setShowsPointsOfInterest:YES];
        [self.mapView setShowsCompass:NO];
        [self.mapView setShowsTraffic:NO];
        [self.mapView setShowsScale:NO];
        [self.mapView setShowsUserLocation:YES];
        if (@available(iOS 11.0, *)) {
            [self.mapView setMapType:MKMapTypeMutedStandard];
        } else {
            [self.mapView setMapType:MKMapTypeStandard];
        }
        
        [self resizeRegionToSanJose];
        
        return self.mapView;
    } didLoadBlock:^(__kindof ASDisplayNode * _Nonnull node) {
        
    }];
    
    self.mapNode.shadowOpacity = 0.1;
    self.mapNode.shadowRadius = 12;
    self.mapNode.shadowColor = [UIColor blackColor].CGColor;
    self.mapNode.shadowOffset = CGSizeMake(0, 6);
    self.mapNode.cornerRadius = 8.0;
    
    
    // Radius
    ASTextNode *radiusTitleNode = [ASTextNode new];
    [radiusTitleNode setAttributedText:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"", @"Radius") attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15 weight:UIFontWeightHeavy], NSForegroundColorAttributeName:[UIColor colorWithWhite:0.0 alpha:0.6]}]];
    
    ASTextNode *radiusTextNode = [ASTextNode new];
    [radiusTextNode setAttributedText:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"fuzzingVC.adjustRadius", @"Adjust the radius where location will be recorded without fuzzing using the slider below.") attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13 weight:UIFontWeightRegular], NSForegroundColorAttributeName:[UIColor colorWithWhite:0.0 alpha:0.6]}]];
    
    
    ASDisplayNode *radiusSliderNode = [[ASDisplayNode alloc] initWithViewBlock:^UIView * _Nonnull{
        UISlider *radiusSlider = [[UISlider alloc] init];
        [radiusSlider setBackgroundColor:[UIColor clearColor]];
        [radiusSlider addTarget:self action:@selector(radiusSliderChanged:) forControlEvents:UIControlEventValueChanged];
        [radiusSlider setMaximumValue:10000];
        if([[NSUserDefaults standardUserDefaults] valueForKey:@"DDFLocationFuzzingRadius"]){
            [radiusSlider setValue:[[NSUserDefaults standardUserDefaults] integerForKey:@"DDFLocationFuzzingRadius"]];
            
            MKCircle *circle = [MKCircle circleWithCenterCoordinate:CLLocationCoordinate2DMake(37.328979, -121.888955) radius:[[NSUserDefaults standardUserDefaults] integerForKey:@"DDFLocationFuzzingRadius"]];
            [self.mapView addOverlay:circle];
        } else {
            [radiusSlider setValue:2000];
        }
        return radiusSlider;
    }];
    [radiusSliderNode setUserInteractionEnabled:YES];
    
    
    // Radius
    ASTextNode *fluffTitleNode = [ASTextNode new];
    [fluffTitleNode setAttributedText:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"fuzzingVC.fluffDistance", @"Fluff Distance") attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15 weight:UIFontWeightHeavy], NSForegroundColorAttributeName:[UIColor colorWithWhite:0.0 alpha:0.6]}]];
    
    ASTextNode *fluffTextNode = [ASTextNode new];
    [fluffTextNode setAttributedText:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"fuzzingVC.theDistanceThat", @"The distance that your location will be adjusted when outside of the radius shown.") attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13 weight:UIFontWeightRegular], NSForegroundColorAttributeName:[UIColor colorWithWhite:0.0 alpha:0.6]}]];
    
    
    ASDisplayNode *distanceSegmentNode = [[ASDisplayNode alloc] initWithViewBlock:^UIView * _Nonnull{
        UISegmentedControl *distanceSegmentControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:NSLocalizedString(@"fuzzingVC.100m", @"100m"), NSLocalizedString(@"fuzzingVC.250m", @"250m"), NSLocalizedString(@"fuzzingVC.500m", @"500m"), NSLocalizedString(@"fuzzingVC.1000m", @"1000m"), NSLocalizedString(@"fuzzingVC.2000m", @"2000m"), nil]];
        [distanceSegmentControl addTarget:self action:@selector(distanceSegmentChanged:) forControlEvents:UIControlEventValueChanged];
        if([[NSUserDefaults standardUserDefaults] valueForKey:@"DDFLocationFuzzingDistance"]){
            NSInteger distance = [[NSUserDefaults standardUserDefaults] integerForKey:@"DDFLocationFuzzingDistance"];
            if(distance == 100){
                [distanceSegmentControl setSelectedSegmentIndex:0];
            } else if(distance == 250){
                [distanceSegmentControl setSelectedSegmentIndex:1];
            } else if(distance == 500){
                [distanceSegmentControl setSelectedSegmentIndex:2];
            } else if(distance == 1000){
                [distanceSegmentControl setSelectedSegmentIndex:3];
            } else if(distance == 2000){
                [distanceSegmentControl setSelectedSegmentIndex:4];
            }
        } else {
            [distanceSegmentControl setSelectedSegmentIndex:0];
        }
        return distanceSegmentControl;
    }];
    [distanceSegmentNode setUserInteractionEnabled:YES];
    
    __weak typeof(self) weakSelf = self;
    [self.node setLayoutSpecBlock:^ASLayoutSpec * _Nonnull(__kindof ASDisplayNode * _Nonnull node, ASSizeRange constrainedSize) {
        [fuzzSwitchNode.style setPreferredSize:CGSizeMake(50, 30)];
        [radiusSliderNode.style setPreferredSize:CGSizeMake(constrainedSize.max.width-52, 44)];
        [distanceSegmentNode.style setPreferredSize:CGSizeMake(constrainedSize.max.width-52, 35)];

        [weakSelf.mapNode.style setPreferredSize:CGSizeMake(constrainedSize.max.width-52, 200)];
        
        ASStackLayoutSpec *enableStackSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal spacing:10 justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsCenter children:@[fuzzSwitchNode, enableTextNode]];
        [enableStackSpec.style setWidth:ASDimensionMake(constrainedSize.max.width-52)];
        
        ASStackLayoutSpec *radiusStackSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:8 justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsStretch children:@[radiusTitleNode, radiusTextNode, radiusSliderNode]];
        
        ASStackLayoutSpec *distanceStackSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:8 justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsStretch children:@[fluffTitleNode, fluffTextNode, distanceSegmentNode]];

        ASInsetLayoutSpec *mapInsetSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(16, 0, 0, 0) child:weakSelf.mapNode];
        
        NSArray *children;
        if([[NSUserDefaults standardUserDefaults] boolForKey:@"DDFLocationFuzzingEnabled"]){
            children = @[descriptionTextNode, enableStackSpec, mapInsetSpec, radiusStackSpec, distanceStackSpec];
        } else {
            children = @[descriptionTextNode, enableStackSpec];
        }
        
        ASStackLayoutSpec *stackSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:16 justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsCenter children:children];
        
        CGFloat topInset = 0;
        if(self.node.safeAreaInsets.top != 0) topInset = self.node.safeAreaInsets.top;
        
        ASInsetLayoutSpec *stackInsetSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(topInset+16, 16, 16, 16) child:stackSpec];
        
        return stackInsetSpec;
    }];
    
    [self.node setAutomaticallyManagesSubnodes:YES];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"general.close", @"Close") style:UIBarButtonItemStylePlain target:self action:@selector(dismissView)];
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark - San Jose Region

- (void)resizeRegionToSanJose {
    MKCoordinateRegion mapRegion;
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(37.328979, -121.888955);
    mapRegion.center = coordinate;
    mapRegion.span.latitudeDelta = 0.2;
    mapRegion.span.longitudeDelta = 0.2;
    
    [self.mapView setRegion:mapRegion animated: YES];
}

#pragma mark - Switch

- (void)fuzzSwitchChanged:(UISwitch *)switchControl {
    [[NSUserDefaults standardUserDefaults] setBool:switchControl.isOn forKey:@"DDFLocationFuzzingEnabled"];
    
    if(![[NSUserDefaults standardUserDefaults] valueForKey:@"DDFLocationFuzzingRadius"]){
        [[NSUserDefaults standardUserDefaults] setInteger:2000 forKey:@"DDFLocationFuzzingRadius"];
    }
    
    if(![[NSUserDefaults standardUserDefaults] valueForKey:@"DDFLocationFuzzingDistance"]){
        [[NSUserDefaults standardUserDefaults] setInteger:2000 forKey:@"DDFLocationFuzzingDistance"];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.node transitionLayoutWithAnimation:YES shouldMeasureAsync:NO measurementCompletion:nil];
}

#pragma mark - Slider

- (void)radiusSliderChanged:(UISlider *)slider {
    [self.mapView removeOverlays:self.mapView.overlays];
    MKCircle *circle = [MKCircle circleWithCenterCoordinate:CLLocationCoordinate2DMake(37.328979, -121.888955) radius:slider.value];
    [self.mapView addOverlay:circle];
    
    [[NSUserDefaults standardUserDefaults] setInteger:slider.value forKey:@"DDFLocationFuzzingRadius"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Segment

- (void)distanceSegmentChanged:(UISegmentedControl *)segment {
    NSInteger distance = 2000;
    if(segment.selectedSegmentIndex == 0){
        distance = 100;
    } else if(segment.selectedSegmentIndex == 1){
        distance = 250;
    } else if(segment.selectedSegmentIndex == 2){
        distance = 500;
    } else if(segment.selectedSegmentIndex == 3){
        distance = 1000;
    } else if(segment.selectedSegmentIndex == 4){
        distance = 2000;
    }
    
    [[NSUserDefaults standardUserDefaults] setInteger:distance forKey:@"DDFLocationFuzzingDistance"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}



- (MKOverlayRenderer *)mapView:(MKMapView *)map viewForOverlay:(id <MKOverlay>)overlay {
    MKCircleRenderer *circleView = [[MKCircleRenderer alloc] initWithOverlay:overlay];
    circleView.strokeColor = [UIColor greenColor];
    circleView.fillColor = [[UIColor greenColor] colorWithAlphaComponent:0.4];
    return circleView;
}

#pragma mark - Actions

- (void)dismissView {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
