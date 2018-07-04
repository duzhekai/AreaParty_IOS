//
//  OrderConst.m
//  AreaParty
//
//  Created by 杜哲凯 on 2017/12/25.
//  Copyright © 2017年 杜哲凯. All rights reserved.
//

#import "OrderConst.h"
int const OrderConst_success = 200;
int const OrderConst_failure = 404;
int const OrderConst_somefailure = 405;

int const OrderConst_refreshTab01MiddleImage_order = 0x100;
int const OrderConst_refreshTab01ComputerActivity_order = 0x101;
int const OrderConst_refreshTab01ComputerFragment01_order = 0x102;
int const OrderConst_refreshTab01ComputerFragment02_order = 0x103;
int const OrderConst_actionSuccess_order = 0x104;
int const OrderConst_actionFail_order = 0x105;
int const OrderConst_openFolder_order_successful = 0x106;
int const OrderConst_openFolder_order_fail = 0x107;
int const OrderConst_returnToParentFolder = 0x108;
int const OrderConst_getDiskList_order_successful = 0x109;
int const OrderConst_getDiskList_order_fail = 0x110;
int const OrderConst_getExeList_order_successful = 0x111;
int const OrderConst_getExeList_order_fail = 0x112;
int const OrderConst_addSharedFilePath_successful = 0x114;
int const OrderConst_addSharedFilePath_fail = 0x115;
int const OrderConst_shareFileState = 0x118;
int const OrderConst_setUserName = 0x119;

int const OrderConst_getTVSYSApp_OK = 0x301;
int const OrderConst_getTVOtherApp_OK = 0x302;
int const OrderConst_getTVSYSApp_Fail = 0x303;
int const OrderConst_getTVOtherApp_Fail = 0x304;
int const OrderConst_getTVMouse_OK = 0x305;
int const OrderConst_getTVMouse_Fail = 0x306;
int const OrderConst_getPCApp_OK = 0x307;
int const OrderConst_getPCApp_Fail = 0x308;
int const OrderConst_getPCGame_OK = 0x309;
int const OrderConst_getPCGame_Fail = 0x310;
int const OrderConst_getTVInfor_OK = 0x311;
int const OrderConst_getTVInfor_Fail = 0x312;
int const OrderConst_openPCApp_OK = 0x313;
int const OrderConst_openPCApp_Fail = 0x314;
int const OrderConst_openPCGame_OK = 0x315;
int const OrderConst_openPCGame_Fail = 0x316;
int const OrderConst_getPCInfor_OK = 0x317;
int const OrderConst_getPCInfor_Fail = 0x318;
int const OrderConst_PCScreenLocked = 0x319;
int const OrderConst_PCScreenNotLocked = 0x320;
int const OrderConst_getPCMedia_OK = 0x201;
int const OrderConst_getPCMedia_Fail = 0x202;
int const OrderConst_playPCMedia_OK = 0x203;
int const OrderConst_playPCMedia_Fail = 0x204;
int const OrderConst_getPCRecentVideo_OK = 0x205;
int const OrderConst_getPCRecentVideo_Fail = 0x206;
int const OrderConst_getPCRecentAudio_OK = 0x207;
int const OrderConst_getPCRecentAudio_Fail = 0x208;
int const OrderConst_getPCAudioSets_OK = 0x209;
int const OrderConst_getPCAudioSets_Fail = 0x210;
int const OrderConst_getPCImageSets_OK = 0x211;
int const OrderConst_getPCImageSets_Fail = 0x212;
int const OrderConst_addPCSet_OK = 0x213;
int const OrderConst_addPCSet_Fail = 0x214;
int const OrderConst_addPCFilesToSet_OK = 0x215;
int const OrderConst_addPCFilesToSet_Fail = 0x216;
int const OrderConst_deletePCSet_OK = 0x217;
int const OrderConst_deletePCSet_Fail = 0x218;
int const OrderConst_playPCMediaSet_OK = 0x219;
int const OrderConst_playPCMediaSet_Fail = 0x220;
int const OrderConst_mediaAction_DELETE_OK = 0x221;
int const OrderConst_mediaAction_DELETE_Fail = 0x222;

int const OrderConst_addFriend_order = 0x600;
int const OrderConst_getUserMsgFail_order = 0x601;
int const OrderConst_friendUserLogIn_order = 0x602;
int const OrderConst_shareUserLogIn_order = 0x603;
int const OrderConst_netUserLogIn_order = 0x604;
int const OrderConst_delFriend_order = 0x605;
int const OrderConst_userFriendAdd_order = 0x606;
int const OrderConst_userLogOut = 0x607;
int const OrderConst_showUnfriendFiles = 0x608;
int const OrderConst_showFriendFiles = 0x609;
int const OrderConst_shareFileSuccess = 0x610;
int const OrderConst_deleteShareFileSuccess = 0x614;
int const OrderConst_shareFileFail = 0x611;
int const OrderConst_addChatNum = 0x612;
int const OrderConst_addFileRequest = 0x613;
int const OrderConst_addGroupRequest = 0x615;
int const OrderConst_showGroupFiles = 0x616;
int const OrderConst_updateGroupInfo = 0x617;
int const OrderConst_deleteGroupInfo = 0x618;
//downloadFragment
int const OrderConst_torrentFileStartReq = 0x6100;
int const OrderConst_torrentFilePauseReq = 0x6101;
int const OrderConst_torrentFileStart = 0x6102;
int const OrderConst_torrentFileContinue = 0x6103;
int const OrderConst_torrentFileCancelReq = 0x6104;
int const OrderConst_downloadFileContinue = 0x6105;
int const OrderConst_agreeDownload = 0x6106;
int const OrderConst_agreeDownloadState = 0x6107;
int const OrderConst_downloadFileStartReq = 0x6108;
int const OrderConst_downloadFilePauseReq = 0x6109;
int const OrderConst_downloadFileCancelReq = 0x6110;
int const OrderConst_downloadFilePause = 0x6111;
int const OrderConst_torrentFilePause = 0x6112;
int const OrderConst_downloadFileStart = 0x6113;


NSString* const OrderConst_monitorActionData_name = @"MONITORDATA";
NSString* const OrderConst_monitorData_get_command = @"GET";

NSString* const OrderConst_processAction_name = @"PROCESS";
NSString* const OrderConst_process_closeById_command = @"CLOSE";

NSString* const OrderConst_computerAction_name = @"SERVERCOMPUTER";
NSString* const OrderConst_computerAction_reboot_command = @"REBOOT";
NSString* const OrderConst_computerAction_shutdown_command = @"SHUTDOWN";

NSString* const OrderConst_fileAction_name = @"FILE";
NSString* const OrderConst_folderAction_name = @"FOLDER";
NSString* const OrderConst_paramSourcePath = @"-PATH-";
NSString* const OrderConst_paramTargetPath = @"-PATH-";
NSString* const OrderConst_folderAction_openInComputer_more_param = @"GETMORE";
NSString* const OrderConst_folderAction_openInComputer_more_message = @"MOREFILE";
NSString* const OrderConst_folderAction_openInComputer_finish_param = @"FINISHFILE";
NSString* const OrderConst_fileAction_openInComputer_command = @"OPENFILE";
NSString* const OrderConst_folderAction_openInComputer_command = @"OPENFOLDER";
NSString* const OrderConst_fileOrFolderAction_deleteInComputer_command = @"DELETE";
NSString* const OrderConst_fileOrFolderAction_renameInComputer_command = @"RENAME";
NSString* const OrderConst_folderAction_addInComputer_command = @"ADDFOLDER";
NSString* const OrderConst_folderAction_addToList_command = @"ADDTOHTTP";
NSString* const OrderConst_fileOrFolderAction_copy_command = @"COPY";
NSString* const OrderConst_fileOrFolderAction_cut_command = @"CUT";
NSString* const OrderConst_fileAction_share_command = @"SHAREFILE";

NSString* const OrderConst_ip_phone_source = @"PHONE";
NSString* const OrderConst_ip_TV_source = @"TV";
NSString* const OrderConst_ip_PC_B_source = @"PC_B";
NSString* const OrderConst_ip_PC_Y_source = @"PC_Y";
NSString* const OrderConst_ip_PC_monitor_founction = @"MONITOR";
NSString* const OrderConst_ip_PC_action_founction = @"ACTION";
NSString* const OrderConst_ip_default_type = @"DEFAULT";

NSString* const OrderConst_diskAction_name = @"DISK";
NSString* const OrderConst_diskAction_get_command = @"GETDISKLIST";

NSString* const OrderConst_exeAction_name = @"EXE";
NSString* const OrderConst_appAction_get_command = @"GETEXELIST";
NSString* const OrderConst_exeAction_get_more_message = @"MOREEXE";
NSString* const OrderConst_exeAction_get_finish_message = @"FINISHEXE";
NSString* const OrderConst_exeAction_get_more_param = @"GETMOREEXE";

NSString* const OrderConst_addPathToHttp_Name = @"PC";
NSString* const OrderConst_addPathToHttp_command = @"AddDirsHTTP";

NSString* const OrderConst_dlnaCastToTV_Command = @"OPEN_HTTP_MEDIA";

NSString* const OrderConst_UTOrrent = @"OPEN_UTORRENT";
NSString* const OrderConst_sysAction_name = @"SYS";
NSString* const OrderConst_appAction_name = @"APP";
NSString* const OrderConst_identityAction_name = @"SECURITY";
NSString* const OrderConst_identityAction_command = @"PAIR";
NSString* const OrderConst_videoAction_name = @"VIDEO";
NSString* const OrderConst_audioAction_name = @"AUDIO";
NSString* const OrderConst_gameAction_name = @"GAME";
NSString* const OrderConst_imageAction_name = @"IMAGE";
NSString* const OrderConst_sysAction_getScreenState_command = @"GETSCREENSTATE";
NSString* const OrderConst_sysAction_getInfor_command = @"GETINFOR";
NSString* const OrderConst_appMediaAction_getList_command = @"GETTOTALLIST";
NSString* const OrderConst_appMediaAction_getRecent_command = @"GETRECENTLIST";
NSString* const OrderConst_appAction_miracstOpen_command = @"OPEN_MIRACAST";
NSString* const OrderConst_appAction_rdpOpen_command = @"OPEN_RDP";
NSString* const OrderConst_mediaAction_play_command = @"PLAY";
NSString* const OrderConst_mediaAction_playALL_command = @"PLAYALL";
NSString* const OrderConst_mediaAction_playSet_command = @"PLAYSET";
NSString* const OrderConst_mediaAction_playSet_command_BGM = @"PLAYSETASBGM";
NSString* const OrderConst_mediaAction_DELETE_command = @"DELETE";
NSString* const OrderConst_gameAction_open_command = @"OPEN";
NSString* const OrderConst_mediaAction_getSets_command = @"GETSETS";
NSString* const OrderConst_mediaAction_addSet_command = @"ADDSET";
NSString* const OrderConst_mediaAction_deleteSet_command = @"DELETESET";
NSString* const OrderConst_mediaAction_addFilesToSet_command = @"ADDFILESTOSET";

NSString* const OrderConst_getTVInfor_firCommand = @"GET_TV_INFOR";
NSString* const OrderConst_getTVSYSApps_firCommand = @"GET_TV_SYSAPPS";
NSString* const OrderConst_getTVOtherApps_firCommand = @"GET_TV_INSTALLEDAPPS";
NSString* const OrderConst_getTVMouses_firCommand = @"GET_TV_MOUSES";
NSString* const OrderConst_openTVApp_firCommand = @"OPEN_TV_APPS";
NSString* const OrderConst_closeTVApp_firCommand = @"CLOSE_TV_APPS";
NSString* const OrderConst_uninstallTVApp_firCommand = @"UNINSTALL_TV_APPS";
NSString* const OrderConst_openTVRdp_firCommand = @"OPEN_RDP";
NSString* const OrderConst_openTVAccessibility_firCommand = @"OPEN_ACCESSIBILITY";
NSString* const OrderConst_openTVMiracast_firCommand = @"OPEN_MIRACAST";
NSString* const OrderConst_shutdownTV_firCommand = @"SHUTDOWN_TV";
NSString* const OrderConst_rebootTV_firCommand = @"REBOOT_TV";
NSString* const OrderConst_openSettingTV_firCommand = @"OPEN_TV_SETTINGPAGE";
NSString* const OrderConst_createPairWithPC_firCommand = @"GAME_PAIR";
NSString* const OrderConst_startStreamWithPC_firCommand = @"GAME_BEGIN_STREAMING";
NSString* const OrderConst_quitStreamWithPC_firCommand = @"GAME_QUIT_STREAMING";
NSString* const OrderConst_createPairAndStreamWithPC_firCommand = @"GAME_PLAY";
NSString* const OrderConst_getPCInfor_firCommand = @"CURRENT_PC_INFOR";

NSString* const OrderConst_VLCAction_firCommand = @"CONTROL_MEDIA";
NSString* const OrderConst_VLCAction_Play_Pause_secondCommand = @"PLAY_PAUSE";
NSString* const OrderConst_VLCAction_Play_secondCommand = @"PLAY";
NSString* const OrderConst_VLCAction_Pause_secondCommand = @"PAUSE";
NSString* const OrderConst_VLCAction_Stop_secondCommand = @"STOP";
NSString* const OrderConst_VLCAction_Fast_secondCommand = @"FAST_FORWARD";
NSString* const OrderConst_VLCAction_Rewind_SecondCommand = @"REWIND";
NSString* const OrderConst_VLCAction_Exit_SecondCommand = @"EXIT_PLAYER";
NSString* const OrderConst_VLCAction_Volume_Up_secondCommand = @"VOLUME_UP";
NSString* const OrderConst_VLCAction_Volume_Down_secondCommand = @"VOLUME_DOWN";
NSString* const OrderConst_VLCAction_BGM_secondCommand = @"IMAGE_BACKGROUND_MUSIC";

NSString* const OrderConst_VLCAction_Appoint_Play_Position_secondCommand = @"PLAY_APPOINT_POSITION";
NSString* const OrderConst_CHECK_ACCESSIBILITY_ISOPEN_firCommand= @"CHECK_ACCESSIBILITY" ;

NSString* const OrderConst_VLCAction_HideSubtitle_SecondCommand = @"HIDE_SUBTITLE";
NSString* const OrderConst_VLCAction_LoadSubtitle_SecondCommand = @"LOAD_SUBTITLE";

NSString* const OrderConst_GET_AREAPARTY_PATH = @"GETAREAPARTYPATH";

NSString* const OrderConst_VLCAction_Subtitle_Before_SecondCommand = @"SUBTITLE_BEFORE";
NSString* const OrderConst_VLCAction_SubtitleDelay_SecondCommand = @"SUBTITLE_DELAY";
NSString* const OrderConst_CLOSERDP = @"RDP_BACK";

NSString* const OrderConst_GETDOWNLOADSTATE = @"GETDOWNLOADSTATE";
NSString* const OrderConst_GETDOWNLOADProcess = @"GETPROCESS";
NSString* const OrderConst_STOPDOWNLOAD = @"STOPDOWNLOAD";
NSString* const OrderConst_RECOVERDOWNLOAD = @"RECOVERDOWNLOAD";
NSString* const OrderConst_DELETEDOWNLOAD = @"DELETEDOWNLOAD";

NSString* const OrderConst_BLUETOOTH = @"BLUETOOTH";
NSString* const OrderConst_openBLUETOOTH = @"OPEN_AND_SCAN_BLUETOOTH";
NSString* const OrderConst_closeBLUETOOTH = @"CLOSE_BLUETOOTH";
NSString* const OrderConst_connectBLUETOOTH = @"BOND_OR_CONNECT_BLUETOOTH";
NSString* const OrderConst_unpairBlueTooth = @"BLUETOOTH_UNPAIR";
@implementation OrderConst

@end
