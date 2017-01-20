//
//  WMGaugeViewStyleFlatThin.m
//  WMGaugeView
//
//  Created by Markezana, William on 25/10/15.
//  Copyright © 2015 Will™. All rights reserved.
//

#import "WMGaugeViewStyleFlatThin.h"

#define kNeedleWidth        0.1
#define kNeedleHeight       0.35
#define kNeedleScrewRadius  0.28

#define kCenterX            0.5
#define kCenterY            0.5

#define kNeedleColor        CGRGB(67, 0, 11)
#define kNeedleScrewColor   CGRGB(68, 84, 105)

@interface WMGaugeViewStyleFlatThin ()

@property (nonatomic) CAShapeLayer *needleLayer;
@property (nonatomic) CAShapeLayer *tagTmpLayer;

@end

@implementation WMGaugeViewStyleFlatThin

- (void)drawNeedleOnLayer:(CALayer*)layer inRect:(CGRect)rect
{
    _needleLayer = [CAShapeLayer layer];
    UIBezierPath *needlePath = [UIBezierPath bezierPath];
    
    //三角形path
    [needlePath moveToPoint:CGPointMake(FULLSCALE(kCenterX - kNeedleWidth, kCenterY))];
    [needlePath addLineToPoint:CGPointMake(FULLSCALE(kCenterX + kNeedleWidth, kCenterY))];
    [needlePath addLineToPoint:CGPointMake(FULLSCALE(kCenterX, kCenterY - kNeedleHeight))];
    [needlePath closePath];
    
    _needleLayer.path = needlePath.CGPath;
    _needleLayer.backgroundColor = [[UIColor clearColor] CGColor];
    _needleLayer.fillColor = kNeedleColor;
    _needleLayer.strokeColor = kNeedleColor;
    _needleLayer.lineWidth = 1.2;
    
    // Needle shadow
    _needleLayer.shadowColor = [[UIColor blackColor] CGColor];
    _needleLayer.shadowOffset = CGSizeMake(-2.0, -2.0);
    _needleLayer.shadowOpacity = 0.2;
    _needleLayer.shadowRadius = 1.2;
    
    [layer addSublayer:_needleLayer];
    
    
    //tagTmpLayer
    _tagTmpLayer = [CAShapeLayer layer];
 
    _tagTmpLayer.path = needlePath.CGPath;
    _tagTmpLayer.backgroundColor = [[UIColor clearColor] CGColor];
    _tagTmpLayer.fillColor   = [UIColor redColor].CGColor;
    _tagTmpLayer.strokeColor = kNeedleColor;
    _tagTmpLayer.lineWidth = 1.2;
    
    // Needle shadow
    _tagTmpLayer.shadowColor = [[UIColor blackColor] CGColor];
    _tagTmpLayer.shadowOffset = CGSizeMake(-2.0, -2.0);
    _tagTmpLayer.shadowOpacity = 0.2;
    _tagTmpLayer.shadowRadius = 1.2;
    
    [layer addSublayer:_tagTmpLayer];
    
    
//     Screw drawing
    CAShapeLayer *screwLayer = [CAShapeLayer layer];
    screwLayer.bounds = CGRectMake(FULLSCALE(kCenterX - kNeedleScrewRadius, kCenterY - kNeedleScrewRadius), FULLSCALE(kNeedleScrewRadius * 2.0, kNeedleScrewRadius * 2.0));
    screwLayer.position = CGPointMake(FULLSCALE(kCenterX, kCenterY));
    screwLayer.path = [UIBezierPath bezierPathWithOvalInRect:screwLayer.bounds].CGPath;
    screwLayer.fillColor = CGRGB(253, 128, 25);
    
    // Screw shadow
    screwLayer.shadowColor = [[UIColor blackColor] CGColor];
    screwLayer.shadowOffset = CGSizeMake(0.0, 0.0);
    screwLayer.shadowOpacity = 0.2;
    screwLayer.shadowRadius = 2.0;
    
    [layer addSublayer:screwLayer];
}

- (void)drawFaceWithContext:(CGContextRef)context inRect:(CGRect)rect
{
#define EXTERNAL_RING_RADIUS    0.24
#define INTERNAL_RING_RADIUS    0.1
    
    // External circle
    CGContextAddEllipseInRect(context, CGRectMake(kCenterX - EXTERNAL_RING_RADIUS, kCenterY - EXTERNAL_RING_RADIUS, EXTERNAL_RING_RADIUS * 2.0, EXTERNAL_RING_RADIUS * 2.0));
                                            // CGRGB(253, 128, 26)
    CGContextSetFillColorWithColor(context, CGRGBA(0, 0, 0,0));
    CGContextFillPath(context);
    
    // Inner circle
    CGContextAddEllipseInRect(context, CGRectMake(kCenterX - INTERNAL_RING_RADIUS, kCenterY - INTERNAL_RING_RADIUS, INTERNAL_RING_RADIUS * 2.0, INTERNAL_RING_RADIUS * 2.0));
    CGContextSetFillColorWithColor(context, CGRGBA(0, 0, 0,0));
    CGContextFillPath(context);
}


- (BOOL)needleLayer:(CALayer*)layer willMoveAnimated:(BOOL)animated duration:(NSTimeInterval)duration animation:(CAKeyframeAnimation*)animation
{
    layer.transform = [[animation.values objectAtIndex:0] CATransform3DValue];
    CGAffineTransform affineTransform1 = [layer affineTransform];
    layer.transform = [[animation.values objectAtIndex:1] CATransform3DValue];
    CGAffineTransform affineTransform2 = [layer affineTransform];
    layer.transform = [[animation.values lastObject] CATransform3DValue];
    CGAffineTransform affineTransform3 = [layer affineTransform];
    
    _needleLayer.shadowOffset = CGSizeApplyAffineTransform(CGSizeMake(-2.0, -2.0), affineTransform3);
    
    [layer addAnimation:animation forKey:kCATransition];
    
    CAKeyframeAnimation * animationShadowOffset = [CAKeyframeAnimation animationWithKeyPath:@"shadowOffset"];
    animationShadowOffset.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animationShadowOffset.removedOnCompletion = YES;
    animationShadowOffset.duration = animated ? duration : 0.0;
    animationShadowOffset.values = @[[NSValue valueWithCGSize:CGSizeApplyAffineTransform(CGSizeMake(-2.0, -2.0), affineTransform1)],
                                     [NSValue valueWithCGSize:CGSizeApplyAffineTransform(CGSizeMake(-2.0, -2.0), affineTransform2)],
                                     [NSValue valueWithCGSize:CGSizeApplyAffineTransform(CGSizeMake(-2.0, -2.0), affineTransform3)]];
    [_needleLayer addAnimation:animationShadowOffset forKey:kCATransition];
    
    return YES;
}

@end
