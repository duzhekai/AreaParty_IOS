//
//  MyUIApplication.h
//  AreaParty
//
//  Created by 杜哲凯 on 2017/12/4.
//  Copyright © 2017年 杜哲凯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SharedflieBean.h"
#import "IPInforBean.h"
#import "FillingIPInforList.h"
#import "MyConnector.h"
#import "SelectedDeviceChangedEvent.h"
#import "RequestFormat.h"
#import "OrderConst.h"
#import "YYModel.h"
#import "RemoteDownloadActivityViewController.h"
#import "GCDAsyncSocket.h"
#import "CommandUtil.h"
#import "TVAppHelper.h"
#import "TVPCNetStateChangeEvent.h"
#import "ReceivedActionMessageFormat.h"
#import "PreferenceUtil.h"
#import "AFNetworking.h"
#import "Update_ReceiveMsgBean.h"
#import "Update_SendMsgBean.h"
#import "changeSelectedDeviceNameEvent.h"
#import "AESc.h"
//域名转IP
#include <sys/types.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <netdb.h>
//获取IP
#include <arpa/inet.h>
#include <netdb.h>
#include <net/if.h>
#include <ifaddrs.h>
#import <dlfcn.h>
#import <SystemConfiguration/SystemConfiguration.h>  
@interface MyUIApplication : UIApplication<GCDAsyncSocketDelegate>
@property (strong,nonatomic) NSMutableArray<UIViewController*>* activities;
+(void) addMySharedFlies:(SharedflieBean*)mysharedFiles;
+(NSMutableArray<SharedflieBean*> *) getmySharedFiles;
+(void) setlaunchtimeid:(NSString*) timeid;
+(NSString*)getLaunchTimeId;
+ (IPInforBean*) getSelectedPCIP;
+ (IPInforBean*) getSelectedTVIP;
+ (void) setSelectedPCIP:(IPInforBean*)selectedPCIP1;
+ (void) setSelectedTVIP:(IPInforBean*)selectedTVIP1;
+ (NSMutableArray<IPInforBean*>*) getPC_YInforList;
+ (NSString*) getWifiName;
+ (BOOL) getselectedPCVerified;
+ (BOOL) getselectedTVVerified;
+ (void) setselectedTVVerified:(BOOL)verified;
+ (void) setselectedPCVerified:(BOOL)verified;
+ (BOOL)isPCMacContains:(NSString*)mac;
+ (NSMutableDictionary*) getPCMacs;
+ (NSMutableDictionary*) getTVMacs;
+ (void) addPCMac:(NSString*) mac Code:(NSString*)code;
+ (void) addTVMac:(NSString*) mac Code:(NSString*)code;
+ (void) removePCMac:(NSString*)mac;
+ (void) removeTVMac:(NSString*)mac;
+ (BOOL) getselectedPCOnline;
+ (BOOL) getselectedTVOnline;
+ (BOOL) getAccessibilityIsOpen;
+ (void)setmNetWorkState:(AFNetworkReachabilityStatus) mNetWorkState1;
+ (AFNetworkReachabilityStatus)getmNetWorkState;
+ (void)initTVPCIP;
+ (AFNetworkReachabilityManager*) getappnetmanager;
+ (void)setappnetmanager:(AFNetworkReachabilityManager*) manager1;
+ (void) verifyLastPCMac;
+ (void) verifyLastTVMac;
+ (void) startStateRefreshTimer;
+ (void) startCheckIsNewVersionExist;
+ (NSMutableArray<IPInforBean*>*) getTVIPInforList;
+ (BOOL)isTVMacContains:(NSString*) mac ;
+ (Update_ReceiveMsgBean*) getReceiveMsgBean;
+ (void) setReceiveMsgBean:(Update_ReceiveMsgBean*) rec;
+ (NSTimer*) getversionCheckTimer;
+ (MyUIApplication*) getInstance;
- (void) addUiViewController:(UIViewController*) uiviewcontroller;
- (void) closeAll;
+ (void)changeSelectedTVName:(NSString*) newName;
+ (void)changeSelectedPCName:(NSString*) newName;
+ (NSDictionary*) parse:(NSString*) JsonString;
+ (void) verifyLastTVMac;
+ (NSString*) getIPStr ;
+ (NSString *)GetInetAddress:(NSString *)domain;
+ (NSString*) getAREAPARTY_NET;
+ (void) setAREAPARTY_NET:(NSString*)net;
+(NSString*) getdomain;
+(NSString*) getdomain1;
+ (void)getPcAreaPartyPath;
@end
