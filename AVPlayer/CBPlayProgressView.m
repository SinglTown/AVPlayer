//
//  CBPlayProgressView.m
//  AVPlayer
//
//  Created by 赵传保 on 2017/12/6.
//  Copyright © 2017年 赵传保. All rights reserved.
//

#import "CBPlayProgressView.h"

#define ProgressBtnWidth 15

@interface CBPlayProgressView()

@property (nonatomic,strong)UIView *cacheProgressView;

@property (nonatomic,strong)UIView *playProgressView;

@property (nonatomic,strong)UIButton *progressBtn;

@end

@implementation CBPlayProgressView

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
    self.backgroundColor = [UIColor grayColor];
    self.cacheColor = [UIColor orangeColor];
    self.playColor = [UIColor purpleColor];
    
    [self addSubview:self.cacheProgressView];
    [self addSubview:self.playProgressView];
    [self addSubview:self.progressBtn];
}
-(void)layoutSubviews
{
    [super layoutSubviews];

    self.progressBtn.center = CGPointMake(self.playProgressView.right, self.playProgressView.center.y);
}
-(void)setPlayColor:(UIColor *)playColor
{
    _playColor = playColor;
    self.playProgressView.backgroundColor = playColor;
}
-(void)setCacheColor:(UIColor *)cacheColor
{
    _cacheColor = cacheColor;
    self.cacheProgressView.backgroundColor = cacheColor;
}
-(UIView *)cacheProgressView
{
    if (!_cacheProgressView) {
        _cacheProgressView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, self.height)];
    }
    return _cacheProgressView;
}
-(UIView *)playProgressView
{
    if (!_playProgressView) {
        _playProgressView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, self.height)];
    }
    return _playProgressView;
}
-(UIButton *)progressBtn
{
    if (!_progressBtn) {
        _progressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _progressBtn.frame = CGRectMake(0, 0, ProgressBtnWidth, ProgressBtnWidth);
        _progressBtn.center = CGPointMake(self.playProgressView.right, self.playProgressView.center.y);
        _progressBtn.backgroundColor = [UIColor orangeColor];
        _progressBtn.layer.cornerRadius = ProgressBtnWidth/2;
        _progressBtn.userInteractionEnabled = YES;
        
        
        UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGRAction:)];
        [_progressBtn addGestureRecognizer:panGR];
    }
    return _progressBtn;
}
-(void)panGRAction:(UIPanGestureRecognizer *)sender
{
    CGPoint point = [sender locationInView:self];
    NSLog(@"%@",@(point));
    if (point.x <= 0) {
        point.x = 0;
    }else if (point.x >= self.width){
        point.x = self.width;
    }
    self.playProgressView.width = point.x;
    self.progressBtn.center = CGPointMake(self.playProgressView.right, self.playProgressView.center.y);
    
    //此处要回调进度,去定位播放时间
    
}
-(void)setPlayProgress:(CGFloat)playProgress
{
    _playProgress = playProgress;
    
    if (playProgress > 1) {
        playProgress = 1;
    }
    CGFloat width = self.width*playProgress;
    if (self.playProgressView.width > width) {
        self.playProgressView.width = width;
    }else{
        [UIView animateWithDuration:1 animations:^{
            self.playProgressView.width = width;
        }];
    }
    
}
-(void)setCacheProgress:(CGFloat)cacheProgress
{
    _cacheProgress = cacheProgress;
    if (cacheProgress > 1) {
        cacheProgress = 1;
    }
    CGFloat width = self.width*cacheProgress;
    [UIView animateWithDuration:10 animations:^{
        self.cacheProgressView.width = width;
    }];
}
-(void)setIsShowProgressBtn:(BOOL)isShowProgressBtn
{
    _isShowProgressBtn = isShowProgressBtn;
    
    self.progressBtn.hidden = !isShowProgressBtn;
}
@end
