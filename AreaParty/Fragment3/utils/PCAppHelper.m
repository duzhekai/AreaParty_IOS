//
//  PCAppHelper.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/1/13.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "PCAppHelper.h"
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
@end
