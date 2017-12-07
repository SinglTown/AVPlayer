//
//  CBLoadingView.m
//  AVPlayer
//
//  Created by 赵传保 on 2017/12/6.
//  Copyright © 2017年 赵传保. All rights reserved.
//

#import "CBLoadingView.h"

#define LoadingWidth 50
#define AnimationTime 0.1

@interface CBLoadingView ()

@property (nonatomic,strong)NSTimer *timer;

@property (nonatomic,strong)CAShapeLayer *shapeLayer;


@end


@implementation CBLoadingView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self allViews];
    }
    return self;
}
-(void)allViews
{
    self.loadColor = [UIColor whiteColor];
}
//开始转圈
-(void)beginLoad
{
    /**
    CAshapeLayer *shapeLayer = [CAshapeLayer layer];
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.strokeColor = self.loadColor.CGColor;
    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.lineJoin = kCALineJoinRound;
    shapeLayer.lineWidth = 2;
    shapeLayer.strokeStart = 0.7f;
    shapeLayer.strokeEnd = 0.1f;
    shapeLayer.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.width/2, self.height/2) radius:25 startAngle:0 endAngle:M_PI*2 clockwise:YES].CGPath;
    [self.layer addSublayer:shapeLayer];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    animation.removedOnCompletion = YES;
    animation.duration = 1.5;
    animation.fillMode = kCAFillModeBackwards;
    animation.repeatCount = HUGE_VALF;
    animation.toValue = @1.1;
    
    [shapeLayer addAnimation:animation forKey:@"animation"];
     **/
    
    [self.shapeLayer removeFromSuperlayer];
    [self.timer invalidate];
    self.timer = nil;
    
    self.shapeLayer = [CAShapeLayer layer];
    self.shapeLayer.frame = self.bounds;
    self.shapeLayer.position = self.center;
    self.shapeLayer.strokeStart = 0;
    self.shapeLayer.strokeEnd = 0;
    self.shapeLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(self.width/2-LoadingWidth/2.0, self.height/2-LoadingWidth/2.0, LoadingWidth, LoadingWidth)].CGPath;
    self.shapeLayer.fillColor = [UIColor clearColor].CGColor;
    self.shapeLayer.strokeColor = self.loadColor.CGColor;
    self.shapeLayer.lineWidth = 1.0f;
    
    [self.layer addSublayer:self.shapeLayer];
    
    //添加定时器来控制strokeStart和strokeEnd
    self.timer = [NSTimer scheduledTimerWithTimeInterval:AnimationTime target:self selector:@selector(setLoadAnimation:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
    /**
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration = 1;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    animation.fromValue = [NSNumber numberWithFloat:0];
    animation.toValue = [NSNumber numberWithFloat:1.0f];
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.repeatCount = MAXFLOAT;
    [self.shapeLayer addAnimation:animation forKey:@"animation"];
    **/
    

    
}
-(void)setLoadAnimation:(NSTimer *)sender
{
    if (self.shapeLayer.strokeEnd > 1 && self.shapeLayer.strokeStart < 1) {
        self.shapeLayer.strokeStart += AnimationTime;
    }else if(self.shapeLayer.strokeStart == 0){
        self.shapeLayer.strokeEnd += AnimationTime;
    }
//    NSLog(@"%f",AnimationTime);
//    NSLog(@"%f",self.shapeLayer.strokeStart);
//    NSLog(@"%f",self.shapeLayer.strokeEnd);
    if (self.shapeLayer.strokeEnd == 0) {
        self.shapeLayer.strokeStart = 0;
    }
    
    if (self.shapeLayer.strokeStart == self.shapeLayer.strokeEnd) {
        self.shapeLayer.strokeEnd = 0;
    }
    
}
//停止
-(void)stopLoad
{
    [self.shapeLayer removeFromSuperlayer];
    [self.timer invalidate];
    self.timer = nil;
    [self removeFromSuperview];
}
@end
