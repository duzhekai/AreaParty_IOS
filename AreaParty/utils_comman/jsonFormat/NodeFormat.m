//
//  NodeFormat.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/1/25.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "NodeFormat.h"

@implementation NodeFormat
// 返回容器类中的所需要存放的数据类型 (以 Class 或 Class Name 的形式)。
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"files" : [FileInforFormat class],
             @"folders" : [FolderInforFormat class]};
}
@end
