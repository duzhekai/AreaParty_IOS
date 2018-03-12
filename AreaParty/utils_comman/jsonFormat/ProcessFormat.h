//
//  ProcessFormat.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/3/8.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//
/**
 * Created by boris on 2016/12/16.
 * 主机进程相关信息
 * id: 进程id
 * name: 进程名
 * cpu: 进程使用的CPU百分比
 * memory: 进程使用的内存(KB)
 * path: 进程主模块完整路径
 */
#import <Foundation/Foundation.h>

@interface ProcessFormat : NSObject
@property(assign,nonatomic) int p_id;
@property(assign,nonatomic) int cpu;
@property(assign,nonatomic) long memory;
@property(strong,nonatomic) NSString* path;
@property(strong,nonatomic) NSString* name;
@end
