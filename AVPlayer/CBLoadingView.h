//
//  CBLoadingView.h
//  AVPlayer
//
//  Created by 赵传保 on 2017/12/6.
//  Copyright © 2017年 赵传保. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBLoadingView : UIView

@property (nonatomic,strong)UIColor *loadColor;

//开始转圈
-(void)beginLoad;

//停止
-(void)stopLoad;

@end
