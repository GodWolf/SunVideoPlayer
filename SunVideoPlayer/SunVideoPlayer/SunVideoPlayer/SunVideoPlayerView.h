//
//  SunVideoPlayerView.h
//  SunVideoPlayer
//
//  Created by 孙兴祥 on 2017/4/25.
//  Copyright © 2017年 sunxiangxiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SunVideoPlayerView : UIView

+ (instancetype)sharePlayerView;

- (void)playVideoWithUrl:(NSURL *)url;


- (void)play;
- (void)pause;

@end
