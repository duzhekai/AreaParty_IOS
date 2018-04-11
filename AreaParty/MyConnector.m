//
//  MyConnector.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/1/3.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "MyConnector.h"
#import "AESc.h"
#import "newAES.h"
static NSString* password = nil;
static NSString* pass = nil;
static NSString* pass1 = nil;
static MyConnector *instance = nil;
@implementation MyConnector

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
        instance.IP= @"";
        instance.connetedState=NO;
    });
    return instance;
}
+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
    });
    return instance;
}

-(void) initial:(NSString*)ip {
    if(![ip isEqualToString:@""])
        self.IP = ip;
}
/**
 * <summary>
 *  创建监控信息的长连接，并初始化IP和执行操作(短连接)时使用的端口
 * </summary>
 * <param name="IP">IP地址</param>
 * <returns>长连接创建状态</returns>
 */
- (BOOL) connect{
    BOOL state = NO;
    if([self.IP isEqualToString:@""] && [MyUIApplication getSelectedPCIP] != nil) {
        NSString* ipPC = [MyUIApplication getSelectedPCIP].ip;
        [self initial:ipPC];
    }
    if([MyUIApplication getSelectedPCIP]!=nil && self.IP != nil && ![self.IP isEqualToString:@""]) {
        if(minputstream==nil &&moutputstream==nil){
            @try {
                CFStreamCreatePairWithSocketToHost(NULL,(__bridge CFStringRef)self.IP,IPAddressConst_PCMONITORPORT_B,&readStream,&writeStream);
                minputstream = (__bridge NSInputStream*)(readStream);
                moutputstream = (__bridge NSOutputStream*)(writeStream);
                //设置代理
                minputstream.delegate = self;
                moutputstream.delegate = self;
                [minputstream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
                [moutputstream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
                [minputstream open];
                [moutputstream open];
                state = YES;
            } @catch (NSException *exception) {
                minputstream = nil;
                moutputstream = nil;
                NSLog(@"Myconnector:长连接失败");
                state = false;
            }
        }
    }else{
        state = NO;
    }
    return state;
}
/**
 * <summary>
 *  重新和服务器建立长连接(传输监控数据)
 * </summary>
 * <returns>重建状态</returns>
 */
-(BOOL)rebuildSocket{
    if([self.IP isEqualToString:@""] && [MyUIApplication getSelectedPCIP] != nil) {
        NSString* ipPC = [MyUIApplication getSelectedPCIP].ip;
        [self initial:ipPC];
    }
    if(![self.IP isEqualToString:@""]){
        @try {
            CFStreamCreatePairWithSocketToHost(NULL,(__bridge CFStringRef)self.IP,IPAddressConst_PCMONITORPORT_B,&readStream,&writeStream);
            minputstream = (__bridge NSInputStream*)(readStream);
            moutputstream = (__bridge NSOutputStream*)(writeStream);
            //设置代理
            minputstream.delegate = self;
            moutputstream.delegate = self;
            [minputstream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            [moutputstream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            [minputstream open];
            [moutputstream open];
            return YES;
        } @catch (NSException *exception) {
            minputstream = nil;
            moutputstream = nil;
            NSLog(@"Myconnector:长连接失败");
            return NO;
        }
    }
    return NO;
}
/**
 * <summary>
 *  使用短连接发送操作指令，并获取执行结果
 * </summary>
 * <param name="msgSend">待发送的命令</param>
 * <returns>执行结果</returns>
 */
-(NSString*)getActionStateMsg:(NSString*) msgSend{
    if([self.IP isEqualToString:@""]){
        NSString* ipPC = [MyUIApplication getSelectedPCIP].ip;
        [self initial:ipPC];
        self.IP = ipPC;
    }
    NSMutableString* msg = [[NSMutableString alloc] init];
    NSInteger len;
    if(![self.IP isEqualToString:@""]){
        @try {
            CFReadStreamRef readStream;
            CFWriteStreamRef writeStream;
            NSInputStream * inputStream;
            NSOutputStream* outputStream;
            CFStreamCreatePairWithSocketToHost(NULL,(__bridge CFStringRef)self.IP,IPAddressConst_PCACTIONPORT_B,&readStream,&writeStream);
            inputStream = (__bridge NSInputStream*)(readStream);
            outputStream = (__bridge NSOutputStream*)(writeStream);
            [inputStream open];
            [outputStream open];
            password = [[[PreferenceUtil alloc] init] readKey:@"PCMACS"];
            NSDictionary* PCMacs = [MyUIApplication parse:password];
            pass= [PCMacs objectForKey:[MyUIApplication getSelectedPCIP].mac];
            pass1 = [AESc stringToMD5:pass];
            NSString* msgSend1 = [AESc EncryptAsDoNet:msgSend key:[pass1 substringToIndex:8]];
            
            NSData* senddata =[msgSend1 dataUsingEncoding:NSUTF8StringEncoding];
            [outputStream write:[senddata bytes] maxLength:[senddata length]];
            Byte rev[4000];
            while((len = [inputStream read:rev maxLength:4000])>0) {
                [msg appendString:[[NSString alloc] initWithData:[NSData dataWithBytes:rev length:len] encoding:NSUTF8StringEncoding]];
                if(len <= 0)
                    break;
            }
            NSString* final_msg = [AESc DecryptDoNet:msg key:[pass1 substringToIndex:8]];
            [inputStream close];
            [outputStream close];
            
            return final_msg;
        } @catch (NSException *exception) {
            NSLog(@"%@",exception);
            return @"";
        }
        
    }else return @"";
}
/**
 * <summary>
 *  使用短连接发送添加路径到PC的Http服务器指令，并获取执行结果
 * </summary>
 * <param name="msgSend">待发送的命令</param>
 * <returns>执行结果</returns>
 */
-(NSString*)getAddPathToHttpStateMsg:(NSString*) msgSend{
    if([self.IP isEqualToString:@""]){
        NSString* ipPC = [MyUIApplication getSelectedPCIP].ip;
        [self initial:ipPC];
    }
    NSString* msg=@"";
    NSInteger len;
    if(![self.IP isEqualToString:@""]){
        @try {
            CFReadStreamRef readStream;
            CFWriteStreamRef writeStream;
            NSInputStream * inputStream;
            NSOutputStream* outputStream;
            CFStreamCreatePairWithSocketToHost(NULL,(__bridge CFStringRef)self.IP,[MyUIApplication getSelectedPCIP].port,&readStream,&writeStream);
            inputStream = (__bridge NSInputStream*)(readStream);
            outputStream = (__bridge NSOutputStream*)(writeStream);
            [inputStream open];
            [outputStream open];
            password = [[[PreferenceUtil alloc] init] readKey:@"PCMACS"];
            NSDictionary* PCMacs = [MyUIApplication parse:password];
            pass= [PCMacs objectForKey:[MyUIApplication getSelectedPCIP].mac];
            pass1 = [AESc stringToMD5:pass];
            NSString* msgSend1 = [AESc EncryptAsDoNet:msgSend key:[pass1 substringToIndex:8]];
            NSData* senddata =[msgSend1 dataUsingEncoding:NSUTF8StringEncoding];
            [outputStream write:[senddata bytes] maxLength:[senddata length]];
            Byte rev[1024];
            if((len = [inputStream read:rev maxLength:1024])>0) {
                msg = [[NSString alloc] initWithData:[NSData dataWithBytes:rev length:len] encoding:NSUTF8StringEncoding];
            }
            [inputStream close];
            [outputStream close];
            NSString* final_msg = [AESc DecryptDoNet:msg key:[pass1 substringToIndex:8]];
            return final_msg;
        } @catch (NSException *exception) {
            NSLog(@"%@",exception);
            return @"";
        }
        
    }else return @"";
}
-(BOOL)sendMsgToIP:(NSString*)ip Port:(int)port Msg:(NSString*)msgSend{
    BOOL signal = NO;
    @try {
        CFReadStreamRef readStream;
        CFWriteStreamRef writeStream;
        NSInputStream * inputStream;
        NSOutputStream* outputStream;
        CFStreamCreatePairWithSocketToHost(NULL,(__bridge CFStringRef)ip,port,&readStream,&writeStream);
        inputStream = (__bridge NSInputStream*)(readStream);
        outputStream = (__bridge NSOutputStream*)(writeStream);
        [inputStream open];
        [outputStream open];
        
        password = [[[PreferenceUtil alloc] init] readKey:@"TVMACS"];
        NSDictionary* TVMacs = [MyUIApplication parse:password];
        pass= [TVMacs objectForKey:[MyUIApplication getSelectedTVIP].mac];
        pass1 = [AESc stringToMD5:pass];
        NSString* msgSend1 = [newAES encrypt:msgSend key:pass1];
        
        NSData* senddata =[msgSend1 dataUsingEncoding:NSUTF8StringEncoding];
        [outputStream write:[senddata bytes] maxLength:[senddata length]];
        [inputStream close];
        [outputStream close];
        signal = YES;
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
        signal =  NO;
    }
    return signal;
}
/**
 * <summary>
 *  发送指定信息
 * </summary>
 * <param name="msg">消息</param>
 * <returns></returns>
 */
-(BOOL)sentMonitorCommand:(NSString*) msg{
    BOOL result;
    if(moutputstream!= nil){
        @try {
            password = [[[PreferenceUtil alloc] init] readKey:@"PCMACS"];
            NSDictionary* PCMacs = [MyUIApplication parse:password];
            pass= [PCMacs objectForKey:[MyUIApplication getSelectedPCIP].mac];
            pass1 = [AESc stringToMD5:pass];
            NSString* msgSend1 = [AESc EncryptAsDoNet:msg key:[pass1 substringToIndex:8]];
            NSData* senddata =[msgSend1 dataUsingEncoding:NSUTF8StringEncoding];
            [moutputstream write:[senddata bytes] maxLength:[senddata length]];
            result = YES;
            self.connetedState = YES;
        } @catch (NSException *exception) {
            BOOL signal = [self rebuildSocket];
            if(signal) {
                NSLog(@"重连成功");
                [self sentMonitorCommand:msg];
                result = true;
                self.connetedState = true;
            } else {
                result = false;
                self.connetedState = false;
                NSLog(@"重连失败");
            }
        }
    }
    else{
        BOOL signal = [self rebuildSocket];
        if(signal) {
            NSLog(@"重连成功");
            [self sentMonitorCommand:msg];
            result = true;
            self.connetedState = true;
        } else {
            result = false;
            self.connetedState = false;
            NSLog(@"重连失败");
        }
    }
    return result;
}
/**
 * <summary>
 *  返回获取到的消息(格式1: 完整的json字符串 格式2: 空字符)
 * </summary>
 * <returns>json串或空字符串</returns>
 */
-(NSString*) getMonitorMsg{
    NSMutableString* msg = [[NSMutableString alloc] init];
    NSUInteger len;
    if(minputstream !=nil){
        Byte rev[8000];
        @try {
            while((len = [minputstream read:rev maxLength:8000])>0) {
                [msg appendString:[[NSString alloc] initWithData:[NSData dataWithBytes:rev length:len] encoding:NSUTF8StringEncoding]];
                if([msg containsString:@"}]}}"])
                    break;
            }
        } @catch (NSException *exception) {
            NSLog(@"%@",exception);
        }
    }
    NSLog(@"MonitorData:接收到%@",msg);
    if([msg containsString:@"{\"status\""] && [msg containsString:@"}}"]) {
        return msg;
    } else {
        return @"";
    }
}
/**
 * <summary>
 *  关闭长连接
 * </summary>
 */
- (void) closeLongConnect {
    if(minputstream != nil && moutputstream != nil) {
        @try {
            [minputstream close];
            [moutputstream close];
            minputstream = nil;
            moutputstream = nil;
        } @catch (NSException *exception) {
            NSLog(@"%@",exception);
        }
    }

}

@end
