//
//  MonitorData.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/3/8.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "MonitorData.h"

@implementation MonitorData
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"processes" : [ProcessFormat class] };
}
@end
