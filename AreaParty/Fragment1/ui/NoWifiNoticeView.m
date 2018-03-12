//
//  NoWifiNoticeView.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/1/1.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "NoWifiNoticeView.h"

@implementation NoWifiNoticeView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    UIImageView* nowifiimage = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,100,100)];
    [nowifiimage setImage:[UIImage imageNamed:@"no_wifi_hint.png"]];
    nowifiimage.center = CGPointMake(self.frame.size.width/2, 70);
    [self addSubview:nowifiimage];
    UILabel* nowifinotice = [[UILabel alloc] initWithFrame:CGRectMake(0,130,self.frame.size.width,50)];
    nowifinotice.text = @"需和PC设备处于同一WiFi才能检测PC";
    nowifinotice.textAlignment =NSTextAlignmentCenter;
    [self addSubview:nowifinotice];
}


@end
