//
//  AppDelegate.m
//  AreaParty
//
//  Created by 杜哲凯 on 2017/11/5.
//  Copyright © 2017年 杜哲凯. All rights reserved.
//

#import "AppDelegate.h"
#import "MyUIApplication.h"
#import "NetUtil.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    NSLog(@"MyApplication:applicationCreate");
    //初始化下载器
    //初始化tvpcip
    [MyUIApplication initTVPCIP];
    [MyUIApplication setmNetWorkState:[NetUtil getNetWorkStates]];
    [MyUIApplication setappnetmanager:[AFNetworkReachabilityManager manager]];
    AFNetworkReachabilityManager* _manager = [MyUIApplication getappnetmanager];
    [_manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                //OkDownload.getInstance().pauseAll();
                [FillingIPInforList setCloseSignal:YES];
                NSLog(@"MyApplication:未知网络");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"没有联网");
                //OkDownload.getInstance().pauseAll();
                [FillingIPInforList setCloseSignal:YES];
                NSLog(@"MyApplication:网络不可用");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                //OkDownload.getInstance().pauseAll();
                [FillingIPInforList setCloseSignal:YES];
                NSLog(@"MyApplication:当前是移动网");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"MyApplication:WIFI已连接");
                [FillingIPInforList setCloseSignal:NO];
                [FillingIPInforList startBroadCastAndListenTime1:10000 Time2:10000];
                break;
            default:
                break;
        }
    }];
    //开启网络监听
    [_manager startMonitoring];
    [MyUIApplication setlaunchtimeid:[NSString stringWithFormat:@"%d",arc4random()]];
    // 打开本地Http服务器
    @try {
        //dlnaServer = new HttpServer(IPAddressConst.DLNAPHONEHTTPPORT_B);
    } @catch (NSException* e) {
        NSLog(@"%@",e);
    }
    @try {
        [MyUIApplication verifyLastPCMac];
        [MyUIApplication verifyLastTVMac];
    }@catch (NSException* e) {
        NSLog(@"%@",e);
    }
    [MyUIApplication startStateRefreshTimer];
    [MyUIApplication startCheckIsNewVersionExist];
    return YES;
}
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag{
    if(tag ==100){
        NSLog(@"发送一次udp报文:tag=100,广播寻找PC和TV");
    }
    else if(tag == 200){
        NSLog(@"发送一次udp报文:tag=200,检查更新报文");
    }
}
-(void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error{
    NSLog(@"标记为tag %ld的发送失败 失败原因 %@",tag, error);
}
-(void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext{
    NSString *s = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"收到udp报文%@",s);
    [MyUIApplication setReceiveMsgBean:[Update_ReceiveMsgBean yy_modelWithJSON:s]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"newVersionInforChecked" object:nil userInfo:[NSDictionary dictionaryWithObject:[Update_ReceiveMsgBean yy_modelWithJSON:s] forKey:@"data"]];
    [sock close];
    if(s.length > 0){
        [[MyUIApplication getversionCheckTimer] invalidate];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
@end
