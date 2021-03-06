//
//  PCAppHelper.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/1/13.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "PCAppHelper.h"
#import "prepareDataForFragment_monitor.h"
const int PCAppHelper_NONEMODE = 0;
const int PCAppHelper_RDPMODE = 1;
const int PCAppHelper_MIRACAST = 2;
static int currentMode = PCAppHelper_NONEMODE;
static NSMutableArray<AppItem*>* appList;
static NSMutableArray<AppItem*>* gameList;
static PCInforBean* pcInfor;
@implementation PCAppHelper
+ (void)setCurrentMode:(int)current{
    currentMode = current;
}
+ (int)getCurrentMode{
    return currentMode;
}
+ (NSMutableArray<AppItem*>*)getappList{
    if(appList==nil){
        appList = [[NSMutableArray alloc]init];
    }
    return appList;
}
+ (NSMutableArray<AppItem*>*)getgameList{
    if(gameList==nil){
        gameList = [[NSMutableArray alloc]init];
    }
    return gameList;
}
+ (PCInforBean*) getpcInfor{
    if(pcInfor ==nil){
        pcInfor = [[PCInforBean alloc]init];
    }
    return pcInfor;
}
+ (void )openApp_Rdp:(NSString*) path andappname:(NSString*) appname  andHandler:(id<onHandler>) myhandler {
    NSMutableDictionary* param = [[NSMutableDictionary alloc] init];
    [param setObject:path forKey:@"path"];
    [param setObject:appname forKey:@"appname"];
    [[[Send2PCThread alloc] initWithtypeName:OrderConst_appAction_name commandType:OrderConst_appAction_rdpOpen_command Map:param Handler:myhandler] start];
}
+ (void) setPcInfor:(PCInforBean*) infor{
    pcInfor = infor;
}
+ (void) setList:(NSString*) type list:(NSArray<AppItem*>*)list{
    if([type isEqualToString:OrderConst_gameAction_name]){
        [[self getgameList] removeAllObjects];
        [[self getgameList] addObjectsFromArray:list];
    }
    else if([type isEqualToString:OrderConst_appAction_name]){
        [[self getappList] removeAllObjects];
        [[self getappList] addObjectsFromArray:list];
    }
}
+ (void) loadList:(id<onHandler>) handler {
    [[self getappList] removeAllObjects];
    [[self getgameList] removeAllObjects];
    [[[Send2PCThread alloc] initWithtypeName:OrderConst_appAction_name commandType:OrderConst_appMediaAction_getList_command Handler:handler] start];
    [[[Send2PCThread alloc] initWithtypeName:OrderConst_gameAction_name commandType:OrderConst_appMediaAction_getList_command Handler:handler] start];
}
+ (void) shutdownPC{
    [NSThread detachNewThreadWithBlock:^(void){
        [prepareDataForFragment_monitor getActionStateData:OrderConst_computerAction_name Command:OrderConst_computerAction_shutdown_command Param:@""];
    }];
}
+ (void) rebootPC{
    [NSThread detachNewThreadWithBlock:^(void){
        [prepareDataForFragment_monitor getActionStateData:OrderConst_computerAction_name Command:OrderConst_computerAction_reboot_command Param:@""];
    }];
}
+ (void) loadPCInfor:(id<onHandler>) handler {
    [[[Send2PCThread alloc] initWithtypeName:OrderConst_sysAction_name commandType:OrderConst_sysAction_getInfor_command Handler:handler] start];
}
@end
