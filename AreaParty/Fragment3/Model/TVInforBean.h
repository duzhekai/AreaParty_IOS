//
//  TVInforBean.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/1/14.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TVInforBean : NSObject
@property(strong,nonatomic) NSString* brand;  // 品牌
@property(strong,nonatomic) NSString* model;  // 型号
@property(strong,nonatomic) NSString* totalStorage;   // 总容量
@property(strong,nonatomic) NSString* freeStorage;   // 可用容量
@property(strong,nonatomic) NSString* totalMemory;   // 总内存
@property(strong,nonatomic) NSString* resolution;   // 分辨率
@property(strong,nonatomic) NSString* androidVersion; // anroid版本
@property(strong,nonatomic) NSString* isRoot;         // 是否root（“是, 否”）
-(BOOL) isEmpty;
@end
