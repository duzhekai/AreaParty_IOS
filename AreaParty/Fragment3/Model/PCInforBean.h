//
//  PCInforBean.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/1/13.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PCInforBean : NSObject
@property(strong,nonatomic) NSString* systemVersion;
@property(strong,nonatomic) NSString* systemType;
@property(strong,nonatomic) NSString* totalmemory;
@property(strong,nonatomic) NSString* cpuName;
@property(strong,nonatomic) NSString* totalStorage;
@property(strong,nonatomic) NSString* freeStorage;
@property(strong,nonatomic) NSString* pcName;
@property(strong,nonatomic) NSString* pcDes;
@property(strong,nonatomic) NSString* workGroup;
- (BOOL)isEmpty;
@end
