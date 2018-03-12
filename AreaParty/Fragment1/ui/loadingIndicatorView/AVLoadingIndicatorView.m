//
//  AVLoadingIndicatorView.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/1/24.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "AVLoadingIndicatorView.h"

@implementation AVLoadingIndicatorView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _backgroundview = [[UIView alloc] initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width*0.75,[UIScreen mainScreen].bounds.size.width*0.5)];
        _backgroundview.backgroundColor =[UIColor whiteColor];
        _backgroundview.center = self.center;
        _backgroundview.layer.cornerRadius = 10 ;
        _backgroundview.layer.shadowColor = [[UIColor blackColor] CGColor];
        _backgroundview.layer.shadowOffset = CGSizeMake(0,0);//偏移距离
        _backgroundview.layer.shadowRadius = 2;//半径
        _backgroundview.layer.shadowOpacity = 0.25;
        _loading_txt = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, 100, 30)];
        _loading_txt.center = self.center;
        _loading_txt.text = @"加载中...";
        _loading_txt.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_backgroundview];
        [self addSubview:_loading_txt];
    }
    return self;
}
-(void)showPromptViewOnView:(UIView *)view
{
    _isshown = YES;
    [view addSubview:self];
}
-(void) removeView{
    _isshown = NO;
    [self removeFromSuperview];
}
@end
