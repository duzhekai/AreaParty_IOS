//
//  Send2TVThread.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/1/6.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "Send2TVThread.h"
#import "newAES.h"
static NSString* password = nil;
static NSString* pass = nil;
static NSString* pass1 = nil;
@implementation Send2TVThread


-(instancetype)initWithCmd:(NSString*)cmd_{
    self = [super init];
    if(self){
        cmd= [cmd_ stringByAppendingString:@"\n"];
        tag = @"Send2TVThread";
    }
    return self;
}

- (void)main{
    IPInforBean* tvInfor = [MyUIApplication getSelectedTVIP];
    if(tvInfor != nil && ![tvInfor.ip isEqualToString:@""]) {
        CFReadStreamRef readStream;
        CFWriteStreamRef writeStream;
        NSInputStream* inputStream;
        NSOutputStream* outputStream;
        @try {
            CFStreamCreatePairWithSocketToHost(NULL,(__bridge CFStringRef)tvInfor.ip,tvInfor.port,&readStream,&writeStream);
            inputStream = (__bridge NSInputStream*)(readStream);
            outputStream = (__bridge NSOutputStream*)(writeStream);
            [inputStream open];
            [outputStream open];
            
            password = [[[PreferenceUtil alloc] init] readKey:@"TVMACS"];
            NSDictionary* TVMacs = [MyUIApplication parse:password];
            pass= [TVMacs objectForKey:[MyUIApplication getSelectedTVIP].mac];
            pass1 = [AESc stringToMD5:pass];
            NSString* cmd1 = [newAES encrypt:cmd key:pass1];
            
            NSData* senddata =[cmd1 dataUsingEncoding:NSUTF8StringEncoding];
            [outputStream write:[senddata bytes] maxLength:[senddata length]];
            NSLog(@"%@:%@",tag,cmd);
        } @catch (NSException *exception) {
            NSLog(@"%@",exception);
        } @finally {
            [inputStream close];
            [outputStream close];
        }
    }
}
@end
