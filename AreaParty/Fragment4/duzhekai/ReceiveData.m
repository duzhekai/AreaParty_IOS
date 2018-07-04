//
//  ReceiveData.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/6/25.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "ReceiveData.h"

@implementation ReceiveData

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"name" : @"name",
             @"path" : @"path",
             @"mid" : @"id"};
};

@end
