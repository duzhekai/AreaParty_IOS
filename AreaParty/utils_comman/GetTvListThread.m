//
//  GetTvListThread.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/1/14.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//
/**
 * Created by borispaul on 2017/6/23.
 * 获取TV的应用、鼠标列表、信息的线程
 */
#import "GetTvListThread.h"
#import "AESc.h"
#import "newAES.h"
static NSString* password = nil;
static NSString* pass = nil;
static NSString* pass1 = nil;
@implementation GetTvListThread

- (instancetype)init{
    self =[super init];
    if(self){
        tag = NSStringFromClass([self class]);
    }
    return self;
}

- (instancetype)initWithType:(NSString*)type1 andHandler:(id<onHandler>)handler1{
    self =[super init];
    if(self){
        tag = NSStringFromClass([self class]);
        type = type1;
        handler = handler1;
    }
    return self;
}

- (void)main{
    IPInforBean* tvIpInfor = [MyUIApplication getSelectedTVIP];
    if(tvIpInfor != nil && ![tvIpInfor.ip isEqualToString:@""]) {
        NSString* cmdStr = [self createCmdStr];
        NSString* dataReceived = @"";
        CFReadStreamRef readStream;
        CFWriteStreamRef writeStream;
        NSInputStream* inputStream;
        NSOutputStream* outputStream;
        @try {
            CFStreamCreatePairWithSocketToHost(NULL,(__bridge CFStringRef)tvIpInfor.ip,tvIpInfor.port,&readStream,&writeStream);
            inputStream = (__bridge NSInputStream*)(readStream);
            outputStream = (__bridge NSOutputStream*)(writeStream);
            [inputStream open];
            [outputStream open];
            
            password = [[[PreferenceUtil alloc] init] readKey:@"TVMACS"];
            NSDictionary* TVMacs = [MyUIApplication parse:password];
            pass= [TVMacs objectForKey:[MyUIApplication getSelectedTVIP].mac];
            pass1 = [AESc stringToMD5:pass];
            NSString* cmdStr1 = [[newAES encrypt:cmdStr key:pass1] stringByAppendingString:@"\n"];
            NSData* senddata =[cmdStr1 dataUsingEncoding:NSUTF8StringEncoding];
            
            NSString* senddatastring = [[NSString alloc] initWithData:senddata encoding:NSUTF8StringEncoding];
            NSString* decrypt = [newAES decrypt:senddatastring key:pass1];
            
            [outputStream write:[senddata bytes] maxLength:[senddata length]];
            Byte receivedbuf[40000];
            int readCount = 0;
            int len = 0;
            while ((len = [inputStream read:receivedbuf+readCount maxLength:sizeof(receivedbuf)])) {
                readCount+=len;
            }
            
            dataReceived = [[NSString alloc] initWithData:[NSData dataWithBytes:receivedbuf length:readCount] encoding:NSUTF8StringEncoding];
            
            NSString* decryptdata = [newAES decrypt:dataReceived key:pass1];
            NSLog(@"GetTvListThread:指令: %@",cmdStr);
            NSLog(@"GetTvListThread:回复: %@ len:%ld",dataReceived,(long)len);
            if([decryptdata length]>0){
                [self parseMesgReceived:decryptdata];
                [self  reportResult:YES];
            }
            else [self reportResult:NO];
        } @catch (NSException *exception) {
            NSLog(@"%@",exception);
            [self reportResult:NO];
        } @finally {
            [inputStream close];
            [outputStream close];
        }
    }
    else [self reportResult:NO];
}
/**
 * <summary>
 *  创建请求指令字符串
 * </summary>
 * <returns>发送给TV的请求数据指令</returns>
 */
- (NSString*) createCmdStr{
    NSString* cmdStr = @"";
    if([type isEqualToString:OrderConst_getTVSYSApps_firCommand]){
        cmdStr =  [[[CommandUtil createGetTvSYSAppCommand] yy_modelToJSONString] stringByAppendingString:@"\n"];
    }
    if([type isEqualToString:OrderConst_getTVOtherApps_firCommand]){
        cmdStr =  [[[CommandUtil createGetTvOtherAppCommand] yy_modelToJSONString] stringByAppendingString:@"\n"];
    }
    if([type isEqualToString:OrderConst_getTVMouses_firCommand]){
        cmdStr =  [[[CommandUtil createGetTvMouseDevicesCommand] yy_modelToJSONString] stringByAppendingString:@"\n"];
    }
    if([type isEqualToString:OrderConst_getTVInfor_firCommand]){
        cmdStr =  [[[CommandUtil createGetTvInforCommand] yy_modelToJSONString] stringByAppendingString:@"\n"];
    }
    return cmdStr;

}
/**
 * <summary>
 *  解析TV返回的数据并设置相应的静态变量
 * </summary>
 */
- (void)parseMesgReceived:(NSString*) dataReceived {
    if([type isEqualToString:OrderConst_getTVOtherApps_firCommand] || [type isEqualToString:OrderConst_getTVSYSApps_firCommand]){
        NSArray<AppItem*>* list = [NSArray<AppItem*> yy_modelArrayWithClass:[AppItem class] json:dataReceived];
        [TVAppHelper setAppList:type list:list];
    }
    if([type isEqualToString:OrderConst_getTVMouses_firCommand]){
        NSArray<NSString*>* list = [NSArray<NSString*> yy_modelArrayWithClass:[NSString class] json:dataReceived];
        [TVAppHelper setMouseDevices:list];
    }
    if([type isEqualToString:OrderConst_getTVInfor_firCommand]){
        TVInforBean* inforBean = [TVInforBean yy_modelWithJSON:dataReceived];
        [TVAppHelper setTvInfor:inforBean];
    }
}

/**
 * <summary>
 *  发送相应的Handler消息
 * </summary>
 */
-(void) reportResult:(BOOL)result{
    if(result) {
        if([type isEqualToString:OrderConst_getTVOtherApps_firCommand]){
            dispatch_async(dispatch_get_main_queue(), ^{
                [handler onHandler:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:OrderConst_getTVOtherApp_OK],@"what",nil]];
            });
        }
        if([type isEqualToString:OrderConst_getTVSYSApps_firCommand]){
            dispatch_async(dispatch_get_main_queue(), ^{
                [handler onHandler:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:OrderConst_getTVSYSApp_OK],@"what",nil]];
            });
        }
        if([type isEqualToString:OrderConst_getTVMouses_firCommand]){
            dispatch_async(dispatch_get_main_queue(), ^{
                [handler onHandler:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:OrderConst_getTVMouse_OK],@"what",nil]];
            });
        }
        if([type isEqualToString:OrderConst_getTVInfor_firCommand]){
            dispatch_async(dispatch_get_main_queue(), ^{
             [handler onHandler:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:OrderConst_getTVInfor_OK],@"what",nil]];
            });
            }
    } else {
        if([type isEqualToString:OrderConst_getTVOtherApps_firCommand]){
            dispatch_async(dispatch_get_main_queue(), ^{
            [handler onHandler:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:OrderConst_getTVOtherApp_Fail],@"what",nil]];
            });
        }
        if([type isEqualToString:OrderConst_getTVSYSApps_firCommand]){
            dispatch_async(dispatch_get_main_queue(), ^{
            [handler onHandler:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:OrderConst_getTVSYSApp_Fail],@"what",nil]];
            });
        }
        if([type isEqualToString:OrderConst_getTVMouses_firCommand]){
            dispatch_async(dispatch_get_main_queue(), ^{
            [handler onHandler:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:OrderConst_getTVMouse_Fail],@"what",nil]];
            });
        }
        if([type isEqualToString:OrderConst_getTVInfor_firCommand]){
            dispatch_async(dispatch_get_main_queue(), ^{
            [handler onHandler:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:OrderConst_getTVInfor_Fail],@"what",nil]];
            });
        }
    }
}
@end
