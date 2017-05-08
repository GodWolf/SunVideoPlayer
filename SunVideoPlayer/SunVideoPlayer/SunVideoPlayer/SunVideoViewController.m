//
//  SunVideoViewController.m
//  SunVideoPlayer
//
//  Created by 孙兴祥 on 2017/4/25.
//  Copyright © 2017年 sunxiangxiang. All rights reserved.
//

#import "SunVideoViewController.h"

@interface SunVideoViewController ()

@property (nonatomic,weak) SunVideoPlayerView *playerView;

@end

@implementation SunVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    
    _playerView = [SunVideoPlayerView sharePlayerView];
    [_playerView removeFromSuperview];
    [self.view addSubview:_playerView];
    __weak typeof(self) weakself = self;
    [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(weakself.view);
    }];

    
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:YES];
    

//    [UIView animateWithDuration:0.35 animations:^{
//        
//        self.view.transform = CGAffineTransformMakeRotation(M_PI_2);
//    } completion:^(BOOL finished) {
//    }];
    
    
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    if(_urlStr){
        [_playerView playVideoWithUrl:[NSURL URLWithString:_urlStr]];
    }
}

- (void)viewDidDisappear:(BOOL)animated {

    [super viewDidDisappear:animated];
    [_playerView pause];
}


- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskLandscapeRight;
}


- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}


@end
