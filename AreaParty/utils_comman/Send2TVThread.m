//
//  Send2TVThread.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/1/6.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "Send2TVThread.h"
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
            NSData* senddata =[cmd dataUsingEncoding:NSUTF8StringEncoding];
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
