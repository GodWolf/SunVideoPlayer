//
//  SunVideoPlayerView.m
//  SunVideoPlayer
//
//  Created by 孙兴祥 on 2017/4/25.
//  Copyright © 2017年 sunxiangxiang. All rights reserved.
//

#import "SunVideoPlayerView.h"
#import "SunVideoControlView.h"
#import <AVFoundation/AVFoundation.h>

static NSString *PlayStatus = @"play status";

@interface SunVideoPlayerView ()<SunVideoControlProtocol>

@property (nonatomic,strong) AVAsset *asset;
@property (nonatomic,strong) AVPlayerItem *item;
@property (nonatomic,strong) AVPlayer *player;

@property (nonatomic,strong) SunVideoControlView *controlView;

@property (nonatomic,strong) id timeObserve;
@property (nonatomic,strong) id playEndObserve;

@property (nonatomic,assign) float playRate;


@end
@implementation SunVideoPlayerView

+ (Class)layerClass {
    
    return [AVPlayerLayer class];
}

+ (instancetype)sharePlayerView {
    
    static SunVideoPlayerView *shareInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[SunVideoPlayerView alloc] initWithFrame:CGRectZero];
    });
    return shareInstance;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        [self addSubview:self.controlView];
        __weak typeof(self) weakself = self;
        [self.controlView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.equalTo(weakself).insets(UIEdgeInsetsZero);
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showControlView)];
        [self addGestureRecognizer:tap];
    }
    return self;
}


- (void)playVideoWithUrl:(NSURL *)url {
    
    
    if(_player && _timeObserve){
        [_player removeTimeObserver:_timeObserve];
        _timeObserve = nil;
    }
    
    _asset = [AVAsset assetWithURL:url];
    _item = [AVPlayerItem playerItemWithAsset:_asset automaticallyLoadedAssetKeys:@[@"duration",@"commonMetadata",@"tracks"]];
    _player = [[AVPlayer alloc] initWithPlayerItem:_item];
    [(AVPlayerLayer *)self.layer setPlayer:_player];
    
    //添加status通知
    [_item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:&PlayStatus];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if(context == &PlayStatus){
        
        if(_item.status == AVPlayerItemStatusReadyToPlay){
            
            [_item removeObserver:self forKeyPath:@"status"];
            //时长
            _controlView.duration = CMTimeGetSeconds(_item.duration);
            [_player play];
            
            _controlView.title = [self getVideoTitle];
            CGSize videoSize = [self getVideoSize];
            self.bounds = CGRectMake(0, 0, videoSize.width, videoSize.height);
            
            _controlView.delegate = self;
            [_controlView reset];
            __weak typeof(self) weakself = self;
            
            //监听播放时间
            _timeObserve = [_player addPeriodicTimeObserverForInterval:CMTimeMake(1, 2) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
                
                weakself.controlView.currentTime = CMTimeGetSeconds(time);
            }];
            
            //播放结束通知
            _playEndObserve = [[NSNotificationCenter defaultCenter] addObserverForName:AVPlayerItemDidPlayToEndTimeNotification object:_item queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
                //播放完毕回到开始位置
                weakself.controlView.currentTime = 0;
                [weakself.item seekToTime:kCMTimeZero toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
                    
                }];
            }];
        }else{
            //无法播放
        }
    }
}

- (void)play {
    
    if(_player){
       _player.rate = _playRate;
    }
}

- (void)pause {
    if(_player){
        
        _playRate = _player.rate;
        _player.rate = 0;
        
    }
}

#pragma mark - SunVideoControlProtocol
- (void)playToSecondTime:(int)seconds {
    
    [self.item cancelPendingSeeks];
    [self.item seekToTime:CMTimeMake(seconds, 1) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
        
        self.controlView.isDrag = NO;
    }];
}
- (void)playOrPause:(BOOL)isPlay {
    
    if(isPlay){
        [self play];
    }else{
        [self pause];
    }
}
- (void)changePlayRate:(float)rate {
    
    if(_player){
        
        _player.rate = rate;
        _playRate = rate;
    }
}


//获取标题
- (NSString *)getVideoTitle {
    
    AVKeyValueStatus status = [_asset statusOfValueForKey:@"commonMetadata" error:nil];
    if(status == AVKeyValueStatusLoaded){
        
        //获取标题项数据
        NSArray *item = [AVMetadataItem metadataItemsFromArray:_asset.commonMetadata withKey:AVMetadataCommonKeyTitle keySpace:AVMetadataKeySpaceCommon];
        if(item.count > 0){
            AVMetadataItem *titleItem = item[0];
            return titleItem.stringValue;
        }else{
            return @"视频标题";
        }
    }else{
        return @"视频标题";
    }
}

//获取视频高度
- (CGSize)getVideoSize {

    NSArray *vidoTrack = [_asset tracksWithMediaType:AVMediaTypeVideo];
    if(vidoTrack.count > 0){
        AVAssetTrack *track = [vidoTrack firstObject];
        CGSize size = track.naturalSize;
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        CGFloat screenHeigth = [UIScreen mainScreen].bounds.size.height;
        if(size.width > screenWidth){
            return CGSizeMake(screenWidth, size.height/size.width*screenWidth);
        }
        return track.naturalSize;
        
    }
    return CGSizeZero;
}

//显示控制器
- (void)showControlView {

    self.controlView.hidden = NO;
    
}

#pragma mark - getter
- (SunVideoControlView *)controlView {
    
    if(_controlView == nil){
        _controlView = [[SunVideoControlView alloc] initWithFrame:CGRectZero];
    }
    return _controlView;
}

@end
