//
//  OrderConst.h
//  AreaParty
//
//  Created by 杜哲凯 on 2017/12/25.
//  Copyright © 2017年 杜哲凯. All rights reserved.
//

#import <Foundation/Foundation.h>
extern int const OrderConst_success ;
extern int const OrderConst_failure ;
extern int const OrderConst_somefailure ;

extern int const OrderConst_refreshTab01MiddleImage_order ;
extern int const OrderConst_refreshTab01ComputerActivity_order ;
extern int const OrderConst_refreshTab01ComputerFragment01_order ;
extern int const OrderConst_refreshTab01ComputerFragment02_order ;
extern int const OrderConst_actionSuccess_order ;
extern int const OrderConst_actionFail_order ;
extern int const OrderConst_openFolder_order_successful ;
extern int const OrderConst_openFolder_order_fail ;
extern int const OrderConst_returnToParentFolder ;
extern int const OrderConst_getDiskList_order_successful ;
extern int const OrderConst_getDiskList_order_fail ;
extern int const OrderConst_getExeList_order_successful ;
extern int const OrderConst_getExeList_order_fail ;
extern int const OrderConst_addSharedFilePath_successful ;
extern int const OrderConst_addSharedFilePath_fail ;
extern int const OrderConst_shareFileState ;
extern int const OrderConst_setUserName ;

extern int const OrderConst_getTVSYSApp_OK ;
extern int const OrderConst_getTVOtherApp_OK ;
extern int const OrderConst_getTVSYSApp_Fail ;
extern int const OrderConst_getTVOtherApp_Fail ;
extern int const OrderConst_getTVMouse_OK ;
extern int const OrderConst_getTVMouse_Fail ;
extern int const OrderConst_getPCApp_OK ;
extern int const OrderConst_getPCApp_Fail ;
extern int const OrderConst_getPCGame_OK ;
extern int const OrderConst_getPCGame_Fail ;
extern int const OrderConst_getTVInfor_OK ;
extern int const OrderConst_getTVInfor_Fail ;
extern int const OrderConst_openPCApp_OK ;
extern int const OrderConst_openPCApp_Fail ;
extern int const OrderConst_openPCGame_OK ;
extern int const OrderConst_openPCGame_Fail ;
extern int const OrderConst_getPCInfor_OK ;
extern int const OrderConst_getPCInfor_Fail ;
extern int const OrderConst_PCScreenLocked ;
extern int const OrderConst_PCScreenNotLocked ;
extern int const OrderConst_getPCMedia_OK ;
extern int const OrderConst_getPCMedia_Fail ;
extern int const OrderConst_playPCMedia_OK ;
extern int const OrderConst_playPCMedia_Fail ;
extern int const OrderConst_getPCRecentVideo_OK ;
extern int const OrderConst_getPCRecentVideo_Fail ;
extern int const OrderConst_getPCRecentAudio_OK ;
extern int const OrderConst_getPCRecentAudio_Fail ;
extern int const OrderConst_getPCAudioSets_OK ;
extern int const OrderConst_getPCAudioSets_Fail ;
extern int const OrderConst_getPCImageSets_OK ;
extern int const OrderConst_getPCImageSets_Fail ;
extern int const OrderConst_addPCSet_OK ;
extern int const OrderConst_addPCSet_Fail ;
extern int const OrderConst_addPCFilesToSet_OK ;
extern int const OrderConst_addPCFilesToSet_Fail ;
extern int const OrderConst_deletePCSet_OK ;
extern int const OrderConst_deletePCSet_Fail ;
extern int const OrderConst_playPCMediaSet_OK ;
extern int const OrderConst_playPCMediaSet_Fail ;
extern int const OrderConst_mediaAction_DELETE_OK ;
extern int const OrderConst_mediaAction_DELETE_Fail ;

extern int const OrderConst_addFriend_order ;
extern int const OrderConst_getUserMsgFail_order ;
extern int const OrderConst_friendUserLogIn_order ;
extern int const OrderConst_shareUserLogIn_order ;
extern int const OrderConst_netUserLogIn_order ;
extern int const OrderConst_delFriend_order ;
extern int const OrderConst_userFriendAdd_order ;
extern int const OrderConst_userLogOut ;
extern int const OrderConst_showUnfriendFiles ;
extern int const OrderConst_showFriendFiles ;
extern int const OrderConst_shareFileSuccess ;
extern int const OrderConst_deleteShareFileSuccess;
extern int const OrderConst_shareFileFail ;
extern int const OrderConst_addChatNum ;
extern int const OrderConst_addFileRequest ;
//downloadFragment
extern int const OrderConst_torrentFileStartReq ;
extern int const OrderConst_torrentFilePauseReq ;
extern int const OrderConst_torrentFileStart ;
extern int const OrderConst_torrentFileContinue ;
extern int const OrderConst_torrentFileCancelReq ;
extern int const OrderConst_downloadFileContinue ;
extern int const OrderConst_agreeDownload ;
extern int const OrderConst_agreeDownloadState ;
extern int const OrderConst_downloadFileStartReq ;
extern int const OrderConst_downloadFilePauseReq ;
extern int const OrderConst_downloadFileCancelReq ;
extern int const OrderConst_downloadFilePause ;
extern int const OrderConst_torrentFilePause ;
extern int const OrderConst_downloadFileStart ;


extern NSString* const OrderConst_monitorActionData_name;
extern NSString* const OrderConst_monitorData_get_command;

extern NSString* const OrderConst_processAction_name;
extern NSString* const OrderConst_process_closeById_command;

extern NSString* const OrderConst_computerAction_name;
extern NSString* const OrderConst_computerAction_reboot_command;
extern NSString* const OrderConst_computerAction_shutdown_command;

extern NSString* const OrderConst_fileAction_name;
extern NSString* const OrderConst_folderAction_name;
extern NSString* const OrderConst_paramSourcePath;
extern NSString* const OrderConst_paramTargetPath;
extern NSString* const OrderConst_folderAction_openInComputer_more_param;
extern NSString* const OrderConst_folderAction_openInComputer_more_message;
extern NSString* const OrderConst_folderAction_openInComputer_finish_param;
extern NSString* const OrderConst_fileAction_openInComputer_command;
extern NSString* const OrderConst_folderAction_openInComputer_command;
extern NSString* const OrderConst_fileOrFolderAction_deleteInComputer_command;
extern NSString* const OrderConst_fileOrFolderAction_renameInComputer_command;
extern NSString* const OrderConst_folderAction_addInComputer_command;
extern NSString* const OrderConst_folderAction_addToList_command;
extern NSString* const OrderConst_fileOrFolderAction_copy_command;
extern NSString* const OrderConst_fileOrFolderAction_cut_command;
extern NSString* const OrderConst_fileAction_share_command;

extern NSString* const OrderConst_ip_phone_source;
extern NSString* const OrderConst_ip_TV_source;
extern NSString* const OrderConst_ip_PC_B_source;
extern NSString* const OrderConst_ip_PC_Y_source;
extern NSString* const OrderConst_ip_PC_monitor_founction;
extern NSString* const OrderConst_ip_PC_action_founction;
extern NSString* const OrderConst_ip_default_type;

extern NSString* const OrderConst_diskAction_name;
extern NSString* const OrderConst_diskAction_get_command;

extern NSString* const OrderConst_exeAction_name;
extern NSString* const OrderConst_appAction_get_command;
extern NSString* const OrderConst_exeAction_get_more_message;
extern NSString* const OrderConst_exeAction_get_finish_message;
extern NSString* const OrderConst_exeAction_get_more_param;

extern NSString* const OrderConst_addPathToHttp_Name;
extern NSString* const OrderConst_addPathToHttp_command;

extern NSString* const OrderConst_dlnaCastToTV_Command;

extern NSString* const OrderConst_sysAction_name;
extern NSString* const OrderConst_appAction_name;
extern NSString* const OrderConst_identityAction_name;
extern NSString* const OrderConst_identityAction_command;
extern NSString* const OrderConst_videoAction_name;
extern NSString* const OrderConst_audioAction_name;
extern NSString* const OrderConst_gameAction_name;
extern NSString* const OrderConst_imageAction_name;
extern NSString* const OrderConst_sysAction_getScreenState_command;
extern NSString* const OrderConst_sysAction_getInfor_command;
extern NSString* const OrderConst_appMediaAction_getList_command;
extern NSString* const OrderConst_appMediaAction_getRecent_command;
extern NSString* const OrderConst_appAction_miracstOpen_command;
extern NSString* const OrderConst_appAction_rdpOpen_command;
extern NSString* const OrderConst_mediaAction_play_command;
extern NSString* const OrderConst_mediaAction_playALL_command;
extern NSString* const OrderConst_mediaAction_playSet_command;
extern NSString* const OrderConst_mediaAction_playSet_command_BGM;
extern NSString* const OrderConst_mediaAction_DELETE_command;
extern NSString* const OrderConst_gameAction_open_command;
extern NSString* const OrderConst_mediaAction_getSets_command;
extern NSString* const OrderConst_mediaAction_addSet_command;
extern NSString* const OrderConst_mediaAction_deleteSet_command;
extern NSString* const OrderConst_mediaAction_addFilesToSet_command;

extern NSString* const OrderConst_getTVInfor_firCommand;
extern NSString* const OrderConst_getTVSYSApps_firCommand;
extern NSString* const OrderConst_getTVOtherApps_firCommand;
extern NSString* const OrderConst_getTVMouses_firCommand;
extern NSString* const OrderConst_openTVApp_firCommand;
extern NSString* const OrderConst_closeTVApp_firCommand;
extern NSString* const OrderConst_uninstallTVApp_firCommand;
extern NSString* const OrderConst_openTVRdp_firCommand;
extern NSString* const OrderConst_openTVAccessibility_firCommand;
extern NSString* const OrderConst_openTVMiracast_firCommand;
extern NSString* const OrderConst_shutdownTV_firCommand;
extern NSString* const OrderConst_rebootTV_firCommand;
extern NSString* const OrderConst_openSettingTV_firCommand ;
extern NSString* const OrderConst_createPairWithPC_firCommand ;
extern NSString* const OrderConst_startStreamWithPC_firCommand;
extern NSString* const OrderConst_quitStreamWithPC_firCommand ;
extern NSString* const OrderConst_createPairAndStreamWithPC_firCommand;
extern NSString* const OrderConst_getPCInfor_firCommand;

extern NSString* const OrderConst_VLCAction_firCommand;
extern NSString* const OrderConst_VLCAction_Play_Pause_secondCommand ;
extern NSString* const OrderConst_VLCAction_Play_secondCommand ;
extern NSString* const OrderConst_VLCAction_Pause_secondCommand ;
extern NSString* const OrderConst_VLCAction_Stop_secondCommand ;
extern NSString* const OrderConst_VLCAction_Fast_secondCommand ;
extern NSString* const OrderConst_VLCAction_Rewind_SecondCommand ;
extern NSString* const OrderConst_VLCAction_Exit_SecondCommand ;
extern NSString* const OrderConst_VLCAction_Volume_Up_secondCommand ;
extern NSString* const OrderConst_VLCAction_Volume_Down_secondCommand ;
extern NSString* const OrderConst_VLCAction_BGM_secondCommand ;

extern NSString* const OrderConst_VLCAction_Appoint_Play_Position_secondCommand ;
extern NSString* const OrderConst_CHECK_ACCESSIBILITY_ISOPEN_firCommand ;

extern NSString* const OrderConst_VLCAction_HideSubtitle_SecondCommand ;
extern NSString* const OrderConst_VLCAction_LoadSubtitle_SecondCommand ;

extern NSString* const OrderConst_GET_AREAPARTY_PATH ;

extern NSString* const OrderConst_VLCAction_Subtitle_Before_SecondCommand;
extern NSString* const OrderConst_VLCAction_SubtitleDelay_SecondCommand;
extern NSString* const OrderConst_CLOSERDP ;
@interface OrderConst: NSObject

@end
