//
//  CommandUtil.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/1/2.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "CommandUtil.h"

@implementation CommandUtil
/**
 * <summary>
 *  构建获取验证PC的指令
 * </summary>
 * <returns>PC指令</returns>
 */
+ (PCCommandItem*) createVerifyPCCommand:(NSString*)code {
    PCCommandItem* cmd = [[PCCommandItem alloc]init];
    cmd.name = OrderConst_identityAction_name ;
    cmd.command = OrderConst_identityAction_command;
    cmd.param = [[NSMutableDictionary alloc] init];
    [cmd.param setObject:code forKey:@"code"];
    return cmd;
}
/**
 * <summary>
 *  构建告知TV，当前连接PC的指令
 * </summary>
 * <returns>TV指令</returns>
 */
+(TVCommandItem*)createCurrentPcInfoCommand {
    TVCommandItem* cmd = [[TVCommandItem alloc] init];
    cmd.firstcommand = OrderConst_getPCInfor_firCommand;
    cmd.secondcommand = [MyUIApplication getSelectedPCIP].name;
    cmd.fourthCommand =[MyUIApplication getSelectedPCIP].ip;
    cmd.fifthCommand = [NSString stringWithFormat:@"%d",[MyUIApplication getSelectedPCIP].port];
    cmd.sevencommand = [MyUIApplication getSelectedPCIP].mac;
    return cmd;
}
/**
 * <summary>
 *  构建打开TV上指定应用的指令
 * </summary>
 * <param name="appPackage">指定应用对应的包名</param>
 * <returns>TV指令</returns>
 */
+ (TVCommandItem*) createOpenTvAppCommand:(NSString*)packgeName{
    TVCommandItem* cmd = [[TVCommandItem alloc] init];
    [cmd setFirstcommand:OrderConst_openTVApp_firCommand];
    [cmd setSecondcommand:packgeName];
    return cmd;
}
/**
 * <summary>
 *  构建获取验证TV无障碍服务的指令
 * </summary>
 * <returns>TV指令</returns>
 */
+ (TVCommandItem*) createCheckTvAccessibilityCommand{
    TVCommandItem* cmd = [[TVCommandItem alloc] init];
    [cmd setFirstcommand:OrderConst_CHECK_ACCESSIBILITY_ISOPEN_firCommand];
    [cmd setSecondcommand:@""];
    return cmd;
}
/**
 * <summary>
 *  构建获取验证TV的指令
 * </summary>
 * <returns>TV指令</returns>
 */
+ (TVCommandItem*) createVerifyTVCommand:(NSString*) code {
    TVCommandItem* cmd = [[TVCommandItem alloc] init];
    [cmd setFirstcommand:OrderConst_identityAction_name];
    [cmd setSecondcommand:OrderConst_identityAction_command];
    [cmd setFourthCommand:code];
    return cmd;
}
/**
 * <summary>
 *  构建获取TV系统自带应用的指令
 * </summary>
 * <returns>TV指令</returns>
 */
+ (TVCommandItem*) createGetTvSYSAppCommand{
    TVCommandItem* cmd = [[TVCommandItem alloc] init];
    [cmd setFirstcommand:OrderConst_getTVSYSApps_firCommand];
    [cmd setSecondcommand:@""];
    return cmd;
}
/**
 * <summary>
 *  构建获取TV上用户自己安装应用的指令
 * </summary>
 * <returns>TV指令</returns>
 */
+ (TVCommandItem*)createGetTvOtherAppCommand{
    TVCommandItem* cmd = [[TVCommandItem alloc] init];
    [cmd setFirstcommand:OrderConst_getTVOtherApps_firCommand];
    [cmd setSecondcommand:@""];
    return cmd;
}
/**
 * <summary>
 *  构建获取TV连接的鼠标的指令
 * </summary>
 * <returns>TV指令</returns>
 */
+ (TVCommandItem*) createGetTvMouseDevicesCommand{
    TVCommandItem* cmd = [[TVCommandItem alloc] init];
    [cmd setFirstcommand:OrderConst_getTVMouses_firCommand];
    [cmd setSecondcommand:@""];
    return cmd;
}
/**
 * <summary>
 *  构建获取TV信息的指令
 * </summary>
 * <returns>TV指令</returns>
 */
+ (TVCommandItem*) createGetTvInforCommand{
    TVCommandItem* cmd = [[TVCommandItem alloc] init];
    [cmd setFirstcommand:OrderConst_getTVInfor_firCommand];
    [cmd setSecondcommand:@""];
    return cmd;
}
/**
 * <summary>
 *  构建在TV上准备接受PC游戏的指令(配对并开始串流)
 * </summary>
 * <param name="url">流媒体资源定位符</param>
 * <param name="fileName">流媒体文件名称</param>
 * <param name="fileType">流媒体文件类别(只能是video、audio、image)</param>
 * <returns>TV指令</returns>
 */
+ (TVCommandItem*) createPrepareForPCGameCommand:(NSString*) pc_ip andMac:(NSString*) pc_mac {
    TVCommandItem* cmd = [[TVCommandItem alloc]init];
    [cmd setFirstcommand:OrderConst_createPairAndStreamWithPC_firCommand];
    [cmd setSecondcommand:pc_ip];
    [cmd setFourthCommand:pc_mac];
    return cmd;
}
/**
 * <summary>
 *  构建在TV上准备接受PC游戏的指令(配对并开始串流)
 * </summary>
 * <param name="url">流媒体资源定位符</param>
 * <param name="fileName">流媒体文件名称</param>
 * <param name="fileType">流媒体文件类别(只能是video、audio、image)</param>
 * <returns>TV指令</returns>
 */
+ (TVCommandItem*) createCloseStreamPCGameCommand:(NSString*) pc_ip andMac:(NSString*) pc_mac{
    TVCommandItem* cmd = [[TVCommandItem alloc] init];
    [cmd setFirstcommand:OrderConst_quitStreamWithPC_firCommand];
    [cmd setSecondcommand:pc_ip];
    [cmd setFourthCommand:pc_mac];
    return cmd;
}
/**
 * <summary>
 *  构建关闭TV上指定应用的指令
 * </summary>
 * <param name="appPackage">指定应用对应的包名</param>
 * <returns>TV指令</returns>
 */
+ (TVCommandItem*) createCloseTvAppCommand:(NSString*) appPackage{
    TVCommandItem* cmd = [[TVCommandItem alloc] init];
    [cmd setFirstcommand:OrderConst_closeTVApp_firCommand];
    [cmd setSecondcommand:appPackage];
    return cmd;
}
/**
 * <summary>
 *  构建卸载TV上指定应用的指令
 * </summary>
 * <param name="appPackage">指定应用对应的包名</param>
 * <returns>TV指令</returns>
 */
+ (TVCommandItem*)createUninstallTVAppCommand:(NSString*) appPackage {
    TVCommandItem* cmd = [[TVCommandItem alloc] init];
    [cmd setFirstcommand:OrderConst_uninstallTVApp_firCommand];
    [cmd setSecondcommand:appPackage];
    return cmd;
}
/**
 * <summary>
 *  构建打开TV设置页面的指令
 * </summary>
 * <returns>TV指令</returns>
 */
+ (TVCommandItem*) createTVSettingPageCommand {
    TVCommandItem* cmd = [[TVCommandItem alloc] init];
    [cmd setFirstcommand:OrderConst_openSettingTV_firCommand];
    [cmd setSecondcommand:@""];
    return cmd;
}
/**
 * <summary>
 *  构建打开TV上RDP模式的指令
 * </summary>
 * <returns>TV指令</returns>
 */
+ (TVCommandItem*) createOpenTvRdpCommand{
    TVCommandItem* cmd = [[TVCommandItem alloc] init];
    [cmd setFirstcommand:OrderConst_openTVRdp_firCommand];
    [cmd setSecondcommand:@""];
    return cmd;
}
/**
 * <summary>
 *  构建关闭TV的指令
 * </summary>
 * <returns>TV指令</returns>
 */
+ (TVCommandItem*)createShutdownTVCommand {
    TVCommandItem* cmd = [[TVCommandItem alloc] init];
    [cmd setFirstcommand:OrderConst_shutdownTV_firCommand];
    [cmd setSecondcommand:@""];
    return cmd;
}
/**
 * <summary>
 *  构建重启TV的指令
 * </summary>
 * <returns>TV指令</returns>
 */
+ (TVCommandItem*) createRebootTVCommand {
    TVCommandItem* cmd = [[TVCommandItem alloc] init];
    [cmd setFirstcommand:OrderConst_rebootTV_firCommand];
    [cmd setSecondcommand:@""];
    return cmd;
}
/**
 * <summary>
 *  构建打开TV上ACCESSIBILITY的指令
 * </summary>
 * <returns>TV指令</returns>
 */
+ (TVCommandItem*) createOpenTvAccessibilityCommand {
    TVCommandItem* cmd = [[TVCommandItem alloc] init];
    [cmd setFirstcommand:OrderConst_openTVAccessibility_firCommand];
    [cmd setSecondcommand:@""];
    return cmd;
}
/**
 * <summary>
 *  构建打开TV上MIRACAST模式的指令
 * </summary>
 * <returns>TV指令</returns>
 */
+ (TVCommandItem*) createOpenTvMiracastCommand{
    TVCommandItem* cmd = [[TVCommandItem alloc] init];
    [cmd setFirstcommand:OrderConst_openTVMiracast_firCommand];
    [cmd setSecondcommand:@""];
    return cmd;
}
/**
 * <summary>
 *  构建获取PC系统信息的指令
 * </summary>
 * <returns>PC指令</returns>
 */
+(PCCommandItem*) createGetPCInforCommand{
    PCCommandItem* cmd = [[PCCommandItem alloc]init];
    [cmd setName:OrderConst_sysAction_name];
    [cmd setCommand:OrderConst_sysAction_getInfor_command];
    cmd.param = [[NSMutableDictionary alloc]init];
    return cmd;
}
/**
 * <summary>
 *  构建获取PC是否锁屏的指令
 * </summary>
 * <returns>PC指令</returns>
 */
+(PCCommandItem*) createGetPCScreenStateCommand {
    PCCommandItem* cmd = [[PCCommandItem alloc]init];
    [cmd setName:OrderConst_sysAction_name];
    [cmd setCommand:OrderConst_sysAction_getScreenState_command];
    cmd.param = [[NSMutableDictionary alloc]init];
    return cmd;
}
/**
 * <summary>
 *  构建获取PC应用的指令
 * </summary>
 * <returns>PC指令</returns>
 */
+(PCCommandItem*) createGetPCAppCommand {
    PCCommandItem* cmd = [[PCCommandItem alloc]init];
    [cmd setName:OrderConst_appAction_name];
    [cmd setCommand:OrderConst_appMediaAction_getList_command];
    cmd.param = [[NSMutableDictionary alloc]init];
    return cmd;
}
/**
 * <summary>
 *  以Miracast模式打开指定app的指令
 * </summary>
 * <param name="tvname">tv名称</param>
 * <param name="appname">应用名称</param>
 * <param name="path">应用路径</param>
 * <returns>PC指令</returns>
 */
+(PCCommandItem*) createOpenPcAPPMiracastCommand_tvname:(NSString*) tvname appname:(NSString*) appname path:(NSString*) path{
    PCCommandItem* cmd = [[PCCommandItem alloc]init];
    [cmd setName:OrderConst_appAction_name];
    [cmd setCommand:OrderConst_appAction_miracstOpen_command];
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:tvname forKey:@"tvname"];
    [params setObject:appname forKey:@"appname"];
    [params setObject:path forKey:@"path"];
    cmd.param = params;
    return cmd;
}
/**
 * <summary>
 *  以rdp模式打开PC上指定的app的指令
 * </summary>
 * <param name="appname">应用名称</param>
 * <param name="path">应用路径</param>
 * <returns>PC指令</returns>
 */
+(PCCommandItem*) createOpenPcRdpAppCommand_appname:(NSString*) appname path:(NSString*) path{
    PCCommandItem* cmd = [[PCCommandItem alloc]init];
    [cmd setName:OrderConst_appAction_name];
    [cmd setCommand:OrderConst_appAction_rdpOpen_command];
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:appname forKey:@"appname"];
    [params setObject:path forKey:@"path"];
    cmd.param = params;
    return cmd;
}
/**
 * <summary>
 *  构建获取PC游戏的指令
 * </summary>
 * <returns>PC指令</returns>
 */
+(PCCommandItem*) createGetPCGameCommand {
    PCCommandItem* cmd = [[PCCommandItem alloc]init];
    [cmd setName:OrderConst_gameAction_name];
    [cmd setCommand:OrderConst_appMediaAction_getList_command];
    cmd.param = [[NSMutableDictionary alloc] init];
    return cmd;
}
/**
 * <summary>
 *  打开PC上指定的游戏的指令
 * </summary>
 * <param name="gamename">游戏名称</param>
 * <param name="path">游戏路径</param>
 * <returns>PC指令</returns>
 */
+(PCCommandItem*) createOpenPcGameCommand:(NSString*) gamename path:(NSString*) path {
    PCCommandItem* cmd = [[PCCommandItem alloc]init];
    [cmd setName:OrderConst_gameAction_name];
    [cmd setCommand:OrderConst_gameAction_open_command];
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:gamename forKey:@"gamename"];
    [params setObject:path forKey:@"path"];
    cmd.param = params;
    return cmd;
}
/**
 * <summary>
 *  构建获取最近播放媒体文件列表的指令
 * </summary>
 * <param name="typeName">媒体文件类别(AUDIO、VIDEO)</param>
 * <returns>PC指令</returns>
 */
+(PCCommandItem*)createGetPCRecentListCommand:(NSString*) typeName {
    PCCommandItem* cmd = [[PCCommandItem alloc]init];
    [cmd setName: typeName];
    [cmd setCommand:OrderConst_appMediaAction_getRecent_command];
    return cmd;
}
/**
 * <summary>
 *  构建获取图片列表或音频列表的指令
 * </summary>
 * <param name="typeName">媒体文件类别(AUDIO、IMAGE)</param>
 * <returns>PC指令</returns>
 */
+(PCCommandItem*) createGetPCMediaSetsCommand:(NSString*) typeName {
    PCCommandItem* cmd = [[PCCommandItem alloc]init];
    [cmd setName:typeName];
    [cmd setCommand:OrderConst_mediaAction_getSets_command];
    return cmd;
}
/**
 * <summary>
 *  打开PC上指定的媒体文件到指定TV的指令
 * </summary>
 * <param name="type">媒体文件类别(AUDIO、VIDEO、IMAGE)</param>
 * <param name="filename">媒体文件名称</param>
 * <param name="path">媒体文件路径信息</param>
 * <param name="tvname">tv名称</param>
 * <returns>PC指令</returns>
 */
+(PCCommandItem*)createOpenPcMediaCommand:(NSString*) type filename:(NSString*)filename path:(NSString*)path tvname:(NSString*)tvname{
    PCCommandItem* cmd = [[PCCommandItem alloc]init];
    [cmd setName:type];
    [cmd setCommand:OrderConst_mediaAction_play_command];
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:filename forKey:@"filename"];
    [params setObject:path forKey:@"path"];
    [params setObject:tvname forKey:@"tvname"];
    cmd.param = params;
    return cmd;
}
/**
 * <summary>
 *  向PC上增加播放列表的指令
 * </summary>
 * <param name="type">媒体文件类别(AUDIO、IMAGE)</param>
 * <param name="name">播放列表名称</param>
 * <returns>PC指令</returns>
 */
+(PCCommandItem*)createAddPcMediaPlaySetCommand:(NSString*) type setname:(NSString*) setname{
    PCCommandItem* cmd = [[PCCommandItem alloc]init];
    [cmd setName:type];
    [cmd setCommand:OrderConst_mediaAction_addSet_command];
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:setname forKey:@"setname"];
    cmd.param = params;
    return cmd;
}
/**
 * <summary>
 *  向PC上删除指定播放列表的指令
 * </summary>
 * <param name="type">媒体文件类别(AUDIO、IMAGE)</param>
 * <param name="name">播放列表名称</param>
 * <returns>PC指令</returns>
 */
+(PCCommandItem*)createDeletePcMediaPlaySetCommand:(NSString*)type setname:(NSString*)setname{
    PCCommandItem* cmd = [[PCCommandItem alloc]init];
    [cmd setName:type];
    [cmd setCommand:OrderConst_mediaAction_deleteSet_command];
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:setname forKey:@"setname"];
    cmd.param = params;
    return cmd;
}
/**
 * <summary>
 *  向PC上增加媒体文件列表到指定播放列表的指令
 * </summary>
 * <param name="type">媒体文件类别(AUDIO、IMAGE)</param>
 * <param name="name">播放列表名称</param>
 * <returns>PC指令</returns>
 */
+(PCCommandItem*) createAddPcFilesToSetCommand:(NSString*) type setname:(NSString*) setname liststr:(NSString*) liststr{
    PCCommandItem* cmd = [[PCCommandItem alloc]init];
    [cmd setName:type];
    [cmd setCommand:OrderConst_mediaAction_addFilesToSet_command];
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:setname forKey:@"setname"];
    [params setObject:liststr forKey:@"liststr"];
    cmd.param = params;
    return cmd;
}
/**
 * <summary>
 *  打开PC上指定的媒体文件到指定TV的指令
 * </summary>
 * <param name="type">媒体文件类别(AUDIO、VIDEO、IMAGE)</param>
 * <param name="filename">媒体文件名称</param>
 * <param name="path">媒体文件路径信息</param>
 * <param name="tvname">tv名称</param>
 * <returns>PC指令</returns>
 */
+(PCCommandItem*) createOpenPcMediaSetCommand:(NSString*) type setname:(NSString*) setname tvname:(NSString*) tvname {
    PCCommandItem* cmd = [[PCCommandItem alloc]init];
    [cmd setName:type];
    [cmd setCommand:OrderConst_mediaAction_playSet_command_BGM];
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:setname forKey:@"setname"];
    [params setObject:tvname forKey:@"tvname"];
    cmd.param = params;
    return cmd;
}
+(PCCommandItem*) createPlayAsBGMCommand:(NSString*)type setname:(NSString*)setname tvname:(NSString*) tvname {
    PCCommandItem* cmd = [[PCCommandItem alloc]init];
    [cmd setName: type];
    [cmd setCommand:OrderConst_mediaAction_playSet_command_BGM];
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:setname forKey:@"setname"];
    [params setObject:tvname forKey:@"tvname"];
    cmd.param = params;
    return cmd;
}
+(PCCommandItem*)createDeleteCommand:(NSString*)path type:(NSString*)type {
    PCCommandItem* cmd = [[PCCommandItem alloc]init];
    [cmd setName:type];
    [cmd setCommand:OrderConst_mediaAction_DELETE_command];
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:path forKey:@"folder"];
    cmd.param = params;
    return cmd;
}
+(PCCommandItem*)createPlayAllCommand:(NSString*) path tvname:(NSString*) tvname type:(NSString*) type {
    PCCommandItem* cmd = [[PCCommandItem alloc]init];
    [cmd setName:type];
    [cmd setCommand:OrderConst_mediaAction_playALL_command];
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:path forKey:@"folder"];
    [params setObject:tvname forKey:@"tvname"];
    cmd.param = params;
    return cmd;
}
/**
 * <summary>
 *  构建获取指定路径下媒体文件列表的指令
 * </summary>
 * <param name="path">路径信息</param>
 * <param name="type">文件类别(VIDEO、AUDIO、IMAGE)</param>
 * <param name="root">是否是媒体库根目录</param>
 * <returns>PC指令</returns>
 */
+(PCCommandItem*)createGetPcMediaListCommand:(NSString*) path type:(NSString*)type root:(BOOL)root {
    PCCommandItem* cmd = [[PCCommandItem alloc]init];
    [cmd setName:type];
    [cmd setCommand:OrderConst_appMediaAction_getList_command];
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    if (root) {
        [params setObject:@"root" forKey:@"folder"];
    }else {
        [params setObject:path forKey:@"folder"];
    }
    cmd.param = params;
    return cmd;
}
+ (TVCommandItem*)closeRdp {
    TVCommandItem* cmd = [[TVCommandItem alloc] init];
    [cmd setFirstcommand:OrderConst_CLOSERDP];
    return cmd;
}
@end
