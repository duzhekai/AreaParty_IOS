//
//  MyUIApplication.m
//  AreaParty
//
//  Created by 杜哲凯 on 2017/12/4.
//  Copyright © 2017年 杜哲凯. All rights reserved.
//

#import "MyUIApplication.h"
@interface MyUIApplication ()
@end
static AFNetworkReachabilityStatus mNetWorkState;
static NSMutableArray<SharedflieBean*> * mySharedFiles=nil;
static MyUIApplication* instance;
static NSString* launch_time_id;
static BOOL selectedPCOnline = NO;
static BOOL selectedTVOnline = NO;
static BOOL selectedPCVerified = NO;
static BOOL selectedTVVerified = NO;
static IPInforBean* selectedTVIP = nil;
static IPInforBean* selectedPCIP = nil;     // 用于存储通信使用TV和PC
static NSMutableDictionary* TVMacs;
static NSMutableDictionary* PCMacs;// 用于存储之前连接成功过的TV、PC
static BOOL AccessibilityIsOpen = NO;
static NSTimer* stateRefreshTimer;
static NSTimer* versionCheckTimer;
static AFNetworkReachabilityManager* appnetmanager;
static Update_ReceiveMsgBean* receiveMsgBean;
@implementation MyUIApplication
+(void) addMySharedFlies:(SharedflieBean*)mysharedFiles{
    if(mySharedFiles == nil)
        mySharedFiles = [[NSMutableArray alloc] init];
    [mySharedFiles addObject:mysharedFiles];
}
+(NSString*)getLaunchTimeId{ return launch_time_id;}

+(NSMutableArray<SharedflieBean*> *) getmySharedFiles{
    if(mySharedFiles == nil)
        mySharedFiles = [[NSMutableArray alloc]init];
    return mySharedFiles;
}
+ (void) setlaunchtimeid:(NSString*) timeid{
    launch_time_id = timeid;
}
+ (BOOL) getselectedPCOnline{
    return selectedPCOnline;
}
+ (BOOL) getselectedTVOnline{
    return selectedTVOnline;
}

+ (IPInforBean*) getSelectedPCIP{
    return selectedPCIP;
}
+ (void) setSelectedPCIP:(IPInforBean*)selectedPCIP1{
    selectedPCIP = selectedPCIP1;
    selectedPCOnline = YES;
    [[MyConnector sharedInstance] initial:selectedPCIP.ip];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"selectedPCChanged" object:nil userInfo:[NSDictionary dictionaryWithObject:[[SelectedDeviceChangedEvent alloc] initWithOnline:selectedPCOnline andDevice:selectedPCIP] forKey:@"data"]];
    [self getPcAreaPartyPath];
    
}
+ (void) addPCMac:(NSString*) mac Code:(NSString*) code{
    if(PCMacs == nil){
        PCMacs = [[NSMutableDictionary alloc] init];
    }
    [PCMacs setObject:code forKey:mac];
    NSString* str = [PCMacs yy_modelToJSONString];
    [[[PreferenceUtil alloc] init] writeKey:@"PCMACS" Value:str];
}
+ (void)addTVMac:(NSString*) mac Code:(NSString*) code{
    if(TVMacs == nil){
        TVMacs = [[NSMutableDictionary alloc] init];
    }
    [TVMacs setObject:code forKey:mac];
    NSString* str = [TVMacs yy_modelToJSONString];
    [[[PreferenceUtil alloc] init] writeKey:@"TVMACS" Value:str];
}
+ (void)getPcAreaPartyPath{
    if (selectedPCOnline && ![selectedPCIP.ip isEqualToString:@""] && selectedPCIP.ip !=nil){
        @try {
            RequestFormat* request = [[RequestFormat alloc] init];
            request.name = OrderConst_GET_AREAPARTY_PATH;
            request.command = @"";
            request.param = @"";
            const NSString* requestString = [request yy_modelToJSONString];
            NSLog(@"GET_AREAPARTY_PATH:requestString:%@",requestString);
            [[[NSThread alloc] initWithBlock:^(void){
                NSString* msgReceived = [[MyConnector sharedInstance] getActionStateMsg:requestString];
                if([msgReceived isEqualToString:@""]){
                    NSLog(@"GET_AREAPARTY_PATH:msgReceived is null");
                }
                @try {
                    NSDictionary* jsonObject = [self dictionaryWithJsonString:msgReceived];
                    NSLog(@"GET_AREAPARTY_PATH:msgReceived:%@",msgReceived);
                    NSString* path = [jsonObject objectForKey:@"message"];
                    if([path isKindOfClass:[NSNull class]]){
                        path = @"null";
                    }
                    NSLog(@"GET_AREAPARTY_PATH:path:%@",path);
                    if(path!=nil && ![path isEqualToString:@""]){
                        [RemoteDownloadActivityViewController setbtFilesPath:[path stringByAppendingString:@"BtFiles\\"]];
                        NSLog(@"GET_AREAPARTY_PATH:RemoteDownloadActivity.btFilesPath:%@",[RemoteDownloadActivityViewController getbtFilesPath]);
                    }
                } @catch (NSException *exception) {
                    NSLog(@"%@",exception);
                }
            }]start];
        } @catch (NSException *exception) {
            NSLog(@"%@",exception);
            NSLog(@"GET_AREAPARTY_PATH exception!");
        }
    }
}
+ (void) verifyLastPCMac{
    if(selectedPCIP != nil && ![selectedPCIP.ip isEqualToString:@""] && PCMacs != nil) {
        const NSString* IP = selectedPCIP.ip;
        const int port = selectedPCIP.port;
        const NSString* code = [PCMacs objectForKey:selectedPCIP.mac];
        if(code != nil && ![code isEqualToString:@""]) {
            [NSThread detachNewThreadWithBlock:^(void){
                NSString* cmdStr = [[CommandUtil createVerifyPCCommand:code] yy_modelToJSONString];
                NSString* dataRe = @"";
                CFReadStreamRef readStream;
                CFWriteStreamRef writeStream;
                NSInputStream* inputStream;
                NSOutputStream* outputStream;
                Byte outBytes[8192];
                @try {
                    CFStreamCreatePairWithSocketToHost(NULL,(__bridge CFStringRef)IP,port,&readStream,&writeStream);
                    inputStream = (__bridge NSInputStream*)(readStream);
                    outputStream = (__bridge NSOutputStream*)(writeStream);
                    [inputStream open];
                    [outputStream open];
                    NSData* cmdStrdata = [cmdStr dataUsingEncoding:NSUTF8StringEncoding];
                    [outputStream write:[cmdStrdata bytes] maxLength:[cmdStrdata length]];
                    NSInteger len = [inputStream read:outBytes maxLength:8192];
                    dataRe = [[NSString alloc] initWithData:[NSData dataWithBytes:outBytes length:len] encoding:NSUTF8StringEncoding];
                    if([dataRe length]>0) {
                        ReceivedActionMessageFormat* receivedMsg = [ReceivedActionMessageFormat yy_modelWithJSON:dataRe];
                        if(receivedMsg.status == OrderConst_success) {
                            if([receivedMsg.data isEqualToString:@"true"])
                                selectedPCVerified = true;
                            else selectedPCVerified = false;
                        }
                    } else {
                        selectedPCVerified = false;
                    }
                } @catch (NSException *exception) {
                    selectedPCVerified = false;
                }
            }];
        }
    }
}
+ (void) verifyLastTVMac{
    if(selectedTVIP != nil && ![selectedTVIP.ip isEqualToString:@""] && TVMacs != nil) {
        const NSString* IP = selectedTVIP.ip;
        const int port = selectedTVIP.port;
        const NSString* code = [TVMacs objectForKey:selectedTVIP.mac];
        if(code != nil && ![code isEqualToString:@""]) {
            [NSThread detachNewThreadWithBlock:^(void){
                NSString* cmdStr = [[[CommandUtil createVerifyTVCommand:code] yy_modelToJSONString]stringByAppendingString:@"\n"];
                NSString* dataRe = @"";
                CFReadStreamRef readStream;
                CFWriteStreamRef writeStream;
                NSInputStream* inputStream;
                NSOutputStream* outputStream;
                Byte outBytes[8192];
                @try {
                    CFStreamCreatePairWithSocketToHost(NULL,(__bridge CFStringRef)IP,port,&readStream,&writeStream);
                    inputStream = (__bridge NSInputStream*)(readStream);
                    outputStream = (__bridge NSOutputStream*)(writeStream);
                    [inputStream open];
                    [outputStream open];
                    NSData* cmdStrdata = [cmdStr dataUsingEncoding:NSUTF8StringEncoding];
                    [outputStream write:[cmdStrdata bytes] maxLength:[cmdStrdata length]];
                    NSInteger len = [inputStream read:outBytes maxLength:8192];
                    dataRe = [[NSString alloc] initWithData:[NSData dataWithBytes:outBytes length:len] encoding:NSUTF8StringEncoding];
                    if([dataRe isEqualToString:@"true"]) {
                        selectedTVVerified = true;
                    } else {
                        selectedTVVerified = false;
                    }
                } @catch (NSException *exception) {
                    selectedTVVerified = false;
                }
            }];
        }
    }
}
/**
 * <summary>
 *  开启定时器,定时检测选中的TV、PC是否可用
 * </summary>
 */
+ (void) startStateRefreshTimer{
    stateRefreshTimer = [NSTimer scheduledTimerWithTimeInterval:5 repeats:YES block:^(NSTimer* timer){
        [NSThread detachNewThreadWithBlock:^(void){
            BOOL PCOnline = false;
            BOOL TVOnline = false;
            if(selectedPCIP != nil && ![selectedPCIP.ip isEqualToString:@""]) {
                GCDAsyncSocket* client = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
                NSError *error = nil;
                [client connectToHost:selectedPCIP.ip onPort:selectedPCIP.port error:&error];
                [NSThread sleepForTimeInterval:2];
                BOOL state = [client isConnected];
                if(state){
                    NSLog(@"stateChange:连接PC成功");
                    PCOnline = true;
                    [FillingIPInforList addPCInfor:selectedPCIP];
                    if ([RemoteDownloadActivityViewController getbtFilesPath]==nil ){[self getPcAreaPartyPath];}
                    if (!selectedPCVerified){
                        [self verifyLastPCMac];
                    }
                }
                else{
                    NSLog(@"stateChange:连接PC失败");
                    PCOnline = false;
                }
                [client disconnect];
            }
            if(selectedTVIP != nil && ![selectedTVIP.ip isEqualToString:@""]) {
                GCDAsyncSocket* client = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
                NSError *error = nil;
                [client connectToHost:selectedTVIP.ip onPort:selectedTVIP.port error:&error];
                [NSThread sleepForTimeInterval:2];
                BOOL state = [client isConnected];
                if(state){
                    //TODO:10.18.2017 告知app当前无障碍服务情况
                    NSInputStream* inputStream= (__bridge NSInputStream*)[client readStream];
                    NSOutputStream* outputStream= (__bridge NSOutputStream*)[client writeStream];
                    [inputStream open];
                    [outputStream open];
                    NSString* cmd= [[CommandUtil createCheckTvAccessibilityCommand] yy_modelToJSONString];
                    NSData* cmddata = [cmd dataUsingEncoding:NSUTF8StringEncoding];
                    [outputStream write:[cmddata bytes] maxLength:[cmddata length]];
                    Byte buf[100];
                    memset(buf,0, 100);
                    NSInteger length;
                    int count = 0;
                    NSString* data;
                    while((length = [inputStream read:buf maxLength:100])==0){
                        if(++count>=10){
                            data = @"false";
                            break;
                        }
                    }
                    if(count<10){
                    data = [[NSString alloc] initWithData:[NSData dataWithBytes:buf length:length] encoding:NSUTF8StringEncoding];
                    }
                    NSLog(@"getdta:%@",data);
                    if(data!=nil&& ![data isEqualToString:@""]){
                        if([data isEqualToString:@"true"]){
                            AccessibilityIsOpen = YES;
                        }else {
                            AccessibilityIsOpen = NO;
                        }
                    }
                    [inputStream close];
                    [outputStream close];
                    TVOnline = true;
                    [FillingIPInforList addTVInfor:selectedTVIP];
                    NSLog(@"stateChange:连接TV成功");
                    if(selectedPCIP!=nil){
                        [TVAppHelper currentPcInfo2TV];
                    }
                    if (!selectedTVVerified){
                        [self verifyLastTVMac];
                    }
                }
                else{
                    TVOnline = false;
                    NSLog(@"stateChange:连接TV失败");
                }
                [client disconnect];
                }
            selectedPCOnline = PCOnline;
            selectedTVOnline = TVOnline;
            NSLog(@"stateChange:发出消息");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"selectedDeviceStateChanged" object:nil userInfo:[NSDictionary dictionaryWithObject:[[TVPCNetStateChangeEvent alloc] initWithTVOnline:TVOnline andPCOnline:PCOnline] forKey:@"data"]];
        }];
    }];
    [stateRefreshTimer fire];
}
- (NSString*) getVersion {
    NSDictionary* infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSLog(@"%@",[infoDictionary objectForKey:@"CFBundleShortVersionString"]);
    return [infoDictionary objectForKey:@"CFBundleShortVersionString"];
}
/**
 * <summary>
 *  开启定时器,定时检测是否有新版本
 * </summary>
 */
+ (void) startCheckIsNewVersionExist {
    NSString* version = [[MyUIApplication getInstance] getVersion];
    versionCheckTimer = [NSTimer scheduledTimerWithTimeInterval:5 repeats:YES block:^(NSTimer* timer){
    [NSThread detachNewThreadWithBlock:^(void){
        NSString* sendStr = [[[Update_SendMsgBean alloc] initWithType:@"app" Version:version] yy_modelToJSONString];
        @try {
            GCDAsyncUdpSocket* sendUdpSocket =[[GCDAsyncUdpSocket alloc] initWithDelegate:[UIApplication sharedApplication].delegate delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
            [sendUdpSocket sendData:[sendStr dataUsingEncoding:NSUTF8StringEncoding] toHost:IPAddressConst_statisticServer_ip port:IPAddressConst_checkNewVersion_port withTimeout:-1 tag:200];
            [sendUdpSocket beginReceiving:nil];
            NSLog(@"MyApplication,检查更新的消息%@",sendStr);
        } @catch (NSException* e) {
            NSLog(@"%@",e);
        }
        }];
    }];
    [versionCheckTimer fire];
}
+ (void)setSelectedTVIP:(IPInforBean*)selectedTVIP1{
    selectedTVIP = selectedTVIP1;
    selectedTVOnline= YES;
    //eventbus
    [[NSNotificationCenter defaultCenter] postNotificationName:@"selectedTVChanged" object:nil userInfo:[NSDictionary dictionaryWithObject:[[SelectedDeviceChangedEvent alloc] initWithOnline:selectedTVOnline andDevice:selectedTVIP] forKey:@"data"]];
}
+ (IPInforBean*) getSelectedTVIP{
    return selectedTVIP;
}
+ (NSString*) getWifiName {
    return [FillingIPInforList getwifiname];
}
+ (NSMutableArray<IPInforBean*>*) getPC_YInforList{
    return [FillingIPInforList getPCList_Y];
}
+ (BOOL)getselectedPCVerified{
    return selectedPCVerified;
}
+ (void) setselectedPCVerified:(BOOL)verified{
    selectedPCVerified = verified;
}
+ (BOOL) getselectedTVVerified{
    return selectedTVVerified;
}
+(void) setselectedTVVerified:(BOOL)verified{
    selectedTVVerified = verified;
}
+ (BOOL)isPCMacContains:(NSString*)mac {
    if (PCMacs != nil){
        return [PCMacs objectForKey:mac]==nil?NO:YES;
    }
    return NO;
}
+ (BOOL)isTVMacContains:(NSString*) mac {
    if (TVMacs!=nil){
        return [TVMacs objectForKey:mac]==nil?NO:YES;
    }
    return false;
}
+ (void) removePCMac:(NSString*)mac {
    if(PCMacs != nil) {
        [PCMacs removeObjectForKey:mac];
    }
    NSString* str = [PCMacs yy_modelToJSONString];
    [[[PreferenceUtil alloc]init] writeKey:@"PCMACS" Value:str];
}
+ (void) removeTVMac:(NSString*)mac {
    if(TVMacs != nil) {
        [TVMacs removeObjectForKey:mac];
    }
    NSString* str = [TVMacs yy_modelToJSONString];
    [[[PreferenceUtil alloc]init] writeKey:@"TVMACS" Value:str];
}
+(NSMutableDictionary*) getPCMacs{
    return PCMacs;
}
+(NSMutableDictionary*) getTVMacs{
    return TVMacs;
}
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                      error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
+ (BOOL) getAccessibilityIsOpen{
    return AccessibilityIsOpen;
}
+ (NSTimer*) getversionCheckTimer{
    return versionCheckTimer;
}
/**
 * <summary>
 *  初始化默认选中的PC和TV地址信息
 * </summary>
 */
+ (void)initTVPCIP{
    NSString* PCMacsStr = [[[PreferenceUtil alloc] init] readKey:@"PCMACS"];//连接时的密码
    NSString* TVMacsStr = [[[PreferenceUtil alloc] init] readKey:@"TVMACS"];//连接时的密码
    NSString* TVString =  [[[PreferenceUtil alloc] init] readKey:@"lastChosenTV"];
    NSString* PCString =  [[[PreferenceUtil alloc] init] readKey:@"lastChosenPC"];
    
    NSLog(@"PCMacsStr:%@,%@",PCMacsStr,PCString);
    NSLog(@"TVMacsStr:%@,%@",TVMacsStr,TVString);
    if(PCMacsStr != nil && ![PCMacsStr isEqualToString:@""]){
        PCMacs = [[NSMutableDictionary alloc] init];
        [PCMacs setDictionary:[NSJSONSerialization JSONObjectWithData:[PCMacsStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil]];
    }
    else{
        PCMacs = [[NSMutableDictionary alloc] init];
    }
    if(TVMacsStr != nil && ![TVMacsStr isEqualToString:@""]){
        TVMacs = [[NSMutableDictionary alloc] init];
        [TVMacs setDictionary:[NSJSONSerialization JSONObjectWithData:[TVMacsStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil]];
    }
    else{
        TVMacs = [[NSMutableDictionary alloc] init];
    }
    if (TVString != nil && ![TVString isEqualToString:@""]) {
        selectedTVIP = [IPInforBean yy_modelWithJSON:TVString];
    }
    if (PCString != nil && ![PCString isEqualToString:@""]) {
        selectedPCIP = [IPInforBean yy_modelWithJSON:PCString];
        [[MyConnector sharedInstance] initial:selectedPCIP.ip];
        [self getPcAreaPartyPath];
    }
    if([MyUIApplication getSelectedPCIP] != nil &&[MyUIApplication getSelectedTVIP] != nil){
        [TVAppHelper currentPcInfo2TV];
    }
}
/**
 * <summary>
 *  获取当前接收到的TV地址列表
 * </summary>
 */
+ (NSMutableArray<IPInforBean*>*) getTVIPInforList{
    return [FillingIPInforList getTVList];
}
/**
 * <summary>
 *  获取网络状态变量
 * </summary>
 * <returns>网络状态</returns>
 */
+(AFNetworkReachabilityStatus)getmNetWorkState{
    return mNetWorkState;
}
/**
 * <summary>
 *  设置网络状态
 * </summary>
 * <param name="mNetWorkState">网络状态</param>
 */
+ (void)setmNetWorkState:(AFNetworkReachabilityStatus) mNetWorkState1{
    mNetWorkState = mNetWorkState1;
}
+ (AFNetworkReachabilityManager*) getappnetmanager{
    return appnetmanager;
}
+ (void)setappnetmanager:(AFNetworkReachabilityManager*) manager1{
    appnetmanager = manager1;
}
/**
 * <summary>
 *  获取application的单例
 * </summary>
 * <returns>MyApplication</returns>
 */
+ (MyUIApplication*) getInstance {
    return [MyUIApplication sharedApplication];
}
/**
 * <summary>
 * 获取包含新版本信息的bean
 * </summary>
 * <returns>Update_ReceiveMsgBean</returns>
 */
+ (Update_ReceiveMsgBean*) getReceiveMsgBean{
    if(receiveMsgBean == nil){
        receiveMsgBean = [[Update_ReceiveMsgBean alloc] initWithisNew:YES version:@"" url:@""];
    }
    return receiveMsgBean;
}
+ (void) setReceiveMsgBean:(Update_ReceiveMsgBean*) rec{
    if(receiveMsgBean == nil){
        receiveMsgBean = [[Update_ReceiveMsgBean alloc] initWithisNew:YES version:@"" url:@""];
    }
     receiveMsgBean = rec;
}
/**
 * <summary>
 *  添加activity到Application的list中
 * </summary>
 * <param name="activity">当前创建的activity</param>
 */
- (void) addUiViewController:(UIViewController*) uiviewcontroller {
    if(!_activities){
        _activities = [[NSMutableArray alloc] init];
    }
    [_activities addObject:uiviewcontroller];
}

- (void) closeAll{
    NSArray* test = [[_activities reverseObjectEnumerator] allObjects];
    for(UIViewController* activity in test){
        
        [activity dismissViewControllerAnimated:YES completion:nil];
    }
}
+ (void)changeSelectedTVName:(NSString*) newName {
    if(newName != nil && ![newName isEqualToString:selectedTVIP.nickName]) {
        selectedTVIP.nickName = newName;
        [FillingIPInforList changeTVNickName:newName Mac:selectedTVIP.mac];
        NSString* tvJsonString = [selectedTVIP yy_modelToJSONString];
        [[[PreferenceUtil alloc] init] writeKey:@"lastChosenTV" Value:tvJsonString];
        [[[PreferenceUtil alloc] init] writeKey:selectedTVIP.mac Value:newName];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"selectedTVNameChange" object:nil userInfo:[NSDictionary dictionaryWithObject:[[changeSelectedDeviceNameEvent alloc] initWithName:newName] forKey:@"data"]];
        if([MyUIApplication getSelectedPCIP]!=nil&&[MyUIApplication getSelectedTVIP]!=nil){
            [TVAppHelper currentPcInfo2TV];
        }
    }
}
+ (void) changeSelectedPCName:(NSString*) newName {
    if(newName != nil && ![newName isEqualToString:selectedPCIP.name]) {
        selectedPCIP.nickName = newName;
        [FillingIPInforList changePCNickName:newName Mac:selectedPCIP.mac];
        NSString* pcJsonString = [selectedPCIP yy_modelToJSONString];
        [[[PreferenceUtil alloc] init] writeKey:@"lastChosenPC" Value:pcJsonString];
        [[[PreferenceUtil alloc] init] writeKey:selectedPCIP.mac Value:newName];;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"selectedPCNameChange" object:nil userInfo:[NSDictionary dictionaryWithObject:[[changeSelectedDeviceNameEvent alloc] initWithName:newName] forKey:@"data"]];
        if([MyUIApplication getSelectedPCIP]!=nil&&[MyUIApplication getSelectedTVIP]!=nil){
            [TVAppHelper currentPcInfo2TV];
        }
        }
}
@end
