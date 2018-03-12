//
//  TVAppHelper.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/1/6.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "TVAppHelper.h"
static NSMutableArray<AppItem*>* installedAppList;
static NSMutableArray<AppItem*>* ownAppList;
static NSMutableArray<NSString*>* mouseDevices;
static TVInforBean* tvInfor;
@implementation TVAppHelper

+ (void) resetTotalInfors {
    [[self getinstalledAppList] removeAllObjects];
    [[self getownAppList] removeAllObjects];
    [[self getmouseDevices] removeAllObjects];
    tvInfor = [[TVInforBean alloc]init];
}
/**
 * <summary>
 *  告知TV，当前连接PC
 *  <param name="handler">消息传递句柄</param>
 * </summary>
 */
+ (void)currentPcInfo2TV{
    NSString* cmd = [[CommandUtil createCurrentPcInfoCommand] yy_modelToJSONString];
    NSLog(@"ervincm%@",[MyUIApplication getSelectedPCIP].name);
    [[[Send2TVThread alloc] initWithCmd:cmd] start];
}
+ (void) openApp:(NSString*) packgeName{
    NSString* cmd = [[CommandUtil createOpenTvAppCommand:packgeName] yy_modelToJSONString];
    [[[Send2TVThread alloc] initWithCmd:cmd] start];
}
+ (void)setAppList:(NSString*)type list:(NSArray<AppItem*>*)appList {
    if([type isEqualToString:OrderConst_getTVOtherApps_firCommand]){
        [[self getinstalledAppList]removeAllObjects];
        [[self getinstalledAppList]addObjectsFromArray:appList];
    }
    if([type isEqualToString:OrderConst_getTVSYSApps_firCommand]){
        [[self getownAppList]removeAllObjects];
        [[self getownAppList]addObjectsFromArray:appList];
    }
}
+ (void)loadApps:(id<onHandler>) handler{
    [[self getinstalledAppList] removeAllObjects];
    [[self getownAppList] removeAllObjects];
    [[[GetTvListThread alloc] initWithType:OrderConst_getTVOtherApps_firCommand andHandler:handler] start];
    [[[GetTvListThread alloc]initWithType:OrderConst_getTVSYSApps_firCommand andHandler:handler]start];
}
+ (void)loadMouses:(id<onHandler>) handler {
    [[self getmouseDevices] removeAllObjects];
    [[[GetTvListThread alloc] initWithType:OrderConst_getTVMouses_firCommand andHandler:handler]start];
}
+ (void)loadTVInfor:(id<onHandler>) handler {
    [[[GetTvListThread alloc] initWithType:OrderConst_getTVInfor_firCommand andHandler:handler]start];
}

+ (void) prepareForPCGame:(NSString*) pc_ip Mac: (NSString*) pc_mac{
    NSString* cmd = [[CommandUtil createPrepareForPCGameCommand:pc_ip andMac:pc_mac] yy_modelToJSONString];
    [[[Send2TVThread alloc]initWithCmd:cmd]start];
}
+ (void) closeGameStream:(NSString*) pc_ip Mac: (NSString*) pc_mac{
    NSString* cmd = [[CommandUtil createCloseStreamPCGameCommand:pc_ip andMac:pc_mac] yy_modelToJSONString];
    [[[Send2TVThread alloc]initWithCmd:cmd]start];
}
+ (void) closeApp:(NSString*) packgeName {
    NSString* cmd = [[CommandUtil createCloseTvAppCommand:packgeName] yy_modelToJSONString];
    [[[Send2TVThread alloc]initWithCmd:cmd]start];
}

+ (void) uninstallApp:(NSString*) packgeName {
    NSString* cmd = [[CommandUtil createUninstallTVAppCommand:packgeName] yy_modelToJSONString];
    [[[Send2TVThread alloc]initWithCmd:cmd]start];
}
+ (void) openSettingPage{
    NSString* cmd = [[CommandUtil createTVSettingPageCommand] yy_modelToJSONString];
    [[[Send2TVThread alloc]initWithCmd:cmd]start];
}

+ (void) shutDownTV{
    NSString* cmd = [[CommandUtil createShutdownTVCommand] yy_modelToJSONString];
    [[[Send2TVThread alloc]initWithCmd:cmd]start];
}

+ (void) rebootTV {
    NSString* cmd = [[CommandUtil createRebootTVCommand] yy_modelToJSONString];
    [[[Send2TVThread alloc]initWithCmd:cmd]start];
}


+ (void) openTVRDP {
    NSString* cmd = [[CommandUtil createOpenTvRdpCommand] yy_modelToJSONString];
    [[[Send2TVThread alloc]initWithCmd:cmd]start];
}
+ (void)openTVAccessibility{
    NSString* cmd = [[CommandUtil createOpenTvAccessibilityCommand] yy_modelToJSONString];
    [[[Send2TVThread alloc]initWithCmd:cmd]start];
}
+ (void)openTVMiracast {
    NSString* cmd = [[CommandUtil createOpenTvMiracastCommand] yy_modelToJSONString];
    [[[Send2TVThread alloc]initWithCmd:cmd]start];
}

+(NSMutableArray<AppItem*>*)getinstalledAppList{
    if(installedAppList ==nil){
        installedAppList = [[NSMutableArray alloc] init];
    }
    return installedAppList;
}
+(NSMutableArray<AppItem*>*)getownAppList{
    if(ownAppList ==nil){
        ownAppList = [[NSMutableArray alloc] init];
    }
    return ownAppList;
}
+ (void) setTvInfor:(TVInforBean*) infor{
    tvInfor = infor;
}

+ (TVInforBean*) gettvInfor{
    if(tvInfor == nil){
        tvInfor = [[TVInforBean alloc] init];
    }
    return tvInfor;
}
+ (void) setMouseDevices:(NSArray<NSString*>*) list{
    [[self getmouseDevices] removeAllObjects];
     [[self getmouseDevices] addObjectsFromArray:list];
}
+(NSMutableArray<NSString*>*)getmouseDevices{
    if(mouseDevices ==nil){
        mouseDevices = [[NSMutableArray alloc] init];
    }
    return mouseDevices;
}
@end
