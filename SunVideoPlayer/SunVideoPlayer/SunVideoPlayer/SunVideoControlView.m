//
//  SunVideoControlView.m
//  SunVideoPlayer
//
//  Created by 孙兴祥 on 2017/4/25.
//  Copyright © 2017年 sunxiangxiang. All rights reserved.
//

#import "SunVideoControlView.h"
#import "SunSliderView.h"
#import "SunVideoViewController.h"
#import "SunVideoPlayerView.h"

@interface SunVideoControlView ()<SunSliderViewProtocol>{
    
}

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIView *bottomView;
@property (nonatomic,strong) UILabel *currentLabel;
@property (nonatomic,strong) UILabel *durationLabel;
@property (nonatomic,strong) SunSliderView *sliderView;
@property (nonatomic,strong) UIButton *fullScreenBtn;
@property (nonatomic,strong) UIButton *playPauseBtn;
@property (nonatomic,strong) UIButton *speedBtn;

@property (nonatomic,strong) NSTimer *timer;

@end
@implementation SunVideoControlView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        [self addSubview:self.titleLabel];
        [self addSubview:self.playPauseBtn];
        [self addSubview:self.bottomView];
        [self.bottomView addSubview:self.currentLabel];
        [self.bottomView addSubview:self.durationLabel];
        [self.bottomView addSubview:self.sliderView];
//        [self.bottomView addSubview:self.fullScreenBtn];
        [self.bottomView addSubview:self.speedBtn];
        [self addConstraints];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddelSelf)];
        [self addGestureRecognizer:tap];
        
        
    }
    return self;
}

- (void)hiddelSelf {
    
    [self showHiddenView];
    
    if(self.playPauseBtn.hidden == NO){
        _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(showHiddenView) userInfo:nil repeats:NO];
    }else{
        if(_timer){
            [_timer invalidate];
            _timer = nil;
        }
    }
}

- (void)showHiddenView {
    
    self.titleLabel.hidden = !self.titleLabel.hidden;
    self.playPauseBtn.hidden = !self.playPauseBtn.hidden;
    self.bottomView.hidden = !self.bottomView.hidden;
}

- (void)addConstraints {
    
    __weak typeof(self) weakself = self;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(weakself.mas_top).offset(20);
        make.left.equalTo(weakself.mas_left);
        make.right.equalTo(weakself.mas_right);
        make.height.mas_equalTo(17);
    }];
    [self.playPauseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.equalTo(weakself);
        make.centerY.equalTo(weakself);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(weakself.mas_left);
        make.right.equalTo(weakself.mas_right);
        make.bottom.equalTo(weakself.mas_bottom);
        make.height.equalTo(@30);
    }];
    [self.currentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(weakself.bottomView);
        make.top.equalTo(weakself.bottomView);
        make.height.equalTo(weakself.bottomView);
        make.width.equalTo(@40);
    }];
    [self.durationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(weakself.speedBtn.mas_left);
        make.top.equalTo(weakself.bottomView);
        make.height.equalTo(weakself.bottomView);
        make.width.equalTo(@40);
    }];
    [self.sliderView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(weakself.currentLabel.mas_right);
        make.top.equalTo(weakself.bottomView);
        make.height.equalTo(weakself.bottomView);
        make.right.equalTo(weakself.durationLabel.mas_left);
    }];
//    [self.fullScreenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.top.equalTo(weakself.bottomView);
//        make.right.equalTo(weakself.bottomView);
//        make.size.mas_equalTo(CGSizeMake(30, 30));
//    }];
    [self.speedBtn mas_makeConstraints:^(MASConstraintMaker *make) {

        make.top.equalTo(weakself.bottomView);
        make.right.equalTo(weakself.bottomView);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
}

#pragma mark - 开始暂停
- (void)playPause:(UIButton *)btn {

    btn.selected = !btn.selected;

    if(_delegate && [_delegate respondsToSelector:@selector(playOrPause:)]){
        
        [_delegate playOrPause:!btn.selected];
    }
}

#pragma mark - 进入全屏
- (void)enterFullScreen:(UIButton *)btn {

    btn.selected = !btn.selected;
    if(btn.selected == YES){
    
        UIViewController *currentVC = [self viewController];
        
        SunVideoViewController *vc = [[SunVideoViewController alloc] init];
        
        [currentVC.navigationController pushViewController:vc animated:YES];
    }else{
    
        [[self viewController].navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - 调整播放速率
- (void)changeRage:(UIButton *)btn {
 
    btn.selected = !btn.selected;
    if(_delegate && [_delegate respondsToSelector:@selector(changePlayRate:)]){
        
        if(btn.selected == YES){
            [_delegate changePlayRate:1.5];
        }else{
            [_delegate changePlayRate:1.0];
        }
    }
}

- (UIViewController *)viewController {

    for(UIView *next = [self superview]; next; next = [next superview]){
        UIResponder *responder = [next nextResponder];
        if([responder isKindOfClass:[UIViewController class]]){
            return (UIViewController *)responder;
        }
    }
    return nil;
}

#pragma mark - SunSliderViewProtocol
//开始拖动
- (void)startMoveWithPercent:(float)percent {

    _isDrag = YES;
}
//正在拖动
- (void)moveWithPercent:(float)percent {

    _currentLabel.text = [self getTimeStringWithSeconds:(int)_duration*percent];
}
//结束拖动
- (void)stopMoveWithPercent:(float)percent {
    
    if(_delegate && [_delegate respondsToSelector:@selector(playToSecondTime:)]){
        
        [_delegate playToSecondTime:(int)(_duration*percent)];
    }
}

#pragma mark - 得到时间格式
- (NSString *)getTimeStringWithSeconds:(int)time {
    
    int hour = time/(60*60);
    int minutes = time%(60*60)/60;
    int seconds = time%(60*60)%60;
    if(hour == 0){
        return [NSString stringWithFormat:@"%d%d:%d%d",minutes/10,minutes%10,seconds/10,seconds%10];
    }else{
        return [NSString stringWithFormat:@"%d:%d%d:%d%d",hour,minutes/10,minutes%10,seconds/10,seconds%10];
    }
}

#pragma mark - setter
- (void)setTitle:(NSString *)title {
    
    _title = title;
//    _titleLabel.text = _title;
}

- (void)setDuration:(double)duration {
    
    _duration = duration;
    self.durationLabel.text = [self getTimeStringWithSeconds:(int)_duration];
}

- (void)setCurrentTime:(double)currentTime {

    _currentTime = currentTime;
    if(_isDrag == NO){
        self.currentLabel.text = [self getTimeStringWithSeconds:(int)_currentTime];
        self.sliderView.playPercent = _currentTime/_duration;
    }
}

#pragma mark - getter
- (UILabel *)titleLabel {
    
    if(_titleLabel == nil){
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.hidden = YES;
    }
    return _titleLabel;
}

- (UIView *)bottomView {
    
    if(_bottomView == nil){
        _bottomView = [[UIView alloc] initWithFrame:CGRectZero];
        _bottomView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        _bottomView.hidden = YES;
    }
    return _bottomView;
}

- (UILabel *)currentLabel {
    
    if(_currentLabel == nil){
        _currentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _currentLabel.textAlignment = NSTextAlignmentCenter;
        _currentLabel.textColor = [UIColor whiteColor];
        _currentLabel.font = [UIFont systemFontOfSize:10];
        _currentLabel.text = @"00:00";
    }
    return _currentLabel;
}

- (UILabel *)durationLabel {
    
    if(_durationLabel == nil){
        _durationLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _durationLabel.textAlignment = NSTextAlignmentCenter;
        _durationLabel.textColor = [UIColor whiteColor];
        _durationLabel.font = [UIFont systemFontOfSize:10];
        _durationLabel.text = @"00:00";
    }
    return _durationLabel;
}

- (SunSliderView *)sliderView {
    
    if(_sliderView == nil){
        _sliderView = [[SunSliderView alloc] initWithFrame:CGRectZero];
        _sliderView.delegate = self;
    }
    return _sliderView;
}

- (UIButton *)fullScreenBtn {
    
    if(_fullScreenBtn == nil){
        _fullScreenBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        
        [_fullScreenBtn setImage:[UIImage imageNamed:@"fullScreen"] forState:(UIControlStateNormal)];
        [_fullScreenBtn setImage:[UIImage imageNamed:@"smallScreen"] forState:(UIControlStateSelected)];
        [_fullScreenBtn addTarget:self action:@selector(enterFullScreen:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fullScreenBtn;
}

- (UIButton *)playPauseBtn {
    
    if(_playPauseBtn == nil){
        _playPauseBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_playPauseBtn setImage:[UIImage imageNamed:@"play"] forState:(UIControlStateSelected)];
        [_playPauseBtn setImage:[UIImage imageNamed:@"pause"] forState:(UIControlStateNormal)];
        [_playPauseBtn addTarget:self action:@selector(playPause:) forControlEvents:(UIControlEventTouchUpInside)];
        _playPauseBtn.hidden = YES;
    }
    return _playPauseBtn;
}

- (UIButton *)speedBtn {
    
    if(_speedBtn == nil){
        _speedBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_speedBtn setTitle:@"1.0" forState:(UIControlStateNormal)];
        [_speedBtn setTitle:@"1.5" forState:UIControlStateSelected];
        [_speedBtn setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
        [_speedBtn setTitleColor:[UIColor redColor] forState:(UIControlStateSelected)];
        _speedBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_speedBtn addTarget:self action:@selector(changeRage:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _speedBtn;
}



@end
