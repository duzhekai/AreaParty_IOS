//
//  PCAppHelper.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/1/13.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PCInforBean.h"
#import "AppItem.h"
#import "onHandler.h"
#import "OrderConst.h"
#import "Send2PCThread.h"
extern const int PCAppHelper_NONEMODE;
extern const int PCAppHelper_RDPMODE;
extern const int PCAppHelper_MIRACAST;
@interface PCAppHelper : NSObject
+ (NSMutableArray<AppItem*>*)getappList;
+ (NSMutableArray<AppItem*>*)getgameList;
+ (PCInforBean*) getpcInfor;
+ (void)setCurrentMode:(int)current;
+ (void) setPcInfor:(PCInforBean*) infor;
+ (void) setList:(NSString*) type list:(NSArray<AppItem*>*)list;
+ (void )openApp_Rdp:(NSString*) path andappname:(NSString*) appname  andHandler:(id<onHandler>) myhandler;
@end
