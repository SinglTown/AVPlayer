//
//  CAGradientLayer+Color.h
//  AVPlayer
//
//  Created by 赵传保 on 2017/12/7.
//  Copyright © 2017年 赵传保. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CAGradientLayer (Color)

//虚化颜色,返回一盒Layer
+(CAGradientLayer *)getGradientChangeColorWithBounds:(CGRect)bounds;

@end
