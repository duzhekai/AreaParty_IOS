//
//  CommandUtil.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/1/2.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PCCommandItem.h"
#import "TVCommandItem.h"
#import "OrderConst.h"
#import "MyUIApplication.h"
@interface CommandUtil : NSObject
+ (PCCommandItem*) createVerifyPCCommand:(NSString*)code;
+ (TVCommandItem*) createVerifyTVCommand:(NSString*) code;
+ (TVCommandItem*) createCurrentPcInfoCommand;
+ (TVCommandItem*) createOpenTvAppCommand:(NSString*)packgeName;
+ (TVCommandItem*) createCheckTvAccessibilityCommand;
+ (TVCommandItem*) createGetTvSYSAppCommand;
+ (TVCommandItem*)createGetTvOtherAppCommand;
+ (TVCommandItem*) createGetTvMouseDevicesCommand;
+ (TVCommandItem*) createGetTvInforCommand;
+ (TVCommandItem*) createPrepareForPCGameCommand:(NSString*) pc_ip andMac:(NSString*) pc_mac ;
+ (TVCommandItem*) createCloseStreamPCGameCommand:(NSString*) pc_ip andMac:(NSString*) pc_mac;
+ (TVCommandItem*) createCloseTvAppCommand:(NSString*) appPackage;
+ (TVCommandItem*)createUninstallTVAppCommand:(NSString*) appPackage;
+ (TVCommandItem*) createTVSettingPageCommand;
+ (TVCommandItem*) createOpenTvRdpCommand;
+ (TVCommandItem*)createShutdownTVCommand ;
+ (TVCommandItem*) createRebootTVCommand ;
+ (TVCommandItem*) createOpenTvAccessibilityCommand;
+ (TVCommandItem*) createOpenTvMiracastCommand;
+(PCCommandItem*) createGetPCInforCommand;
+(PCCommandItem*) createGetPCScreenStateCommand;
+(PCCommandItem*) createGetPCAppCommand;
+(PCCommandItem*) createOpenPcAPPMiracastCommand_tvname:(NSString*) tvname appname:(NSString*) appname path:(NSString*) path;
+(PCCommandItem*) createOpenPcRdpAppCommand_appname:(NSString*) appname path:(NSString*) path;
+(PCCommandItem*) createGetPCGameCommand;
+(PCCommandItem*) createOpenPcGameCommand:(NSString*) gamename path:(NSString*) path;
+(PCCommandItem*)createGetPCRecentListCommand:(NSString*) typeName ;
+(PCCommandItem*) createGetPCMediaSetsCommand:(NSString*) typeName ;
+(PCCommandItem*)createOpenPcMediaCommand:(NSString*) type filename:(NSString*)filename path:(NSString*)path tvname:(NSString*)tvname;
+(PCCommandItem*)createAddPcMediaPlaySetCommand:(NSString*) type setname:(NSString*) setname;
+(PCCommandItem*)createDeletePcMediaPlaySetCommand:(NSString*)type setname:(NSString*)setname;
+(PCCommandItem*) createAddPcFilesToSetCommand:(NSString*) type setname:(NSString*) setname liststr:(NSString*) liststr;
+(PCCommandItem*) createOpenPcMediaSetCommand:(NSString*) type setname:(NSString*) setname tvname:(NSString*) tvname;
+(PCCommandItem*) createPlayAsBGMCommand:(NSString*)type setname:(NSString*)setname tvname:(NSString*) tvname ;
+(PCCommandItem*)createDeleteCommand:(NSString*)path type:(NSString*)type;
+(PCCommandItem*)createPlayAllCommand:(NSString*) path tvname:(NSString*) tvname type:(NSString*) type;
+(PCCommandItem*)createGetPcMediaListCommand:(NSString*) path type:(NSString*)type root:(BOOL)root;
@end
