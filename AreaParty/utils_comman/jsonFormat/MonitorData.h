//
//  MonitorData.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/3/8.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProcessFormat.h"
@interface MonitorData : NSObject
@property(assign,nonatomic) int cpu;
@property(assign,nonatomic)  double memory_used;
@property(assign,nonatomic)  double memory_total;
@property(assign,nonatomic)  double memory_available;
@property(assign,nonatomic)  double net_up;
@property(assign,nonatomic)  double net_down;
@property(strong,nonatomic)  NSMutableArray<ProcessFormat*>* processes;
@end
