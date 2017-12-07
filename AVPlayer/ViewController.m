//
//  ViewController.m
//  AVPlayer
//
//  Created by 赵传保 on 2017/12/5.
//  Copyright © 2017年 赵传保. All rights reserved.
//

#import "ViewController.h"
#import "CBPlayer.h"

@interface ViewController ()<CBPlayerDelegate>

@property (nonatomic,strong)CBPlayer *player;
@property (nonatomic,assign)BOOL isAllScreen;//是否全屏
@property (nonatomic,strong)UIView *parentView;//父view
@property (nonatomic,assign)CGRect playerFrame;//播放器frame

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.player = [[CBPlayer alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 180)];
    self.player.delegate = self;
    [self.view addSubview:self.player];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(10, 40, 60, 30);
    [btn setTitle:@"播放" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(beginPlayClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
}
-(void)beginPlayClickAction:(UIButton *)sender
{
    [self.player play];
}
#pragma mark - 代理方法
-(void)enterOutAllScreenOfPlayer
{
    if (self.isAllScreen) {
        [self outFullScreen];
    }else{
        [self enterFullScreen];
    }
}
//展开全屏
-(void)enterFullScreen
{
    self.parentView = self.player.superview;
    self.playerFrame = self.player.frame;
    
    CGRect rectInWidow = [self.player convertRect:self.player.bounds toView:[UIApplication sharedApplication].keyWindow];
    [self.player removeFromSuperview];
    self.player.frame = rectInWidow;
    [[UIApplication sharedApplication].keyWindow addSubview:self.player];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.player.transform = CGAffineTransformMakeRotation(M_PI_2);
        self.player.bounds = CGRectMake(0, 0, self.player.superview.height, self.player.superview.width);
        self.player.center = CGPointMake(self.player.superview.centerX, self.player.superview.centerY);
    } completion:^(BOOL finished) {
        
    }];
}
//收起全屏
-(void)outFullScreen
{
    CGRect frame = [self.parentView convertRect:self.playerFrame toView:[UIApplication sharedApplication].keyWindow];
    [UIView animateWithDuration:0.5 animations:^{
        self.player.transform = CGAffineTransformIdentity;
        self.player.frame = frame;
    } completion:^(BOOL finished) {
        [self.player removeFromSuperview];
        self.player.frame = self.playerFrame;
        [self.parentView addSubview:self.player];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
