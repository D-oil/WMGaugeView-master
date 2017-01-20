//
//  ViewController.m
//  WMGaugeView
//
//  Created by William Markezana on 28/01/14.
//  Copyright (c) 2014 Will™. All rights reserved.
//

#import "ViewController.h"
#import "WMGaugeView.h"

#define RGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]

@interface ViewController ()


@property (strong, nonatomic) IBOutlet WMGaugeView *gaugeView2;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    _gaugeView2.style = [WMGaugeViewStyleFlatThin new];
    _gaugeView2.maxValue = 300.0;
    _gaugeView2.showInnerRim = YES;
    _gaugeView2.scaleDivisions = 10;
    _gaugeView2.scaleSubdivisions = 5;
    _gaugeView2.scaleStartAngle = 30;
    _gaugeView2.scaleEndAngle = 330;
    _gaugeView2.showScaleShadow = NO;
    _gaugeView2.scaleFont = [UIFont fontWithName:@"AvenirNext-UltraLight" size:0.065];
    _gaugeView2.scalesubdivisionsAligment = WMGaugeViewSubdivisionsAlignmentCenter;
    _gaugeView2.scaleSubdivisionsWidth = 0.004;
    _gaugeView2.scaleSubdivisionsLength = 0.004;
    _gaugeView2.scaleDivisionsWidth = 0.004;
    _gaugeView2.scaleDivisionsLength = 0.004;
    
//    [NSTimer scheduledTimerWithTimeInterval:2.0
//                                     target:self
//                                   selector:@selector(gaugeUpdateTimer:)
//                                   userInfo:nil
//                                    repeats:YES];
}
- (IBAction)change:(id)sender {
    [self gaugeUpdateTimer:nil];
}

-(void)gaugeUpdateTimer:(NSTimer *)timer
{
//    _gaugeView.value = rand()%(int)_gaugeView.maxValue;

    [_gaugeView2 setValue:rand()%(int)_gaugeView2.maxValue animated:YES duration:1.6 completion:^(BOOL finished) {
        NSLog(@"gaugeView2 animation complete");
    }];

    [_gaugeView2 setTagTmpValue:arc4random()%(int)_gaugeView2.maxValue animated:YES duration:1.6 completion:^(BOOL finished) {
        NSLog(@"gaugeView2 setTagTmpValue animation complete");
    }];
    
    [_gaugeView2 setfoodTmpValue:arc4random()%(int)_gaugeView2.maxValue animated:YES duration:1.6 completion:^(BOOL finished) {
        NSLog(@"gaugeView2 setTagTmpValue animation complete");
    }];
}

@end
