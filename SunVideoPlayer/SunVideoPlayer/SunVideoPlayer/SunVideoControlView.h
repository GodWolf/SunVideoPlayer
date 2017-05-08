//
//  SunVideoControlView.h
//  SunVideoPlayer
//
//  Created by 孙兴祥 on 2017/4/25.
//  Copyright © 2017年 sunxiangxiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SunVideoControlProtocol <NSObject>

@optional
- (void)playToSecondTime:(int)seconds;
- (void)playOrPause:(BOOL)isPlay;
- (void)changePlayRate:(float)rate;

@end

@interface SunVideoControlView : UIView

@property (nonatomic,assign) double duration;
@property (nonatomic,assign) double currentTime;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,assign) BOOL isDrag;
@property (nonatomic,weak) id<SunVideoControlProtocol> delegate;

@end
