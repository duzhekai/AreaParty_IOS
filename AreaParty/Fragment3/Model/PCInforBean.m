//
//  PCInforBean.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/1/13.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "PCInforBean.h"

@implementation PCInforBean
- (instancetype)init{
    self = [super init];
    self.systemVersion =@"";
    self.systemType=@"";
    self.totalmemory=@"";
    self.cpuName=@"";
    self.totalStorage=@"";
    self.freeStorage=@"";
    self.pcName=@"";
    self.pcDes=@"";
    self.workGroup=@"";
    return self;
}
- (BOOL)isEmpty{
    return ([_systemVersion isEqualToString:@""] &&
            [_systemType isEqualToString:@""] &&
            [_totalStorage isEqualToString:@""] &&
            [_freeStorage isEqualToString:@""] &&
            [_totalmemory isEqualToString:@""] &&
            [_cpuName isEqualToString:@""]);
}
@end
