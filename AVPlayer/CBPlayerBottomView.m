//
//  CBPlayerBottomView.m
//  AVPlayer
//
//  Created by 赵传保 on 2017/12/6.
//  Copyright © 2017年 赵传保. All rights reserved.
//

#import "CBPlayerBottomView.h"
#import "CBPlayProgressView.h"

#define TimeShowWidth 60
#define FullScreenWidth 50

@interface CBPlayerBottomView()

@property (nonatomic,strong)CBPlayProgressView *progressView;

@property (nonatomic,strong)UILabel *leftPlayTime;//左侧播放时间

@property (nonatomic,strong)UILabel *rightTotalTime;//右侧总时间

@property (nonatomic,strong)UIButton *rightBtn;//右侧全屏的按钮

@end

@implementation CBPlayerBottomView

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
    [self addSubview:self.leftPlayTime];
    [self addSubview:self.progressView];
    [self addSubview:self.rightTotalTime];
    [self addSubview:self.rightBtn];
    
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.leftPlayTime.frame = CGRectMake(0, 0, TimeShowWidth, self.height);
    self.rightTotalTime.frame = CGRectMake(self.width-TimeShowWidth-FullScreenWidth, 0, TimeShowWidth, self.height);
    self.progressView.frame = CGRectMake(TimeShowWidth, (self.height-2)/2, self.width-TimeShowWidth*2-FullScreenWidth, 2);
    self.rightBtn.frame = CGRectMake(self.width-FullScreenWidth, 0, FullScreenWidth, self.height);
    
    
}
-(UILabel *)leftPlayTime
{
    if (!_leftPlayTime) {
        _leftPlayTime = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, TimeShowWidth, self.height)];
        _leftPlayTime.textAlignment = NSTextAlignmentCenter;
        _leftPlayTime.font = [UIFont systemFontOfSize:15];
        _leftPlayTime.textColor = [UIColor orangeColor];
    }
    return _leftPlayTime;
}
-(UILabel *)rightTotalTime
{
    if (!_rightTotalTime) {
        _rightTotalTime = [[UILabel alloc] initWithFrame:CGRectMake(self.width-TimeShowWidth-FullScreenWidth, 0, TimeShowWidth, self.height)];
        _rightTotalTime.textAlignment = NSTextAlignmentCenter;
        _rightTotalTime.font = [UIFont systemFontOfSize:15];
        _rightTotalTime.textColor = [UIColor orangeColor];
    }
    return _rightTotalTime;
}
-(CBPlayProgressView *)progressView
{
    if (!_progressView) {
        _progressView = [[CBPlayProgressView alloc] initWithFrame:CGRectMake(TimeShowWidth, (self.height-2)/2, self.width-TimeShowWidth*2-FullScreenWidth, 2)];
        _progressView.isShowProgressBtn = YES;
    }
    return _progressView;
}
-(UIButton *)rightBtn
{
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightBtn.frame = CGRectMake(self.width-FullScreenWidth, 0, FullScreenWidth, self.height);
        [_rightBtn setTitle:@"全屏" forState:UIControlStateNormal];
        [_rightBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(allScreenAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}
-(void)allScreenAction:(UIButton *)sender
{
    NSLog(@"全屏,收起全屏");
    if (self.delegate && [self.delegate respondsToSelector:@selector(allScreenOfPlayer)]) {
        [self.delegate allScreenOfPlayer];
    }
}
-(void)setPlayTime:(NSString *)playTime
{
    _playTime = playTime;
    
    //转化时间
    self.leftPlayTime.text = [self getTimeStyleWithTime:playTime];
}
-(void)setTotalTime:(NSString *)totalTime
{
    _totalTime = totalTime;
    //总时间
    self.rightTotalTime.text = [self getTimeStyleWithTime:totalTime];
}
-(void)setPlayProgress:(CGFloat)playProgress
{
    _playProgress = playProgress;
    
    self.progressView.playProgress = playProgress;
}
-(void)setCacheProgress:(CGFloat)cacheProgress
{
    _cacheProgress = cacheProgress;
    
    self.progressView.cacheProgress = cacheProgress;
}
//转化时间
-(NSString *)getTimeStyleWithTime:(NSString *)time
{
    int totalTime = [time intValue];
    int minite = totalTime/60;
    if (minite == 0) {
        return [NSString stringWithFormat:@"00:%02d",totalTime];
    }else{
        int second = totalTime-minite*60;
        return [NSString stringWithFormat:@"%02d:%02d",minite,second];
    }
}
@end
