//
//  ReceivedExeListFormat.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/3/12.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "ReceivedExeListFormat.h"

@implementation ReceivedExeListFormat
// 返回容器类中的所需要存放的数据类型 (以 Class 或 Class Name 的形式)。
+ (NSDictionary*)modelContainerPropertyGenericClass {
    return @{@"data" : [ExeInformat class], };
}
@end
