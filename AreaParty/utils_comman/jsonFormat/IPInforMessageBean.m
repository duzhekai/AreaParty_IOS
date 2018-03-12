//
//  IPInforMessageBean.m
//  AreaParty
//
//  Created by 杜哲凯 on 2017/12/18.
//  Copyright © 2017年 杜哲凯. All rights reserved.
//

#import "IPInforMessageBean.h"

@implementation IPInforMessageBean
-(NSString *)tojsonstring{
    NSMutableDictionary *temp= [NSMutableDictionary dictionary];
    [temp setObject:self.source forKey:@"source"];
    [temp setObject:self.type forKey:@"type"];
    [temp setObject:self.param forKey:@"param"];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:temp options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}
// 返回容器类中的所需要存放的数据类型 (以 Class 或 Class Name 的形式)。
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"param" : [IPInforBean class]};
}
@end
