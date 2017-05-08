//
//  SunSliderView.m
//  TestLayout
//
//  Created by 孙兴祥 on 2017/3/21.
//  Copyright © 2017年 sunxiangxiang. All rights reserved.
//

#import "SunSliderView.h"

@interface SunSliderView (){
    
    float _length;
    float _lineWidth;
    float _halfHeight;
    float _btnWidth;
    CGPoint _startMovePoint;
}

@property (nonatomic,strong) UIView *btnView;

@end

@implementation SunSliderView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if(self = [super initWithFrame:frame]){
        
        _bufferPercent = 0.0;
        _playPercent = 0.0;
        _btnWidth = 20;
        _length = frame.size.width-_btnWidth;
        _lineWidth = 3;
        _halfHeight = frame.size.height/2.0;
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
        [self addSubview:self.btnView];
        
        [self.btnView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.size.mas_equalTo(CGSizeMake(_btnWidth, _btnWidth));
        }];
    }
    return self;
}


- (void)layoutSubviews {
    
    _length = self.frame.size.width-_btnWidth;
    _halfHeight = self.frame.size.height/2.0;
    
}

#pragma mark - 拖动
- (void)changePercent:(UIPanGestureRecognizer *)panGesture {
    
    
    if(panGesture.state == UIGestureRecognizerStateBegan){
        
        _startMovePoint = _btnView.center;
        _btnView.transform = CGAffineTransformIdentity;
        
        if(_delegate && [_delegate respondsToSelector:@selector(startMoveWithPercent:)]){
            [_delegate startMoveWithPercent:self.playPercent];
        }
    }else if (panGesture.state == UIGestureRecognizerStateChanged){
        
        CGPoint currentPoint = [panGesture locationInView:self];
        if(currentPoint.x >= (_btnWidth/2.0-5)
           && currentPoint.x <= (_btnWidth/2.0+_length+5)){
            
            float moveLength = currentPoint.x-_btnWidth/2.0;
            self.playPercent = moveLength/_length;
        }
        if(_delegate && [_delegate respondsToSelector:@selector(moveWithPercent:)]) {
            [_delegate moveWithPercent:self.playPercent];
        }
    }else if (panGesture.state == UIGestureRecognizerStateEnded){
        
        _btnView.transform = CGAffineTransformMakeScale(0.8, 0.8);
        if(_delegate && [_delegate respondsToSelector:@selector(stopMoveWithPercent:)]) {
            [_delegate stopMoveWithPercent:self.playPercent];
        }
    }
}

- (void)setPlayPercent:(float)playPercent {
    
    if(playPercent < 0.0){
        _playPercent = 0.0;
    }else if (playPercent > 1.0){
        _playPercent = 1.0;
    }else{
        _playPercent = playPercent;
    }
    
    [self setNeedsDisplay];
    _btnView.center = CGPointMake(_btnWidth/2.0+_length*_playPercent, _halfHeight);
    
}

- (void)setBufferPercent:(float)bufferPercent {
    
    if(bufferPercent < 0.0){
        _bufferPercent = 0.0;
    }else if (bufferPercent > 1.0){
        _bufferPercent = 1.0;
    }else{
        _bufferPercent = bufferPercent;
    }

    [self setNeedsDisplay];
    
}

- (void)drawRect:(CGRect)rect {
    
    
    CGContextRef ref = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(ref, _lineWidth);
    
    CGContextSetStrokeColorWithColor(ref, [UIColor whiteColor].CGColor);
    CGContextMoveToPoint(ref, _btnWidth/2.0, _halfHeight);
    CGContextAddLineToPoint(ref, _btnWidth/2.0+_length, _halfHeight);
    CGContextStrokePath(ref);
    
    CGContextSetStrokeColorWithColor(ref, [UIColor grayColor].CGColor);
    CGContextMoveToPoint(ref, _btnWidth/2.0, _halfHeight);
    CGContextAddLineToPoint(ref, _btnWidth/2.0+_length*_bufferPercent, _halfHeight);
    CGContextStrokePath(ref);
    
    CGContextSetStrokeColorWithColor(ref, [UIColor redColor].CGColor);
    CGContextMoveToPoint(ref, _btnWidth/2.0, _halfHeight);
    CGContextAddLineToPoint(ref, _btnWidth/2.0+_length*_playPercent, _halfHeight);
    CGContextStrokePath(ref);
}

#pragma mark - getter
- (UIView *)btnView {
    
    if(_btnView == nil){
        _btnView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _btnWidth, _btnWidth)];
        _btnView.backgroundColor = [UIColor whiteColor];
        _btnView.layer.cornerRadius = _btnWidth/2.0;
        _btnView.clipsToBounds = YES;
        _btnView.layer.anchorPoint = CGPointMake(0.5, 0.5);
        _btnView.transform = CGAffineTransformMakeScale(0.8, 0.8);
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(changePercent:)];
        [_btnView addGestureRecognizer:pan];
    }
    return _btnView;
}

@end
