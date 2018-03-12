//
//  nowifiView.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/1/1.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "nowifiView.h"

@implementation nowifiView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
 UIImageView* imgview = [[UIImageView alloc] initWithFrame:self.frame];
 imgview.contentMode = UIViewContentModeScaleToFill;
 [imgview setImage:[UIImage imageNamed:@"nowifi.png"]];
 [self addSubview:imgview];
 UIButton* rippleButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
 rippleButton.center = self.center;
 rippleButton.layer.backgroundColor =[UIColor clearColor].CGColor;
 [rippleButton setImage:[UIImage imageNamed:@"find_wifi_normal.png"] forState:UIControlStateNormal];
 rippleButton.layer.cornerRadius = 50;
 rippleButton.layer.masksToBounds = YES;
 [rippleButton setEnabled:NO];
[self addSubview:rippleButton];
    UIView* topbar = [[UIView alloc] initWithFrame:CGRectMake(0,35,self.frame.size.width,40)];
    topbar.backgroundColor = [UIColor clearColor];
    UIButton* returnbtn = [[UIButton alloc] initWithFrame:CGRectMake(15,5,30,30)];
    [returnbtn setImage:[UIImage imageNamed:@"returnlogo.png"] forState:UIControlStateNormal];
    [returnbtn addTarget:self action:@selector(rtntomain) forControlEvents:UIControlEventTouchUpInside];
    [topbar addSubview:returnbtn];
    UILabel* lb_wifiname = [[UILabel alloc] initWithFrame:CGRectMake(50,5,self.frame.size.width-50, 30)];
    lb_wifiname.backgroundColor = [UIColor clearColor];
    lb_wifiname.text=@"网络不可用";
    lb_wifiname.textColor = [UIColor whiteColor];
    [topbar addSubview:lb_wifiname];
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

@end
