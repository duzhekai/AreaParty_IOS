//
//  ReceiveDataFormat.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/6/25.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "ReceiveDataFormat.h"

@implementation ReceiveDataFormat
// 返回容器类中的所需要存放的数据类型 (以 Class 或 Class Name 的形式)。
+ (NSDictionary*)modelContainerPropertyGenericClass {
    return @{@"pause_files" : [ReceiveData class],
             @"downloading_files":[ReceiveData class]
             };
}
@end
