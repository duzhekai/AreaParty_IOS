//
//  FillingIPInforList.h
//  AreaParty
//
//  Created by 杜哲凯 on 2017/12/18.
//  Copyright © 2017年 杜哲凯. All rights reserved.
//
#import "IPAddressConst.h"
#import <Foundation/Foundation.h>
#import "IPInforBean.h"
#import "IPInforMessageBean.h"
#import "GCDAsyncUdpSocket.h"
#import "AllStatisticsMsgBean.h"
#import "PreferenceUtil.h"
@interface FillingIPInforList : NSObject
+(void) changePCNickName:(NSString*)name Mac:(NSString*)mac;
+(void) changeTVNickName:(NSString*)name Mac:(NSString*)mac;
+ (void) addPCInfor:(IPInforBean*) pcIpInfor;
+ (void) addTVInfor:(IPInforBean*) tvIpInfor;
+(NSThread*)getThreadBroadCast;
+(NSThread*)getThreadReceiveMessage;
+(NSString*) getWifiName;
+(NSString*) getIpStr;
+(NSMutableArray<IPInforBean*>*)getTVList;
+(NSMutableArray<IPInforBean*>*)getPCList_B;
+(NSMutableArray<IPInforBean*>*)getPCList_Y;
+(void)setCloseSignal:(BOOL)closeSignal1;
+(BOOL)getCloseSingnal;
+(void)startBroadCastAndListenTime1:(int)time1 Time2:(int)time2;
+(NSThread*) getStatisticThread;
+(NSString*) getwifiname;
@end
