//
//  IPInforBean.m
//  AreaParty
//
//  Created by 杜哲凯 on 2017/12/18.
//  Copyright © 2017年 杜哲凯. All rights reserved.
//

#import "IPInforBean.h"

@implementation IPInforBean
- (instancetype)initWithHost:(NSString*)ip andPort:(int)port andFunc:(NSString*) func andLaunch_time_id:(NSString*)launch_time_id
{
    self = [super init];
    if (self) {
        self.ip = ip;
        self.port = port;
        self.function = func;
        self.launch_time_id = launch_time_id;
    }
    return self;
}
@end
