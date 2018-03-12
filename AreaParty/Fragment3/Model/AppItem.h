//
//  AppItem.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/1/7.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppItem : NSObject
@property(strong,nonatomic) NSString* appName;
@property(strong,nonatomic) NSString* packageName;
@property(strong,nonatomic) NSString* iconURL;
@property(assign,nonatomic) BOOL isRunning;
@end
