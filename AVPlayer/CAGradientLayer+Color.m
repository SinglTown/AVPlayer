//
//  CAGradientLayer+Color.m
//  AVPlayer
//
//  Created by 赵传保 on 2017/12/7.
//  Copyright © 2017年 赵传保. All rights reserved.
//

#import "CAGradientLayer+Color.h"

@implementation CAGradientLayer (Color)

//虚化颜色,返回一盒Layer
+(CAGradientLayer *)getGradientChangeColorWithBounds:(CGRect)bounds
{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = bounds;
    //创建渐变色数组，需要转换为CGColor颜色
    gradientLayer.colors = @[(__bridge id)RGBACOLOR(34, 35, 38, 0.01).CGColor,(__bridge id)RGBACOLOR(34, 35, 38, 0.5).CGColor];
    //设置渐变颜色方向，左上点为(0,0), 右下点为(1,1)
    gradientLayer.startPoint = CGPointMake(0, 0.5);
    gradientLayer.endPoint = CGPointMake(0, 1);
    //设置颜色变化点，取值范围 0.0~1.0
    gradientLayer.locations = @[@0,@1];
    return gradientLayer;
}


@end
