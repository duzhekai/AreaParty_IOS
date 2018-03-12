//
//  IPInforBean.h
//  AreaParty
//
//  Created by 杜哲凯 on 2017/12/18.
//  Copyright © 2017年 杜哲凯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IPInforBean : NSObject
@property(strong,nonatomic) NSString* ip;
@property(assign,nonatomic) int port;
@property(strong,nonatomic) NSString* function;
@property(strong,nonatomic) NSString* launch_time_id;
@property(strong,nonatomic) NSString* mac;
@property(strong,nonatomic) NSString* name;      // 设备名称
@property(strong,nonatomic) NSString* nickName;  // 虚拟名称

// 以下三个字段只有逆序列化TV传过来的IP信息的时候才启用
@property(strong,nonatomic) NSString* dlnaOk;     // "true"或者"false"
@property(strong,nonatomic) NSString* miracastOk; // "true"或者"false"
@property(strong,nonatomic) NSString* rdpOk;      // "true"或者"false"
- (instancetype)initWithHost:(NSString*)ip andPort:(int)port andFunc:(NSString*) func andLaunch_time_id:(NSString*)launch_time_id;
@end
