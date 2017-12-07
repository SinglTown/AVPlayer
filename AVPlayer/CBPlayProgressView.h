//
//  CBPlayProgressView.h
//  AVPlayer
//
//  Created by 赵传保 on 2017/12/6.
//  Copyright © 2017年 赵传保. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PlayProgressViewBlock)(CGFloat ratio);

@interface CBPlayProgressView : UIView

@property (nonatomic,strong)UIColor *playColor;//播放的进度的颜色

@property (nonatomic,strong)UIColor *cacheColor;//缓冲的进度的颜色


@property (nonatomic,assign)CGFloat playProgress;//播放进度

@property (nonatomic,assign)CGFloat cacheProgress;//缓存进度

@property (nonatomic,assign)BOOL isShowProgressBtn;//是否显示拖进度的按钮


@end
