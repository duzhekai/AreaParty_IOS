//
//  AllStatisticsMsgBean.m
//  AreaParty
//
//  Created by 杜哲凯 on 2017/12/26.
//  Copyright © 2017年 杜哲凯. All rights reserved.
//

#import "AllStatisticsMsgBean.h"

@implementation AllStatisticsMsgBean
- (instancetype)initWithType:(NSString*)type andUserId:(NSString*)userid andid:(NSString*) id_ andMac:(NSString*)mac andTime:(long)time andpcMsg:(NSMutableArray<StatisticsMsgBean*>*)pcMsg andtvMsg:(NSMutableArray<StatisticsMsgBean*>*)tvMsg
{
    self = [super init];
    if (self) {
        self.type = type;
        self.userId = userid;
        self.id_ = id_;
        self.mac = mac;
        self.time = time;
        self.pcMsg = pcMsg;
        self.tvMsg = tvMsg;
    }
    return self;
}
@end
