//
//  ADSlideBar.h
//  WMGaugeView
//
//  Created by andong on 2017/1/22.
//  Copyright © 2017年 Will™. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADSlideBar : UIView

@property (nonatomic,strong) UIColor *RoundColor;

@property (nonatomic,assign) NSInteger progressWidth;

@property (nonatomic,assign) CGFloat progress;

@property (nonatomic,strong) UIButton *progressButton;

@end
