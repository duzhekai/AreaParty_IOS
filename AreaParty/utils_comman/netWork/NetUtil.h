//
//  NetUtil.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/1/1.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
@interface NetUtil : NSObject
+ (AFNetworkReachabilityStatus)getNetWorkStates;
@end
