/*
 * WMGaugeView.h
 *
 * Copyright (C) 2014 William Markezana <william.markezana@me.com>
 *
 */

#import "WMGaugeView.h"

/* Scale conversion macro from [0-1] range to view  real size range */
#define FULL_SCALE(x,y)    (x)*self.bounds.size.width, (y)*self.bounds.size.height

@implementation WMGaugeView
{
    /* Drawing rects */
    CGRect fullRect;
    CGRect innerRimRect;
    CGRect innerRimBorderRect;
    CGRect faceRect;
    CGRect rangeLabelsRect;
    CGRect scaleRect;

    /* View center */
    CGPoint center;

    /* Scale variables */
    CGFloat scaleRotation;    
    CGFloat divisionValue;
    CGFloat subdivisionValue;
    CGFloat subdivisionAngle;
    
    /* Background image */
    UIImage *background;
    
    /*background layer*/
    CAShapeLayer *backgroundLayer;

    
    
    /* Needle layer */
    CALayer *rootNeedleLayer;
    CALayer *tagTemlayer;
    CALayer *foodTemlayer;
    /* Annimation completion */
    void (^animationCompletion)(BOOL);
}

#pragma mark - Initialization

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initialize];
    }
    return self;
}

- (void)awakeFromNib
{
    [self initialize];
}

/**
 *  Set all properties to default values
 *  Set all private variables to default values
 */
- (void)initialize;
{
    _style = nil;
    _showInnerRim = NO;
    _showInnerBackground = YES;
    _innerRimWidth = 0.05;
    _innerRimBorderWidth = 0.01;
    
    _scalePosition = 0.025;
    _scaleStartAngle = 30.0;
    _scaleEndAngle = 330.0;
    _scaleDivisions = 12.0;
    _scaleSubdivisions = 10.0;
    _showScale = YES;
    _showScaleShadow = YES;
    _scalesubdivisionsAligment = WMGaugeViewSubdivisionsAlignmentTop;
    
    //整数标尺和零散标尺大小
    _scaleDivisionsLength = 0.008;
    _scaleDivisionsWidth = 0.008;
    _scaleSubdivisionsLength = 0.008;
    _scaleSubdivisionsWidth = 0.008;
    //默认标尺颜色
    _scaleDivisionColor = RGB(68, 84, 105);
    _scaleSubDivisionColor = RGB(217, 217, 217);
    
    
    //value 代表指针所指值
//    _value = 0.0;
     _grillValue = 0.0;
    _TagValue = 0.0;
    _foodValue = 0.0;
    _minValue = 0.0;
    _maxValue = 240.0;
    //？
    background = nil;
    //在3Dstyle中会有分区
    _showRangeLabels = NO;
    _rangeLabelsWidth = 0.05;
    _rangeLabelsFont = [UIFont fontWithName:@"Helvetica" size:0.05];
    _rangeLabelsFontColor = [UIColor whiteColor];
    _rangeLabelsFontKerning = 1.0;
    _rangeValues = nil;
    _rangeColors = nil;
    _rangeLabels = nil;

    _scaleFont = nil;
    
    _unitOfMeasurementVerticalOffset = 0.6;
    _unitOfMeasurementColor = [UIColor whiteColor];
    _unitOfMeasurementFont = [UIFont fontWithName:@"Helvetica" size:0.04];
    _unitOfMeasurement = @"";
    _showUnitOfMeasurement = NO;
    
    animationCompletion = nil;
    //初始化各个画图区域的rect值
    [self initDrawingRects];
    [self initScale];
}

/**
 *  Initialize all drawing rects and center point
 */
- (void)initDrawingRects
{
    //设置中心点
    center = CGPointMake(0.5, 0.5);
    //总画图区域
    fullRect = CGRectMake(0.0, 0.0, 1.0, 1.0);
    
    _innerRimBorderWidth = _showInnerRim ? _innerRimBorderWidth : 0.0;
    _innerRimWidth = _showInnerRim ? _innerRimWidth : 0.0;
    
    innerRimRect = fullRect;
    innerRimBorderRect = CGRectMake(innerRimRect.origin.x + _innerRimBorderWidth-0.1,
                                    innerRimRect.origin.y + _innerRimBorderWidth-0.1,
                                    innerRimRect.size.width - 2 * _innerRimBorderWidth,
                                    innerRimRect.size.height - 2 * _innerRimBorderWidth);
    faceRect = CGRectMake(innerRimRect.origin.x + _innerRimWidth,
                          innerRimRect.origin.y + _innerRimWidth,
                          innerRimRect.size.width - 2 * _innerRimWidth,
                          innerRimRect.size.height - 2 * _innerRimWidth);
    rangeLabelsRect = CGRectMake(faceRect.origin.x + (_showRangeLabels ? _rangeLabelsWidth : 0.0),
                                 faceRect.origin.y + (_showRangeLabels ? _rangeLabelsWidth : 0.0),
                                 faceRect.size.width - 2 * (_showRangeLabels ? _rangeLabelsWidth : 0.0),
                                 faceRect.size.height - 2 * (_showRangeLabels ? _rangeLabelsWidth : 0.0));
    scaleRect = CGRectMake(rangeLabelsRect.origin.x + _scalePosition,
                           rangeLabelsRect.origin.y + _scalePosition,
                           rangeLabelsRect.size.width - 2 * _scalePosition,
                           rangeLabelsRect.size.height - 2 * _scalePosition);
    
}

#pragma mark - Drawing

/**
 * Main drawing entry point 
 */
- (void)drawRect:(CGRect)rect
{
//    if (background == nil)
//    {
//        // Create image context
//        UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale);
//        CGContextRef context = UIGraphicsGetCurrentContext();
//        
//        // Scale context for [0-1] drawings
//        CGContextScaleCTM(context, rect.size.width , rect.size.height);
//        
//        // Draw gauge background in image context
//        [self drawGauge:context];
//        
//        // Save background
//        background = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//    }
    
    // Drawing background in view
    [background drawInRect:rect];
    
    if (backgroundLayer == nil) {
        
        backgroundLayer = [CAShapeLayer layer];
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        
        [path addArcWithCenter:CGPointMake(self.frame.size.width / 2 , self.frame.size.height /2)
                        radius:self.frame.size.width / 2
                    startAngle:M_PI*0.65
                      endAngle:M_PI*0.35
                     clockwise:YES];
        [path addArcWithCenter:CGPointMake(self.frame.size.width / 2 , self.frame.size.height /2)
                                radius:(self.frame.size.width / 2 ) /2
                            startAngle:M_PI*0.35
                              endAngle:M_PI*0.65
                     clockwise:NO];
        [path closePath];
    
        backgroundLayer.path = path.CGPath;
        backgroundLayer.fillColor = RGB(251, 222, 148).CGColor;
        [self.layer addSublayer: backgroundLayer];
        
    }

    //
    if (rootNeedleLayer == nil)
    {
        // Initialize needle layer
        rootNeedleLayer = [CALayer new];
        
        // For performance puporse, the needle layer is not scaled to [0-1] range
        rootNeedleLayer.frame = self.bounds;
        [self.layer addSublayer:rootNeedleLayer];
        
        // Draw needle
        [self drawNeedle];
        
        
        // Set needle current value
        [self setValue:_grillValue animated:NO];
    }
    
    if (tagTemlayer == nil) {
        // Initialize needle layer
        tagTemlayer = [CALayer new];
        
        // For performance puporse, the needle layer is not scaled to [0-1] range
        tagTemlayer.frame = self.bounds;
        [self.layer addSublayer:tagTemlayer];
        
        // Draw needle
        [self drawtagNeedle];
        
        // Set needle current value
        [self setValue:_TagValue animated:NO];
    }
    
    if (foodTemlayer == nil) {
        // Initialize needle layer
        foodTemlayer = [CALayer new];
        
        // For performance puporse, the needle layer is not scaled to [0-1] range
        foodTemlayer.frame = self.bounds;
        [self.layer addSublayer:foodTemlayer];
        
        // Draw needle
        [self drawfoodNeedle];
        
        // Set needle current value
        [self setValue:_foodValue animated:NO];
    }
   

}

/**
 *  Gauge background drawing
 */
- (void)drawGauge:(CGContextRef)context
{
    [self drawRim:context];
    
    if (_showRangeLabels)
        [self drawRangeLabels:context];

    if (_showScale)
        [self drawScale:context];
    //画面板
    if (_showInnerBackground)
        [self drawFace:context];

    if (_showUnitOfMeasurement)
        [self drawText:context];

}

/**
 *  Gauge external rim drawing
 */
- (void)drawRim:(CGContextRef)context
{
    // TODO
}

/**
 *  Gauge inner background drawing
 */
- (void)drawFace:(CGContextRef)context
{
    if ([_style conformsToProtocol:@protocol(WMGaugeViewStyle)]) {
        [_style drawFaceWithContext:context inRect:faceRect];
    }
}

/**
 *  Unit of measurement drawing
 */
- (void)drawText:(CGContextRef)context
{
    CGContextSetShadow(context, CGSizeMake(0.05, 0.05), 2.0);
    UIFont* font = _unitOfMeasurementFont ? _unitOfMeasurementFont : [UIFont fontWithName:@"Helvetica" size:0.04];
    UIColor* color = _unitOfMeasurementColor ? _unitOfMeasurementColor : [UIColor whiteColor];
    NSDictionary* stringAttrs = @{ NSFontAttributeName : font, NSForegroundColorAttributeName : color };
    NSAttributedString* attrStr = [[NSAttributedString alloc] initWithString:_unitOfMeasurement attributes:stringAttrs];
    CGSize fontWidth;
    fontWidth = [_unitOfMeasurement sizeWithAttributes:stringAttrs];

    [attrStr drawAtPoint:CGPointMake(0.5 - fontWidth.width / 2.0, _unitOfMeasurementVerticalOffset)];
}

/**
 * Scale drawing 
 */
- (void)drawScale:(CGContextRef)context
{
    CGContextSaveGState(context);
    [self rotateContext:context fromCenter:center withAngle:DEGREES_TO_RADIANS(180 + _scaleStartAngle)];
    
    int totalTicks = _scaleDivisions * _scaleSubdivisions + 1;
    for (int i = 0; i < totalTicks; i++)
    {
        CGFloat offset = 0.0;
        if (_scalesubdivisionsAligment == WMGaugeViewSubdivisionsAlignmentCenter) offset = (_scaleDivisionsLength - _scaleSubdivisionsLength) / 2.0;
        if (_scalesubdivisionsAligment == WMGaugeViewSubdivisionsAlignmentBottom) offset = _scaleDivisionsLength - _scaleSubdivisionsLength;
        
        CGFloat y1 = scaleRect.origin.y;
        CGFloat y2 = y1 + _scaleSubdivisionsLength;
        CGFloat y3 = y1 + _scaleDivisionsLength;
        
        float value = [self valueForTick:i];
        float div = (_maxValue - _minValue) / _scaleDivisions;
        float mod = (int)value % (int)div;
        
        // Division
        if ((fabsf(mod - 0) < 0.000001) || (fabsf(mod - div) < 0.000001))
        {
            // Initialize Core Graphics settings
            UIColor *color = (_rangeValues && _rangeColors) ? [self rangeColorForValue:value] : _scaleDivisionColor;
            CGContextSetStrokeColorWithColor(context, color.CGColor);
            CGContextSetLineWidth(context, _scaleDivisionsWidth);
            CGContextSetShadow(context, CGSizeMake(0.05, 0.05), _showScaleShadow ? 2.0 : 0.0);
            
            // Draw tick
            CGContextMoveToPoint(context, 0.5, y1);
            CGContextAddLineToPoint(context, 0.5, y3);
            CGContextStrokePath(context);
            
//            // Draw label
//            NSString *valueString = [NSString stringWithFormat:@"%0.0f",value];
//            UIFont* font = _scaleFont ? _scaleFont : [UIFont fontWithName:@"Helvetica-Bold" size:0.05];
//            NSDictionary* stringAttrs = @{ NSFontAttributeName : font, NSForegroundColorAttributeName : color };
//            NSAttributedString* attrStr = [[NSAttributedString alloc] initWithString:valueString attributes:stringAttrs];
//            CGSize fontWidth;
//            fontWidth = [valueString sizeWithAttributes:stringAttrs];
//            
//            [attrStr drawAtPoint:CGPointMake(0.5 - fontWidth.width / 2.0, y3 + 0.005)];
        }
        // Subdivision
        else
        {
            // Initialize Core Graphics settings
            UIColor *color = (_rangeValues && _rangeColors) ? [self rangeColorForValue:value] : _scaleSubDivisionColor;
            
            CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
            CGContextSetLineWidth(context, _scaleSubdivisionsWidth);
            CGContextMoveToPoint(context, 0.5, y1);
            if (_showScaleShadow) CGContextSetShadow(context, CGSizeMake(0.05, 0.05), 2.0);
            
            // Draw tick
            CGContextMoveToPoint(context, 0.5, y1 + offset);
            CGContextAddLineToPoint(context, 0.5, y2 + offset);
            CGContextStrokePath(context);
        }
        
        // Rotate to next tick
        [self rotateContext:context fromCenter:center withAngle:DEGREES_TO_RADIANS(subdivisionAngle)];
    }
    CGContextRestoreGState(context);
}

/**
 * scale range labels drawing 
 */
- (void)drawRangeLabels:(CGContextRef)context
{
    CGContextSaveGState(context);
    [self rotateContext:context fromCenter:center withAngle:DEGREES_TO_RADIANS(90 + _scaleStartAngle)];
    CGContextSetShadow(context, CGSizeMake(0.0, 0.0), 0.0);
    
    CGFloat maxAngle = _scaleEndAngle - _scaleStartAngle;
    CGFloat lastStartAngle = 0.0f;

    for (int i = 0; i < _rangeValues.count; i ++)
    {
        // Range value
        float value = ((NSNumber*)[_rangeValues objectAtIndex:i]).floatValue;
        float valueAngle = (value - _minValue) / (_maxValue - _minValue) * maxAngle;
        
        // Range curved shape
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path addArcWithCenter:center radius:rangeLabelsRect.size.width / 2.0 startAngle:DEGREES_TO_RADIANS(lastStartAngle) endAngle:DEGREES_TO_RADIANS(valueAngle) - 0.01 clockwise:YES];
        
        UIColor *color = _rangeColors[i];
        [color setStroke];
        path.lineWidth = _rangeLabelsWidth;
        [path stroke];
        
        // Range curved label
        [self drawStringAtContext:context string:(NSString*)_rangeLabels[i] withCenter:center radius:rangeLabelsRect.size.width / 2.0 startAngle:DEGREES_TO_RADIANS(lastStartAngle) endAngle:DEGREES_TO_RADIANS(valueAngle)];
        
        lastStartAngle = valueAngle;
    }
    
    CGContextRestoreGState(context);
}

/**
 * Needle drawing 
 */
- (void)drawNeedle
{
    if ([_style conformsToProtocol:@protocol(WMGaugeViewStyle)]) {
        [_style drawNeedleOnLayer:rootNeedleLayer withColor:[UIColor colorWithCGColor:kNeedleBlackColor]   inRect:self.bounds];
    }

}
/**
 * tagTmp drawing
 */
- (void)drawtagNeedle
{
    if ([_style conformsToProtocol:@protocol(WMGaugeViewStyle)]) {
        [_style drawNeedleOnLayer:tagTemlayer withColor:[UIColor colorWithCGColor:kNeedleOrangeColor] inRect:self.bounds];
    }
    
}

- (void)drawfoodNeedle
{
    if ([_style conformsToProtocol:@protocol(WMGaugeViewStyle)]) {
        [_style drawfoodNeedleOnLayer:foodTemlayer withColor:[UIColor colorWithCGColor:kNeedleRedColor] inRect:self.bounds];
    }
    
}



#pragma mark - Tools

/**
 * Core Graphics rotation in context
 */
- (void)rotateContext:(CGContextRef)context fromCenter:(CGPoint)center_ withAngle:(CGFloat)angle
{
    CGContextTranslateCTM(context, center_.x, center_.y);
    CGContextRotateCTM(context, angle);
    CGContextTranslateCTM(context, -center_.x, -center_.y);
}

/**
 * Needle angle computation
 */
- (CGFloat)needleAngleForValue:(double)value
{
    return DEGREES_TO_RADIANS(_scaleStartAngle + (value - _minValue) / (_maxValue - _minValue) * (_scaleEndAngle - _scaleStartAngle)) + M_PI;
}

/**
 * Initialize scale helper values
 */
- (void)initScale
{
    scaleRotation = (int)(_scaleStartAngle + 180) % 360;
    divisionValue = (_maxValue - _minValue) / _scaleDivisions;
    subdivisionValue = divisionValue / _scaleSubdivisions;
    subdivisionAngle = (_scaleEndAngle - _scaleStartAngle) / (_scaleDivisions * _scaleSubdivisions);
}

/**
 * Scale tick value computation
 */
- (float)valueForTick:(int)tick
{
    return tick * (divisionValue / _scaleSubdivisions) + _minValue;
}

/**
 * Scale range label color for value
 */
- (UIColor*)rangeColorForValue:(float)value
{
    NSInteger length = _rangeValues.count;
    for (int i = 0; i < length - 1; i++)
    {
        if (value < [_rangeValues[i] floatValue])
            return _rangeColors[i];
    }
    if (value <= [_rangeValues[length - 1] floatValue])
        return _rangeColors[length - 1];
    return nil;
}

/**
 * Draw curved NSSring in context
 */
- (void)drawStringAtContext:(CGContextRef) context string:(NSString*)text withCenter:(CGPoint)center_ radius:(CGFloat)radius startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle
{
    CGContextSaveGState(context);
    
    UIFont* font = _rangeLabelsFont ? _rangeLabelsFont : [UIFont fontWithName:@"Helvetica" size:0.05];
    UIColor* color = _rangeLabelsFontColor ? _rangeLabelsFontColor : [UIColor whiteColor];
    NSDictionary* stringAttrs = @{ NSFontAttributeName : font, NSForegroundColorAttributeName : color };
    CGSize textSize;
    textSize = [text sizeWithAttributes:stringAttrs];
    
    float perimeter = 2 * M_PI * radius;
    float textAngle = textSize.width / perimeter * 2 * M_PI * _rangeLabelsFontKerning;
    float offset = ((endAngle - startAngle) - textAngle) / 2.0;

    float letterPosition = 0;
    NSString *lastLetter = @"";
    
    [self rotateContext:context fromCenter:center withAngle:startAngle + offset];
    for (int index = 0; index < [text length]; index++)
    {
        NSRange range = {index, 1};
        NSString* letter = [text substringWithRange:range];
        NSAttributedString* attrStr = [[NSAttributedString alloc] initWithString:letter attributes:stringAttrs];
        CGSize charSize = [letter sizeWithAttributes:stringAttrs];
        float totalWidth = [[NSString stringWithFormat:@"%@%@",lastLetter, letter] sizeWithAttributes:stringAttrs].width;
        float currentLetterWidth = [letter sizeWithAttributes:stringAttrs].width;
        float lastLetterWidth = [lastLetter sizeWithAttributes:stringAttrs].width;
        float kerning = (lastLetterWidth) ? 0.0 : ((currentLetterWidth + lastLetterWidth) - totalWidth);
        
        letterPosition += (charSize.width / 2) - kerning;
        float angle = (letterPosition / perimeter * 2 * M_PI) * _rangeLabelsFontKerning;
        CGPoint letterPoint = CGPointMake((radius - charSize.height / 2.0) * cos(angle) + center_.x, (radius - charSize.height / 2.0) * sin(angle) + center_.y);
        
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, letterPoint.x, letterPoint.y);
        CGAffineTransform rotationTransform = CGAffineTransformMakeRotation(angle + M_PI_2);
        CGContextConcatCTM(context, rotationTransform);
        CGContextTranslateCTM(context, -letterPoint.x, -letterPoint.y);

        [attrStr drawAtPoint:CGPointMake(letterPoint.x - charSize.width/2 , letterPoint.y - charSize.height)];
        
        CGContextRestoreGState(context);
        
        letterPosition += charSize.width / 2;
        lastLetter = letter;
    }
    CGContextRestoreGState(context);
}

/**
 * Invalidate background
 * Background will be regenerated during next draw rect
 */
- (void)invalidateBackground
{
    background = nil;
    [self initDrawingRects];
    [self initScale];
    [self setNeedsDisplay];
}


/**
 * Invalidate Needle
 * Needle will be regenerated during next draw rect
 */
- (void)invalidateNeedle
{
    [rootNeedleLayer removeAllAnimations];
    rootNeedleLayer.sublayers = nil;
    rootNeedleLayer = nil;
    
    [self setNeedsDisplay];
}

#pragma mark - Value update

/**
 * Update gauge value
 */
- (void)updateGrillValue:(float)value
{
    // Clamp value if out of range
    if (value > _maxValue)
        value = _maxValue;
    else if (value < _minValue)
        value = _minValue;
    else
        value = value;
    
    // Set value
    _grillValue = value;
}

/**
 * Update gauge value
 */
- (void)updateTagValue:(float)value
{
    // Clamp value if out of range
    if (value > _maxValue)
        value = _maxValue;
    else if (value < _minValue)
        value = _minValue;
    else
        value = value;
    
    // Set value
    _TagValue = value;
}
/**
 * Update gauge value
 */
- (void)updatefoodValue:(float)value
{
    // Clamp value if out of range
    if (value > _maxValue)
        value = _maxValue;
    else if (value < _minValue)
        value = _minValue;
    else
        value = value;
    
    // Set value
    _foodValue = value;
}

/**
 * Update gauge value with animation
 */
- (void)setValue:(float)value animated:(BOOL)animated
{
    [self setValue:value animated:animated duration:0.8];
}

/**
 * Update gauge value with animation and fire a completion block
 */
- (void)setValue:(float)value animated:(BOOL)animated completion:(void (^)(BOOL finished))completion
{
    [self setValue:value animated:animated duration:0.8 completion:completion];
}

/**
 * Update gauge value with animation and duration
 */
- (void)setValue:(float)value animated:(BOOL)animated duration:(NSTimeInterval)duration
{
    [self setValue:value animated:animated duration:duration completion:nil];
}

/**
 * Update gauge value with animation, duration and fire a completion block
 */
- (void)setValue:(float)value animated:(BOOL)animated duration:(NSTimeInterval)duration completion:(void (^)(BOOL finished))completion
{
    animationCompletion = completion;
    
    double lastValue = _grillValue;
    
    [self updateGrillValue:value];
    double middleValue = lastValue + (((lastValue + (_grillValue - lastValue) / 2.0) >= 0) ? (_grillValue - lastValue) / 2.0 : (lastValue - _grillValue) / 2.0);
    
    // Needle animation to target value
    // An intermediate "middle" value is used to make sure the needle will follow the right rotation direction
    
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.removedOnCompletion = YES;
    animation.duration = animated ? duration : 0.0;
    animation.delegate = self;
    animation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeRotation([self needleAngleForValue:lastValue]  , 0, 0, 1.0)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeRotation([self needleAngleForValue:middleValue], 0, 0, 1.0)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeRotation([self needleAngleForValue:_grillValue]     , 0, 0, 1.0)]];
    
    if ([_style conformsToProtocol:@protocol(WMGaugeViewStyle)] == NO || [_style needleLayer:rootNeedleLayer willMoveAnimated:animated duration:duration animation:animation] == NO)
    {
        rootNeedleLayer.transform = [[animation.values lastObject] CATransform3DValue];
        [rootNeedleLayer addAnimation:animation forKey:kCATransition];
    }
}

/**
 * Update gauge value with animation, duration and fire a completion block
 */
- (void)setTagTmpValue:(float)value animated:(BOOL)animated duration:(NSTimeInterval)duration completion:(void (^)(BOOL finished))completion
{
    animationCompletion = completion;
    
    double lastValue = _TagValue;
    
    [self updateTagValue:value];
    double middleValue = lastValue + (((lastValue + (_TagValue - lastValue) / 2.0) >= 0) ? (_TagValue - lastValue) / 2.0 : (lastValue - _TagValue) / 2.0);
    
    // Needle animation to target value
    // An intermediate "middle" value is used to make sure the needle will follow the right rotation direction
    
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.removedOnCompletion = YES;
    animation.duration = animated ? duration : 0.0;
    animation.delegate = self;
    animation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeRotation([self needleAngleForValue:lastValue]  , 0, 0, 1.0)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeRotation([self needleAngleForValue:middleValue], 0, 0, 1.0)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeRotation([self needleAngleForValue:_TagValue]     , 0, 0, 1.0)]];
    
    if ([_style conformsToProtocol:@protocol(WMGaugeViewStyle)] == NO || [_style needleLayer:tagTemlayer willMoveAnimated:animated duration:duration animation:animation] == NO)
    {
        tagTemlayer.transform = [[animation.values lastObject] CATransform3DValue];
        [tagTemlayer addAnimation:animation forKey:kCATransition];
    }
}
- (void)setfoodTmpValue:(float)value animated:(BOOL)animated duration:(NSTimeInterval)duration completion:(void (^)(BOOL finished))completion {
    animationCompletion = completion;
    
    double lastValue = _foodValue;
    
    [self updatefoodValue:value];
    double middleValue = lastValue + (((lastValue + (_foodValue - lastValue) / 2.0) >= 0) ? (_foodValue - lastValue) / 2.0 : (lastValue - _foodValue) / 2.0);
    
    // Needle animation to target value
    // An intermediate "middle" value is used to make sure the needle will follow the right rotation direction
    
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.removedOnCompletion = YES;
    animation.duration = animated ? duration : 0.0;
    animation.delegate = self;
    animation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeRotation([self needleAngleForValue:lastValue]  , 0, 0, 1.0)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeRotation([self needleAngleForValue:middleValue], 0, 0, 1.0)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeRotation([self needleAngleForValue:_foodValue]     , 0, 0, 1.0)]];
    
    if ([_style conformsToProtocol:@protocol(WMGaugeViewStyle)] == NO || [_style needleLayer:foodTemlayer willMoveAnimated:animated duration:duration animation:animation] == NO)
    {
        foodTemlayer.transform = [[animation.values lastObject] CATransform3DValue];
        [foodTemlayer addAnimation:animation forKey:kCATransition];
    }
}
#pragma mark - CAAnimation delegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (animationCompletion)
        animationCompletion(flag);
    
    animationCompletion = nil;
}

#pragma mark - Properties

- (void)setValue:(float)value
{
    [self setValue:value animated:YES];
}

- (void)setShowInnerBackground:(bool)showInnerBackground
{
    _showInnerBackground = showInnerBackground;
    [self invalidateBackground];
}

- (void)setShowInnerRim:(bool)showInnerRim
{
    _showInnerRim = showInnerRim;
    [self invalidateBackground];
}

- (void)setInnerRimWidth:(CGFloat)innerRimWidth
{
    _innerRimWidth = innerRimWidth;
    [self invalidateBackground];
}

- (void)setInnerRimBordeWidth:(CGFloat)innerRimBorderWidth
{
    _innerRimBorderWidth = innerRimBorderWidth;
    [self invalidateBackground];
}

- (void)setScalePosition:(CGFloat)scalePosition
{
    _scalePosition = scalePosition;
    [self invalidateBackground];
}

- (void)setScaleStartAngle:(CGFloat)scaleStartAngle
{
    _scaleStartAngle = scaleStartAngle;
    [self invalidateBackground];
}

- (void)setScaleEndAngle:(CGFloat)scaleEndAngle
{
    _scaleEndAngle = scaleEndAngle;
    [self invalidateBackground];
}

- (void)setScaleDivisions:(CGFloat)scaleDivisions
{
    _scaleDivisions = scaleDivisions;
    [self invalidateBackground];
}

- (void)setScaleSubdivisions:(CGFloat)scaleSubdivisions
{
    _scaleSubdivisions = scaleSubdivisions;
    [self invalidateBackground];
}

- (void)setShowScaleShadow:(bool)showScaleShadow
{
    _showScaleShadow = showScaleShadow;
    [self invalidateBackground];
}

- (void)setShowScale:(bool)showScale
{
    _showScale = showScale;
    [self invalidateBackground];
}

- (void)setScalesubdivisionsAligment:(WMGaugeViewSubdivisionsAlignment)scalesubdivisionsAligment
{
    _scalesubdivisionsAligment = scalesubdivisionsAligment;
    [self invalidateBackground];
}

- (void)setScaleDivisionsLength:(CGFloat)scaleDivisionsLength
{
    _scaleDivisionsLength = scaleDivisionsLength;
    [self invalidateBackground];
}

- (void)setScaleDivisionsWidth:(CGFloat)scaleDivisionsWidth
{
    _scaleDivisionsWidth = scaleDivisionsWidth;
    [self invalidateBackground];
}

- (void)setScaleSubdivisionsLength:(CGFloat)scaleSubdivisionsLength
{
    _scaleSubdivisionsLength = scaleSubdivisionsLength;
    [self invalidateBackground];
}

- (void)setScaleSubdivisionsWidth:(CGFloat)scaleSubdivisionsWidth
{
    _scaleSubdivisionsWidth = scaleSubdivisionsWidth;
    [self invalidateBackground];
}

- (void)setScaleDivisionColor:(UIColor *)scaleDivisionColor
{
    _scaleDivisionColor = scaleDivisionColor;
    [self invalidateBackground];
}

- (void)setScaleSubDivisionColor:(UIColor *)scaleSubDivisionColor
{
    _scaleSubDivisionColor = scaleSubDivisionColor;
    [self invalidateBackground];
}

- (void)setScaleFont:(UIFont *)scaleFont
{
    _scaleFont = scaleFont;
    [self invalidateBackground];
}

- (void)setRangeLabelsWidth:(CGFloat)rangeLabelsWidth
{
    _rangeLabelsWidth = rangeLabelsWidth;
    [self invalidateBackground];
}

- (void)setMinValue:(float)minValue
{
    _minValue = minValue;
    [self invalidateBackground];
}

- (void)setMaxValue:(float)maxValue
{
    _maxValue = maxValue;
    [self invalidateBackground];
}

- (void)setRangeValues:(NSArray *)rangeValues
{
    _rangeValues = rangeValues;
    [self invalidateBackground];
}

- (void)setRangeColors:(NSArray *)rangeColors
{
    _rangeColors = rangeColors;
    [self invalidateBackground];
}

- (void)setRangeLabels:(NSArray *)rangeLabels
{
    _rangeLabels = rangeLabels;
    [self invalidateBackground];
}

- (void)setUnitOfMeasurement:(NSString *)unitOfMeasurement
{
    _unitOfMeasurement = unitOfMeasurement;
    [self invalidateBackground];
}

- (void)setShowUnitOfMeasurement:(bool)showUnitOfMeasurement
{
    _showUnitOfMeasurement = showUnitOfMeasurement;
    [self invalidateBackground];
}

- (void)setShowRangeLabels:(bool)showRangeLabels
{
    _showRangeLabels = showRangeLabels;
    [self invalidateBackground];
}

- (void)setRangeLabelsFontKerning:(CGFloat)rangeLabelsFontKerning
{
    _rangeLabelsFontKerning = rangeLabelsFontKerning;
    [self invalidateBackground];
}

- (void)setUnitOfMeasurementFont:(UIFont *)unitOfMeasurementFont
{
    _unitOfMeasurementFont = unitOfMeasurementFont;
    [self invalidateBackground];
}

- (void)setRangeLabelsFont:(UIFont *)rangeLabelsFont
{
    _rangeLabelsFont = rangeLabelsFont;
    [self invalidateBackground];
}

- (void)setUnitOfMeasurementVerticalOffset:(CGFloat)unitOfMeasurementVerticalOffset
{
    _unitOfMeasurementVerticalOffset = unitOfMeasurementVerticalOffset;
    [self invalidateBackground];
}

- (void)setUnitOfMeasurementColor:(UIColor *)unitOfMeasurementColor
{
    _unitOfMeasurementColor = unitOfMeasurementColor;
    [self invalidateBackground];
}

- (void)setRangeLabelsFontColor:(UIColor *)rangeLabelsFontColor
{
    _rangeLabelsFontColor = rangeLabelsFontColor;
    [self invalidateBackground];
}

- (void)setStyle:(id<WMGaugeViewStyle>)style {
    _style = style;
    [self invalidateBackground];
    [self invalidateNeedle];
}

@end
