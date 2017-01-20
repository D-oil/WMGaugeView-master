/*
 * WMGaugeView.h
 *
 * Copyright (C) 2014 William Markezana <william.markezana@me.com>
 *
 */

/*
    单词扫盲
    Gauge： 尺度，标准; 测量仪器，这里翻译为仪表
    invalidate：使无效; 使作废;
    Subdivisions：分支; 细分
    Inner：内部
    rim：边缘，环绕，框
    Border：边界
    scale：规模; 比例（尺）
    Position：位置
    Angle：角度
    Divisions：分歧; 分开( division的名词复数 ); 分界线 （在这个view里是每个刻度点）
    Subdivisions：分支; 细分 （每个整数刻度点）
 */

#import <UIKit/UIKit.h>
#import "WMGaugeViewStyle.h"
#import "WMGaugeViewStyleFlatThin.h"


/**
 * Styling enumerations
 */
typedef enum
{
    WMGaugeViewSubdivisionsAlignmentTop,
    WMGaugeViewSubdivisionsAlignmentCenter,
    WMGaugeViewSubdivisionsAlignmentBottom
}
WMGaugeViewSubdivisionsAlignment;

/**
 * WMGaugeView class
 */
@interface WMGaugeView : UIView

/**
 * WMGaugeView properties
 */
@property (nonatomic, readwrite, assign) bool showInnerBackground;
@property (nonatomic, readwrite, assign) bool showInnerRim;
@property (nonatomic, readwrite, assign) CGFloat innerRimWidth;
@property (nonatomic, readwrite, assign) CGFloat innerRimBorderWidth;
@property (nonatomic, readwrite, assign) CGFloat scalePosition;
@property (nonatomic, readwrite, assign) CGFloat scaleStartAngle;
@property (nonatomic, readwrite, assign) CGFloat scaleEndAngle;
@property (nonatomic, readwrite, assign) CGFloat scaleDivisions;
@property (nonatomic, readwrite, assign) CGFloat scaleSubdivisions;
@property (nonatomic, readwrite, assign) bool showScaleShadow;
@property (nonatomic, readwrite, assign) bool showScale;
@property (nonatomic, readwrite, assign) WMGaugeViewSubdivisionsAlignment scalesubdivisionsAligment;
@property (nonatomic, readwrite, assign) CGFloat scaleDivisionsLength;
@property (nonatomic, readwrite, assign) CGFloat scaleDivisionsWidth;
@property (nonatomic, readwrite, assign) CGFloat scaleSubdivisionsLength;
@property (nonatomic, readwrite, assign) CGFloat scaleSubdivisionsWidth;
@property (nonatomic, readwrite, strong) UIColor *scaleDivisionColor;
@property (nonatomic, readwrite, strong) UIColor *scaleSubDivisionColor;
@property (nonatomic, readwrite, strong) UIFont *scaleFont;
@property (nonatomic, readwrite, assign) float grillValue;
@property (nonatomic, readwrite, assign) float TagValue;
@property (nonatomic, readwrite, assign) float foodValue;
@property (nonatomic, readwrite, assign) float minValue;
@property (nonatomic, readwrite, assign) float maxValue;
@property (nonatomic, readwrite, assign) bool showRangeLabels;
@property (nonatomic, readwrite, assign) CGFloat rangeLabelsWidth;
@property (nonatomic, readwrite, strong) UIFont *rangeLabelsFont;
@property (nonatomic, readwrite, strong) UIColor *rangeLabelsFontColor;
@property (nonatomic, readwrite, assign) CGFloat rangeLabelsFontKerning;
@property (nonatomic, readwrite, strong) NSArray *rangeValues;
@property (nonatomic, readwrite, strong) NSArray *rangeColors;
@property (nonatomic, readwrite, strong) NSArray *rangeLabels;
@property (nonatomic, readwrite, strong) UIColor *unitOfMeasurementColor;
@property (nonatomic, readwrite, assign) CGFloat unitOfMeasurementVerticalOffset;
@property (nonatomic, readwrite, strong) UIFont *unitOfMeasurementFont;
@property (nonatomic, readwrite, strong) NSString *unitOfMeasurement;
@property (nonatomic, readwrite, assign) bool showUnitOfMeasurement;
@property (nonatomic, readwrite, strong) id<WMGaugeViewStyle> style;

/**
 * WMGaugeView public functions
 */
- (void)setValue:(float)value animated:(BOOL)animated;
- (void)setValue:(float)value animated:(BOOL)animated completion:(void (^)(BOOL finished))completion;
- (void)setValue:(float)value animated:(BOOL)animated duration:(NSTimeInterval)duration;
- (void)setValue:(float)value animated:(BOOL)animated duration:(NSTimeInterval)duration completion:(void (^)(BOOL finished))completion;


- (void)setTagTmpValue:(float)value animated:(BOOL)animated duration:(NSTimeInterval)duration completion:(void (^)(BOOL finished))completion;
- (void)setfoodTmpValue:(float)value animated:(BOOL)animated duration:(NSTimeInterval)duration completion:(void (^)(BOOL finished))completion;
@end
