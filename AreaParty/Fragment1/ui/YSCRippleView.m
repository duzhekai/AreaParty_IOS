//
//  YSCRippleView.m
//  AnimationLearn
//
//  Created by yushichao on 16/2/17.
//  Copyright © 2016年 yushichao. All rights reserved.
//

#import "YSCRippleView.h"

@interface YSCRippleView ()

@property (nonatomic, strong) UIButton *rippleButton;
@property (nonatomic, strong) NSTimer *rippleTimer;
@property (nonatomic, assign) NSInteger mode;
@property (nonatomic, assign) YSCRippleType type;

@end

@implementation YSCRippleView
- (void)drawRect:(CGRect)rect {
    [self showWithRippleType:YSCRippleTypeCircle];
}

- (void)removeFromParentView
{
    if (self.superview) {
        [_rippleButton removeFromSuperview];
        [self closeRippleTimer];
        [self removeAllSubLayers];
        [self removeFromSuperview];
        [self.layer removeAllAnimations];
    }
}

- (void)removeAllSubLayers
{
    for (NSInteger i = 0; [self.layer sublayers].count > 0; i++) {
        [[[self.layer sublayers] firstObject] removeFromSuperlayer];
    }
}

- (void)showWithRippleType:(YSCRippleType)type
{
    _type = type;
    [self setbgpic];
    [self setUpRippleButton];
    [self settopbar];
    self.rippleTimer = [NSTimer timerWithTimeInterval:0.75 target:self selector:@selector(addRippleLayer) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_rippleTimer forMode:NSRunLoopCommonModes];
}
-(void)setbgpic{
    UIImageView* imgview = [[UIImageView alloc] initWithFrame:self.frame];
    imgview.contentMode = UIViewContentModeScaleToFill;
    [imgview setImage:[UIImage imageNamed:@"wifiexist.png"]];
    [self addSubview:imgview];
}
-(void)settopbar{
    UIView* topbar = [[UIView alloc] initWithFrame:CGRectMake(0,35,self.frame.size.width,40)];
    topbar.backgroundColor = [UIColor clearColor];
    UIButton* returnbtn = [[UIButton alloc] initWithFrame:CGRectMake(15,5,30,30)];
    [returnbtn setImage:[UIImage imageNamed:@"returnlogo.png"] forState:UIControlStateNormal];
    [returnbtn addTarget:self action:@selector(rtntomain) forControlEvents:UIControlEventTouchUpInside];
    [topbar addSubview:returnbtn];
    [topbar addSubview:self.lb_wifiname];
    [self addSubview:topbar];
}
-(void) rtntomain{
    for (UIView* nextVC = [self superview]; nextVC; nextVC = nextVC.superview) {
        UIResponder* nextResponder = [nextVC nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            UIViewController* fatherctl = (UIViewController*)nextResponder;
            NSLog(@"%@",NSStringFromClass([fatherctl class]));
            [fatherctl dismissViewControllerAnimated:YES completion:nil];
        }
    }
}
- (UILabel *)lb_wifiname{
    if(!_lb_wifiname){
        _lb_wifiname = [[UILabel alloc] initWithFrame:CGRectMake(50,5,self.frame.size.width-50, 30)];
        _lb_wifiname.backgroundColor = [UIColor clearColor];
        _lb_wifiname.textColor = [UIColor whiteColor];
    }
    return _lb_wifiname;
}
- (void)setUpRippleButton
{
    _rippleButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    _rippleButton.center = self.center;
    _rippleButton.layer.backgroundColor =[UIColor colorWithRed:230/255.f green:87/255.f blue:87/255.f alpha:1.0].CGColor;
    [_rippleButton setImage:[UIImage imageNamed:@"find_wifi_normal.png"] forState:UIControlStateNormal];
    _rippleButton.layer.cornerRadius = 50;
    _rippleButton.layer.masksToBounds = YES;
    [_rippleButton setEnabled:NO];
    [_rippleButton addTarget:self action:@selector(rippleButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_rippleButton];
}

- (void)rippleButtonTouched:(id)sender
{
    [self closeRippleTimer];
    [self addRippleLayer];
}

- (CGRect)makeEndRect
{
    CGRect endRect = CGRectMake(_rippleButton.frame.origin.x, _rippleButton.frame.origin.y, 100,100);
    endRect = CGRectInset(endRect, -10, -10);
    return endRect;
}

- (void)addRippleLayer
{
    CAShapeLayer *rippleLayer = [[CAShapeLayer alloc] init];
    rippleLayer.position = CGPointMake(200, 200);
    rippleLayer.bounds = CGRectMake(0, 0, 400, 400);
    rippleLayer.backgroundColor = [UIColor clearColor].CGColor;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(_rippleButton.frame.origin.x, _rippleButton.frame.origin.y, 100, 100)];
    rippleLayer.path = path.CGPath;
    rippleLayer.strokeColor = [UIColor whiteColor].CGColor;
    if (YSCRippleTypeRing == _type) {
        rippleLayer.lineWidth = 5;
    } else {
        rippleLayer.lineWidth = 1.5;
    }
    
    if (YSCRippleTypeLine == _type || YSCRippleTypeRing == _type) {
        rippleLayer.fillColor = [UIColor clearColor].CGColor;
    } else if (YSCRippleTypeCircle == _type) {
        rippleLayer.fillColor = [UIColor whiteColor].CGColor;
    } else if (YSCRippleTypeMixed == _type) {
        rippleLayer.fillColor = [UIColor grayColor].CGColor;
    }
    
    [self.layer insertSublayer:rippleLayer below:_rippleButton.layer];
    
    //addRippleAnimation-
    UIBezierPath *beginPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(_rippleButton.frame.origin.x, _rippleButton.frame.origin.y, 100, 100)];
    CGRect endRect = CGRectInset([self makeEndRect], -90, -90);
    UIBezierPath *endPath = [UIBezierPath bezierPathWithOvalInRect:endRect];
    
    rippleLayer.path = endPath.CGPath;
    rippleLayer.opacity = 0.0;
    
    CABasicAnimation *rippleAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    rippleAnimation.fromValue = (__bridge id _Nullable)(beginPath.CGPath);
    rippleAnimation.toValue = (__bridge id _Nullable)(endPath.CGPath);
    rippleAnimation.duration = 2.5;
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    opacityAnimation.toValue = [NSNumber numberWithFloat:0.0];
    opacityAnimation.duration = 2.5;
    
    [rippleLayer addAnimation:opacityAnimation forKey:@""];
    [rippleLayer addAnimation:rippleAnimation forKey:@""];
    
    [self performSelector:@selector(removeRippleLayer:) withObject:rippleLayer afterDelay:2.5];
}

- (void)removeRippleLayer:(CAShapeLayer *)rippleLayer
{
    [rippleLayer removeFromSuperlayer];
    rippleLayer = nil;
}

- (void)closeRippleTimer
{
    if (_rippleTimer) {
        if ([_rippleTimer isValid]) {
            [_rippleTimer invalidate];
        }
        _rippleTimer = nil;
    }
}

@end
