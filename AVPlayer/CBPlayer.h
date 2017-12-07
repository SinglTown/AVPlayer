//
//  CBPlayer.h
//  AVPlayer
//
//  Created by 赵传保 on 2017/12/6.
//  Copyright © 2017年 赵传保. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CBPlayerDelegate <NSObject>

@optional
-(void)enterOutAllScreenOfPlayer;

@end

@interface CBPlayer : UIView

@property (nonatomic,weak)id<CBPlayerDelegate> delegate;

//设置播放的URL
@property (nonatomic,copy)NSString *playUrl;


//开始播放
-(void)play;

//暂停播放
-(void)pause;

@end
