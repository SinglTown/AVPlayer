//
//  CBPlayer.m
//  AVPlayer
//
//  Created by 赵传保 on 2017/12/6.
//  Copyright © 2017年 赵传保. All rights reserved.
//

#import "CBPlayer.h"
#import "CBLoadingView.h"
#import "CBPlayProgressView.h"
#import "CBPlayerBottomView.h"

#define playstatus @"status"
#define playloadedTimeRanges @"loadedTimeRanges"
#define  playplaybackBufferEmpty @"playbackBufferEmpty"
#define playplaybackLikelyToKeepUp @"playbackLikelyToKeepUp"

#define PlayBottomViewHeight 40

#define PlayBeginEndBtnWidht 50

@interface CBPlayer () < CBPlayerBottomViewDelegate>

@property (nonatomic,strong)AVPlayer *player;

@property (nonatomic,strong)AVPlayerItem *currentItem;

@property (nonatomic,strong)id  timeObser;//播放器观察者


@property (nonatomic,strong)CBLoadingView *loadingView;//loadingView

@property (nonatomic,strong)UIButton *beginStopBtn;//开始暂停的按钮

@property (nonatomic,strong)CBPlayProgressView *bottomProgressView;//播放进度

@property (nonatomic,strong)CBPlayerBottomView *bottomPlayerView;//底部工具

@property (nonatomic,assign)BOOL isShowBottomView;//是否显示进度时间
@property (nonatomic,assign)BOOL isPalying;//是否正在播放
@end

@implementation CBPlayer

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
    NSString *url = @"http://video.klm123.com/05ac45790c8946609bf2cdc42e4ba192/34c36444dd2243d8b68424c35bf3d8a4_10.mp4";
    self.currentItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:url]];
    self.player = [AVPlayer playerWithPlayerItem:self.currentItem];
    AVPlayerLayer *playerlayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    playerlayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self.layer addSublayer:playerlayer];
    
    //添加监控
    [self addPlayerObserver];
    //给当前playerItem添加观察者
    [self addObserverToPlayerItem:self.currentItem];
    //添加视频播放的相关监控
    [self addNotificationForPlayer];
    
    //开始暂停按钮
    [self addSubview:self.beginStopBtn];
    //底部进度
    [self addSubview:self.bottomProgressView];
    //底部整个
    [self addSubview:self.bottomPlayerView];
    
    //添加整个的点击事件
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backTapAction:)];
    [self addGestureRecognizer:tapGR];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    //此处要更改frame,旋转之后有变化
    self.beginStopBtn.frame = CGRectMake(0, 0, PlayBeginEndBtnWidht, PlayBeginEndBtnWidht);
    self.beginStopBtn.center = CGPointMake(self.width/2, self.height/2);
    self.bottomProgressView.frame = CGRectMake(0, self.height-2, self.width, 2);
    self.bottomPlayerView.frame = CGRectMake(0, self.height-PlayBottomViewHeight, self.width, PlayBottomViewHeight);
}
#pragma mark - 视频点击事件(处理全屏或者暂停)
-(void)backTapAction:(UITapGestureRecognizer *)sender
{
    NSLog(@"点击事件");
    
    if (self.isShowBottomView) {
        [self hiddenBottomView];
    }else{
        [self showBottomView];
    }
    
}
#pragma mark - 开始暂停按钮
-(UIButton *)beginStopBtn
{
    if (!_beginStopBtn) {
        _beginStopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _beginStopBtn.frame = CGRectMake(0, 0, PlayBeginEndBtnWidht, PlayBeginEndBtnWidht);
        _beginStopBtn.center = CGPointMake(self.width/2, self.height/2);
        _beginStopBtn.backgroundColor = [UIColor orangeColor];
        _beginStopBtn.layer.cornerRadius = PlayBeginEndBtnWidht/2;
        [_beginStopBtn addTarget:self action:@selector(beginStopBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
        _beginStopBtn.hidden = YES;
    }
    return _beginStopBtn;
}
-(void)beginStopBtnClickAction:(UIButton *)sender
{
    NSLog(@"开始暂停按钮");
    if (self.isPalying) {
        self.isPalying = NO;
        [self.beginStopBtn setTitle:@"播放" forState:UIControlStateNormal];
        [self.player pause];
    }else{
        self.isPalying = YES;
        [self.beginStopBtn setTitle:@"暂停" forState:UIControlStateNormal];
        [self.player play];
    }
}
#pragma mark - 进度
-(CBPlayProgressView *)bottomProgressView
{
    if (!_bottomProgressView) {
        _bottomProgressView = [[CBPlayProgressView alloc] initWithFrame:CGRectMake(0, self.height-2, self.width, 2)];
        _bottomProgressView.isShowProgressBtn = NO;
    }
    return _bottomProgressView;
}
#pragma mark - 底部时间进度相关
-(CBPlayerBottomView *)bottomPlayerView
{
    if (!_bottomPlayerView) {
        _bottomPlayerView = [[CBPlayerBottomView alloc] initWithFrame:CGRectMake(0, self.height-PlayBottomViewHeight, self.width, PlayBottomViewHeight)];
        _bottomPlayerView.alpha = 0;
        [_bottomPlayerView.layer addSublayer:[CAGradientLayer getGradientChangeColorWithBounds:_bottomPlayerView.bounds]];
        _bottomPlayerView.delegate = self;
    }
    return _bottomPlayerView;
}
//代理方法
-(void)allScreenOfPlayer
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(enterOutAllScreenOfPlayer)]) {
        [self.delegate enterOutAllScreenOfPlayer];
    }
}
//显示菜单
-(void)showBottomView
{
    self.beginStopBtn.hidden = NO;
    if (self.isPalying) {
        [self.beginStopBtn setTitle:@"暂停" forState:UIControlStateNormal];
    }else{
        [self.beginStopBtn setTitle:@"播放" forState:UIControlStateNormal];
    }
    self.bottomProgressView.hidden = YES;
    self.isShowBottomView = YES;
    self.bottomPlayerView.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.bottomPlayerView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.isShowBottomView) {
            [self hiddenBottomView];
        }
    });
}
//菜单消失
-(void)hiddenBottomView
{
    self.beginStopBtn.hidden = YES;
    self.bottomProgressView.hidden = NO;
    self.isShowBottomView = NO;
    self.bottomPlayerView.alpha = 1;
    [UIView animateWithDuration:0.3 animations:^{
        self.bottomPlayerView.alpha = 0;
    } completion:^(BOOL finished) {
    }];
}
//开始播放
-(void)play
{
    self.isPalying = YES;
    //开始播放
    [self.player play];
    //加载
    [self addSubview:self.loadingView];
    [self.loadingView beginLoad];
}
//暂停
-(void)pause
{
    
}
//添加监控(注意要移除观察者)
-(void)addPlayerObserver
{
    __weak typeof(self) weakSelf = self;
    self.timeObser = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        
        [weakSelf.loadingView stopLoad];
        
        AVPlayerItem *playerItem = weakSelf.player.currentItem;
        float current = CMTimeGetSeconds(time);
        float total = CMTimeGetSeconds([playerItem duration]);
        NSLog(@"当前时间%f",current);
        NSLog(@"总长度%f",total);
        //计算进度
        CGFloat progress;
        if (total > 0) {
            if (current > 0) {
                progress = current/total;
            }else{
                progress = 0;
            }
        }else{
            progress = 0;
        }
        weakSelf.bottomProgressView.playProgress = progress;
        weakSelf.bottomPlayerView.playProgress = progress;
        weakSelf.bottomPlayerView.playTime = [NSString stringWithFormat:@"%f",current];
        weakSelf.bottomPlayerView.totalTime = [NSString stringWithFormat:@"%f",total];
    }];
}
//给当前playerItem添加观察者
-(void)addObserverToPlayerItem:(AVPlayerItem *)playerItem
{
    [playerItem addObserver:self forKeyPath:playstatus options:NSKeyValueObservingOptionNew context:nil];
    [playerItem addObserver:self forKeyPath:playloadedTimeRanges options:NSKeyValueObservingOptionNew context:nil];
    [playerItem addObserver:self forKeyPath:playplaybackBufferEmpty options:NSKeyValueObservingOptionNew context:nil];
    [playerItem addObserver:self forKeyPath:playplaybackLikelyToKeepUp options:NSKeyValueObservingOptionNew context:nil];
}
//添加播放状态的监控
-(void)addNotificationForPlayer
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(videoPlayEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}
-(void)videoPlayEnd:(NSNotification *)sender
{
    NSLog(@"播放结束");
    [self.player seekToTime:kCMTimeZero];//设置到最初的状态
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    AVPlayerItem *item = (AVPlayerItem *)object;
    if ([keyPath isEqualToString:playstatus]) {
        //播放状态
        NSLog(@"播放状态%ld",item.status);
        if (item.status == AVPlayerItemStatusFailed) {
            [self.loadingView stopLoad];
        }
    }else if ([keyPath isEqualToString:playloadedTimeRanges]){
        //缓冲进度
        NSArray *loadArray = item.loadedTimeRanges;
        CMTimeRange range = [[loadArray firstObject] CMTimeRangeValue];
        float start = CMTimeGetSeconds(range.start);
        float duration = CMTimeGetSeconds(range.duration);
        NSTimeInterval totalTime = start + duration;//缓存总长度
        NSLog(@"某一段缓存的起始%f",start);
        NSLog(@"某一段缓存的长度%f",duration);
        NSLog(@"缓存总长度%f",totalTime);
        //设置缓存百分比
        CMTime alltime = [item duration];
        CGFloat time = CMTimeGetSeconds(alltime);
        CGFloat ratio = totalTime/time;
        NSLog(@"缓存百分比==%f",ratio);
        self.bottomProgressView.cacheProgress = ratio;
        self.bottomPlayerView.cacheProgress = ratio;
    }else if ([keyPath isEqualToString:playplaybackBufferEmpty]){
        //跳转后没数据
    }else if ([keyPath isEqualToString:playplaybackLikelyToKeepUp]){
        //隐藏菊花
    }
}
#pragma mark - 加载框
-(CBLoadingView *)loadingView
{
    if (!_loadingView) {
        _loadingView = [[CBLoadingView alloc] initWithFrame:self.bounds];
        _loadingView.loadColor = [UIColor orangeColor];
    }
    return _loadingView;
}
@end
