//
//  CBPlayerBottomView.h
//  AVPlayer
//
//  Created by 赵传保 on 2017/12/6.
//  Copyright © 2017年 赵传保. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CBPlayerBottomViewDelegate <NSObject>

@optional
-(void)allScreenOfPlayer;

@end

@interface CBPlayerBottomView : UIView

@property (nonatomic,weak)id<CBPlayerBottomViewDelegate> delegate;

@property (nonatomic,copy)NSString *playTime;//播放时间

@property (nonatomic,copy)NSString *totalTime;//视频总长度

@property (nonatomic,assign)CGFloat playProgress;//播放百分比

@property (nonatomic,assign)CGFloat cacheProgress;//缓冲百分比




@end
