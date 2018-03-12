//
//  NetUtil.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/1/1.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "NetUtil.h"
@implementation NetUtil
+(AFNetworkReachabilityStatus)getNetWorkStates{
AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    AFNetworkReachabilityStatus states = [manager networkReachabilityStatus];
    return states;
}
@end
