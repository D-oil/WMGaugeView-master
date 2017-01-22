//
//  ADSlideBar.m
//  WMGaugeView
//
//  Created by andong on 2017/1/22.
//  Copyright © 2017年 Will™. All rights reserved.
//

#import "ADSlideBar.h"

@interface ADSlideBar () <UIGestureRecognizerDelegate>

@property (nonatomic,strong) CAShapeLayer *backRoundLayer;
@property (nonatomic,strong) CAShapeLayer *progressLayer;
@end

@implementation ADSlideBar

- (CAShapeLayer *)backRoundLayer
{
    if (_backRoundLayer == nil) {
        
        self.progressWidth = self.bounds.size.width /7;
        
        _backRoundLayer = [CAShapeLayer layer];
        _backRoundLayer.frame = self.bounds;
        UIBezierPath *path = [UIBezierPath bezierPath];
        
        path = [UIBezierPath bezierPathWithArcCenter:self.center radius:(self.bounds.size.width - self.progressWidth)/ 2 startAngle:0 endAngle:M_PI * 2 clockwise:YES];

        _backRoundLayer.fillColor = nil;
        _backRoundLayer.path = path.CGPath;
        _backRoundLayer.lineWidth = self.progressWidth;
        
        //#define RGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
        _backRoundLayer.strokeColor = [UIColor whiteColor].CGColor;//[UIColor colorWithRed:1/255 green:1/255 blue:148/255 alpha:1.0].CGColor;//
   
    }
    return _backRoundLayer;
}

- (CAShapeLayer *)progressLayer
{
    if (_progressLayer == nil) {
        _progressLayer = [CAShapeLayer layer];
        _progressLayer.frame = self.bounds;

        _progressLayer.strokeColor = [UIColor redColor].CGColor;
        _progressLayer.fillColor = nil;
        _progressLayer.lineCap = kCALineCapRound;
        _progressLayer.lineWidth = self.progressWidth;
    }
    return _progressLayer;
}

- (UIBezierPath *)getProgressPath {
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    path = [UIBezierPath bezierPathWithArcCenter:self.center radius:(self.bounds.size.width - _progressWidth)/ 2 startAngle:- M_PI_2 endAngle:(M_PI * 2) * _progress - M_PI_2 clockwise:YES];
    
    return path;
}

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    [self setNeedsDisplay];
}

- (UIButton *)progressButton
{
    if (_progressButton == nil) {
        _progressButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.progressWidth, self.progressWidth)];
        _progressButton.backgroundColor = [UIColor grayColor];
        UIPanGestureRecognizer *swipe = [[UIPanGestureRecognizer alloc] initWithTarget:_progressButton action:@selector(progressButtonActionWithGestureRecognizer:)];
        swipe.delegate = self;
        swipe.direction = UISwipeGestureRecognizerDirectionRight | UISwipeGestureRecognizerDirectionLeft | UISwipeGestureRecognizerDirectionUp | UISwipeGestureRecognizerDirectionDown;
        
        [_progressButton addGestureRecognizer:swipe];
    }
    return _progressButton;
}



- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initialize];
}

- (void)initialize {
    self.progress = .5;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    if (self.backRoundLayer != nil) {
        [self.layer addSublayer:self.backRoundLayer];
    }
    if (self.progressLayer != nil) {
        self.progressLayer.path = [self getProgressPath].CGPath;
        [self.layer addSublayer:self.progressLayer];
    }
    if (self.progressButton != nil) {
        //self.progressButton.center =
        [self addSubview:self.progressButton];
    }
    
    
}

- (void)progressButtonActionWithGestureRecognizer:(UISwipeGestureRecognizer *)swipe
{

}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {

}

@end
