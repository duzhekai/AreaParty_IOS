//
//  FillingIPInforList.m
//  AreaParty
//
//  Created by 杜哲凯 on 2017/12/18.
//  Copyright © 2017年 杜哲凯. All rights reserved.
//
#import <ifaddrs.h>
#import <arpa/inet.h>
#import "FillingIPInforList.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import "MyUIApplication.h"
#import "YYModel.h"
#import "OrderConst.h"
#import "LoginViewController.h"
#import "StatisticsMsgBean.h"
#import <arpa/inet.h>
static int intervalTime1;
static int intervalTime2;
static NSMutableArray<IPInforBean*>* TVList;
static NSMutableArray<IPInforBean*>* PCList_B;
static NSMutableArray<IPInforBean*>* PCList_Y;
static NSString* data;
static NSString* ipStr;      // 该手机在wifi下的IP
static NSString* wifiName;   // 当前wifi名称
static NSString* ipbroadCastStr;
static NSThread* threadBroadCast;
static NSThread* threadReceiveMessage;
static NSThread* threadSendStaticMsgToServer;
static BOOL closeSignal = NO;
static BOOL isNewPC_YList = NO;
static BOOL isNewTVList= NO;


@implementation FillingIPInforList
+(NSThread*)getThreadBroadCast{
    return threadBroadCast;
}
+(NSThread*)getThreadReceiveMessage{
    return threadReceiveMessage;
}
+(NSString*) getWifiName{
    return wifiName;
}
+(NSString*) getIpStr{
    return ipStr;
}
+(NSMutableArray<IPInforBean*>*)getTVList{
    return TVList;
}
+(NSMutableArray<IPInforBean*>*)getPCList_B{
    return PCList_B;
}
+(NSMutableArray<IPInforBean*>*)getPCList_Y{
    return PCList_Y;
}
+(void)setCloseSignal:(BOOL)closeSignal1{
    closeSignal = closeSignal1;
}
+(BOOL)getCloseSingnal{
    return closeSignal;
}
+(void)startBroadCastAndListenTime1:(int)time1 Time2:(int)time2{
    intervalTime1 = time1;
    intervalTime2 = time2;
    [self initParam];
    [threadBroadCast start];
    [threadReceiveMessage start];
}
+(void)initParam{
    TVList = [[NSMutableArray alloc] init];
    PCList_Y = [[NSMutableArray alloc] init];
    PCList_B = [[NSMutableArray alloc] init];
    [TVList removeAllObjects];
    [PCList_Y removeAllObjects];
    [PCList_B removeAllObjects];
    IPInforMessageBean* message = [[IPInforMessageBean alloc]init];
    wifiName = [self getwifiname];
    ipStr = [self getCurrentLocalIP];
    ipbroadCastStr = [self getCurrentBroadIP];
    NSMutableArray<IPInforBean*>* temp = [[NSMutableArray alloc] init];
    [temp addObject:[[IPInforBean alloc] initWithHost:ipStr andPort:IPAddressConst_PHONEBROADCASTRECEIVEPORT_B andFunc:@"" andLaunch_time_id:[MyUIApplication getLaunchTimeId]]];
    message.source = OrderConst_ip_phone_source;
    message.type = OrderConst_ip_default_type;
    message.param = temp;
    data = [message yy_modelToJSONString];
    threadBroadCast = [[NSThread alloc] initWithTarget:self selector:@selector(runBroadCast) object:nil];
    threadReceiveMessage = [[NSThread alloc] initWithTarget:self selector:@selector(runReceiveMessage) object:nil];
    threadSendStaticMsgToServer =[[NSThread alloc] initWithTarget:self selector:@selector(runSendStatistic2Server) object:nil];
}
+(NSThread*) getStatisticThread{
    return threadSendStaticMsgToServer;
}
+(void)runBroadCast{
    GCDAsyncUdpSocket* sendUdpSocket =[[GCDAsyncUdpSocket alloc] initWithDelegate:[UIApplication sharedApplication].delegate delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    //启用广播
    [sendUdpSocket enableBroadcast:YES error:nil];
    while(!closeSignal){
        int times = 10;
        while(times > 0 && (!closeSignal)) {
            NSData *senddata = [data dataUsingEncoding:NSUTF8StringEncoding];
            NSString *host = ipbroadCastStr;
            uint16_t port = IPAddressConst_PHONEBROADCASTSEND_B;//通过端口监测
            [sendUdpSocket sendData:senddata toHost:host port:port withTimeout:-1 tag:100];
            times--;
           [NSThread sleepForTimeInterval:intervalTime1/1000];
        }
        [NSThread sleepForTimeInterval:intervalTime2/1000];
    }
    [sendUdpSocket close];
}
+(void)runSendStatistic2Server{
    NSString* type = @"app";
    NSString* userId = [LoginViewController getuserId];
    NSString* id_ = [LoginViewController getuserMac];
    NSString* mac = id_;
    long time =[[NSDate date] timeIntervalSince1970]*1000;
    NSMutableArray<StatisticsMsgBean*>* pcMsg = [[NSMutableArray alloc] init];
    NSMutableArray<StatisticsMsgBean*>* tvMsg = [[NSMutableArray alloc] init];
    [NSThread sleepForTimeInterval:10];
    GCDAsyncUdpSocket* sendUdpSocket =[[GCDAsyncUdpSocket alloc] initWithDelegate:[UIApplication sharedApplication].delegate delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    //启用广播
    [sendUdpSocket enableBroadcast:YES error:nil];
    while(!closeSignal){
        [tvMsg removeAllObjects];
        [pcMsg removeAllObjects];
        for(IPInforBean* temp in TVList){
            [tvMsg addObject:[[StatisticsMsgBean alloc] initWithType:@"tv" andID:temp.name andMac:temp.mac andtime:time]];
        }
        for (IPInforBean* temp in PCList_Y) {
            [pcMsg addObject:[[StatisticsMsgBean alloc] initWithType:@"pc" andID:temp.name andMac:temp.mac andtime:time]];
        }
        NSString* allMsgStr = [[[AllStatisticsMsgBean alloc] initWithType:type andUserId:userId andid:id_ andMac:mac andTime:time andpcMsg:pcMsg andtvMsg:tvMsg] yy_modelToJSONString];
        //发送报文
        NSData *senddata = [allMsgStr dataUsingEncoding:NSUTF8StringEncoding];
        NSString *host = IPAddressConst_statisticServer_ip;
        uint16_t port = IPAddressConst_statisticServer_port;//通过端口监测
        [sendUdpSocket sendData:senddata toHost:host port:port withTimeout:-1 tag:200];
        [NSThread sleepForTimeInterval:20*60];
    }
    [sendUdpSocket close];
}
+(void)runReceiveMessage{
    int serversocket;
    int clientsocket;
    IPInforMessageBean* receivedObject;
    Byte rev[1000];
    ssize_t len;
    serversocket = socket(AF_INET,SOCK_STREAM, 0);
    struct sockaddr_in server_sockaddr;
    struct sockaddr_in client_addr;
    socklen_t length = sizeof(client_addr);
    server_sockaddr.sin_family = AF_INET;
    server_sockaddr.sin_port = htons(IPAddressConst_PHONEBROADCASTRECEIVEPORT_B);
    server_sockaddr.sin_addr.s_addr = htonl(INADDR_ANY);
    if(bind(serversocket,(struct sockaddr *)&server_sockaddr,sizeof(server_sockaddr))==-1)
    {
        NSLog(@"bind error");
    }
    ///listen，成功返回0，出错返回-1
    if(listen(serversocket,10) == -1)
    {
        NSLog(@"listen error");
        exit(1);
    }
    while (!closeSignal) {
        clientsocket = accept(serversocket,(struct sockaddr*)&client_addr, &length);
        if(clientsocket<0)
        {
            NSLog(@"connect error");
            exit(1);
        }
        memset(rev,0,sizeof(rev));
        if((len = recv(clientsocket,rev,sizeof(rev),0))>0){
            NSData *adata = [[NSData alloc] initWithBytes:rev length:len];
            NSString* tempMessageStr = [[NSString alloc]initWithData:adata encoding:NSUTF8StringEncoding];
            receivedObject = [IPInforMessageBean yy_modelWithJSON:tempMessageStr];
            [self parse:receivedObject];
            [self sendIPInfor];
        }
        close(clientsocket);
    }
    close(serversocket);
}
+(BOOL)isIPInforContained:(IPInforBean*) IPinfor List:(NSMutableArray<IPInforBean*>*)list{
    for(int i = 0; i < list.count; i++) {
        IPInforBean* temp = [list objectAtIndex:i];
        if([temp.ip isEqualToString:IPinfor.ip] && temp.port == IPinfor.port && [temp.launch_time_id isEqualToString:IPinfor.launch_time_id])
            return true;
        if([temp.ip isEqualToString:IPinfor.ip] && temp.port == IPinfor.port && ![temp.launch_time_id isEqualToString:IPinfor.launch_time_id]) {
            [list removeObjectAtIndex:i];
            return false;
        }
    }
    return false;
}
+(void) parse:(IPInforMessageBean*) object{
    if(object != nil){
        if([object.source isEqualToString:OrderConst_ip_TV_source]){
            for (IPInforBean* IPinfor in object.param) {
                if(![self isIPInforContained:IPinfor List:TVList] ) {
                    IPinfor.nickName = IPinfor.name;
                    NSString* name = [[[PreferenceUtil alloc] init]readKey:IPinfor.mac];
                    if(name!= nil && ![name isEqualToString:@""]){IPinfor.nickName = name;}
                    if([MyUIApplication getSelectedTVIP] != nil
                       && [[MyUIApplication getSelectedTVIP].mac isEqualToString:IPinfor.mac]
                       && ![[MyUIApplication getSelectedTVIP].name isEqualToString:IPinfor.name]){
                        IPInforBean* newSelectedTV = [[IPInforBean alloc] initWithHost:IPinfor.ip andPort:IPinfor.port andFunc:IPinfor.function andLaunch_time_id:IPinfor.launch_time_id];
                        newSelectedTV.name = IPinfor.name;
                        newSelectedTV.nickName = [MyUIApplication getSelectedTVIP].nickName;
                        newSelectedTV.mac = IPinfor.mac;
                        [MyUIApplication setSelectedTVIP:newSelectedTV];
                        [[[PreferenceUtil alloc] init] writeKey:@"lastChosenTV" Value:[newSelectedTV yy_modelToJSONString]];
                    }
                    [TVList addObject:IPinfor];
                    isNewTVList = YES;
                }
            }
        }else if([object.source isEqualToString:OrderConst_ip_PC_B_source]){
            for (IPInforBean* IPinfor in object.param) {
                if(![self isIPInforContained:IPinfor List:PCList_B]) {
                    [PCList_B addObject:IPinfor];
                }
            }
        }else if([object.source isEqualToString:OrderConst_ip_PC_Y_source]){
            for (IPInforBean* IPinfor in object.param) {
                if(![self isIPInforContained:IPinfor List:PCList_Y]) {
                    IPinfor.nickName = IPinfor.name;
                    NSString* name = [[[PreferenceUtil alloc]init]readKey:IPinfor.mac];
                    if(name != nil && ![name isEqualToString:@""]){IPinfor.nickName = name;}
                    [PCList_Y addObject:IPinfor];
                    isNewPC_YList = true;
                }
            }
        }
    }
}
+(void)sendIPInfor{
    if((isNewTVList || isNewPC_YList) && TVList.count > 0 && PCList_Y.count > 0){
        IPInforMessageBean* message = [[IPInforMessageBean alloc] init];
        message.source = OrderConst_ip_phone_source;
        message.type = OrderConst_ip_default_type;
        message.param = TVList;
        NSString* TVMessageStr = [message yy_modelToJSONString];
        message.param = PCList_Y;
        NSString* PC_YMessageStr = [message yy_modelToJSONString];
        for(IPInforBean* IPInfor in TVList) {
            Base* actionSocket = [[Base alloc]initWithHost:IPInfor.ip andPort:IPInfor.port];
            [actionSocket writeToServer:actionSocket.outputStream arrayBytes:[PC_YMessageStr dataUsingEncoding:NSUTF8StringEncoding]];
            [actionSocket close];
            NSLog(@"pushTV:发送TV信息:%@",PC_YMessageStr);
        }
        for(IPInforBean* IPInfor in PCList_Y) {
            Base* actionSocket = [[Base alloc]initWithHost:IPInfor.ip andPort:IPInfor.port];
            [actionSocket writeToServer:actionSocket.outputStream arrayBytes:[TVMessageStr dataUsingEncoding:NSUTF8StringEncoding]];
            [actionSocket close];
            NSLog(@"pushTV:发送PC信息:%@",TVMessageStr);
        }
        isNewTVList = NO;
        isNewPC_YList = NO;
    }
}
+(void) changePCNickName:(NSString*)name Mac:(NSString*)mac{
    for(int i = 0; i < PCList_Y.count; ++i)
        if([[PCList_Y objectAtIndex:i].mac isEqualToString:mac])
            [PCList_Y objectAtIndex:i].nickName =name;
}
+(void) changeTVNickName:(NSString*)name Mac:(NSString*)mac{
    for(int i = 0; i < TVList.count; ++i)
        if([[TVList objectAtIndex:i].mac isEqualToString:mac])
            [TVList objectAtIndex:i].nickName =name;
}
+ (void) addPCInfor:(IPInforBean*) pcIpInfor {
    if(![self isIPInforContained:pcIpInfor List:PCList_Y]){
        [PCList_Y addObject:pcIpInfor];
        isNewPC_YList = YES;
    }
}
+ (void) addTVInfor:(IPInforBean*) tvIpInfor {
    if(![self isIPInforContained:tvIpInfor List:TVList]){
        [TVList addObject:tvIpInfor];
        isNewTVList = YES;
    }
}
+(NSString*) getwifiname{
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    NSLog(@"Supported interfaces: %@", ifs);
    id info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        NSLog(@"%@ => %@", ifnam, info);
        if (info && [info count]) { break; }
    }
    NSString* wifiname =  [(NSDictionary*)info objectForKey:@"SSID"];
    return wifiname;
}

+ (nullable NSString*)getCurrentLocalIP
{
    NSString *address = nil;
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}
+ (nullable NSString*)getCurrentBroadIP
{
    NSString *address = nil;
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    struct in_addr addr;
                    addr.s_addr = ((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr.s_addr| 0xFF000000;
                    address = [NSString stringWithUTF8String:inet_ntoa(addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}
@end
