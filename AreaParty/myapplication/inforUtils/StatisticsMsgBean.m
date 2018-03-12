//
//  StatisticsMsgBean.m
//  AreaParty
//
//  Created by 杜哲凯 on 2017/12/25.
//  Copyright © 2017年 杜哲凯. All rights reserved.
//

#import "StatisticsMsgBean.h"

@implementation StatisticsMsgBean
- (instancetype)initWithType:(NSString*)type andID:(NSString*) id_ andMac:(NSString*)mac andtime:(long)time{
    self = [super init];
    if (self) {
        self.type = type;
        self.id_ = id_;
        self.mac = mac;
        self.time = time;
    }
    return self;
}
@end
