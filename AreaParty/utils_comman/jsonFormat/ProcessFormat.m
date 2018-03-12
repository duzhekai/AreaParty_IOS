//
//  ProcessFormat.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/3/8.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "ProcessFormat.h"

@implementation ProcessFormat
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"p_id" : @"id",
             @"cpu" : @"cpu",
             @"memory" : @"memory",
             @"path" : @"path",
             @"name" : @"name"
             };
}

@end
