//
//  SunSliderView.h
//  TestLayout
//
//  Created by 孙兴祥 on 2017/3/21.
//  Copyright © 2017年 sunxiangxiang. All rights reserved.
//

//高20
#import <UIKit/UIKit.h>

@protocol SunSliderViewProtocol <NSObject>

@optional
- (void)startMoveWithPercent:(float)percent;    //开始拖动
- (void)moveWithPercent:(float)percent;         //正在拖动
- (void)stopMoveWithPercent:(float)percent;     //结束拖动

@end

@interface SunSliderView : UIView

@property (nonatomic,assign) float playPercent;     //播放进度
@property (nonatomic,assign) float bufferPercent;   //缓冲进度
@property (nonatomic,weak) id<SunSliderViewProtocol> delegate;

@end
