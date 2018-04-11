//
//  Send2SpecificTVThread.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/1/21.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "Send2SpecificTVThread.h"
#import "AESc.h"
#import "newAES.h"
@implementation Send2SpecificTVThread

-(instancetype) initWithtypeName:(NSString*)typeName1 commandType:(NSString*)commandType1 myhandler:(id<onHandler>)myhandler1 IP:(NSString*)ip1 port:(int)port1 code:(NSString*)code1{
    self = [super init];
    if(self){
        typeName = typeName1;
        commandType = commandType1;
        myhandler = myhandler1;
        IP = ip1;
        port = port1;
        NSString* pass1 = [AESc stringToMD5:code1];
        code = pass1;
    }
    return self;
}
- (void)main{
    if(![IP isEqualToString:@""]){
        NSString* cmdStr = [self createCmdStr];
        NSString* dataReceived = @"";
        CFReadStreamRef readStream;
        CFWriteStreamRef writeStream;
        NSInputStream * inputStream;
        NSOutputStream* outputStream;
        Byte buffer[8192];
        @try {
            CFStreamCreatePairWithSocketToHost(NULL,(__bridge CFStringRef)IP,port,&readStream,&writeStream);
            inputStream = (__bridge NSInputStream*)(readStream);
            outputStream = (__bridge NSOutputStream*)(writeStream);
            [inputStream open];
            [outputStream open];
            NSData* senddata =[cmdStr dataUsingEncoding:NSUTF8StringEncoding];
            [outputStream write:[senddata bytes] maxLength:[senddata length]];
            NSInteger length = [inputStream read:buffer maxLength:sizeof(buffer)];
            dataReceived = [[NSString alloc] initWithData:[NSData dataWithBytes:buffer length:length] encoding:NSUTF8StringEncoding];
            NSLog(@"Send2TVThread:指令:%@",cmdStr);
            NSLog(@"Send2TVThread:回复:%@",dataReceived);
            NSString* decryptdata = [newAES decrypt:dataReceived key:code];
            if([decryptdata isEqualToString:@"true"]){
              [self reportResult:YES andData:@"true"];
            }else
            {[self reportResult:YES andData:@"false"];}
        } @catch (NSException *exception) {
            NSLog(@"%@",exception);
            [self reportResult:NO andData:@"false"];
        } @finally {
            [inputStream close];
            [outputStream close];
        }
    }else  [self reportResult:NO andData:@"false"];
}
/**
 * <summary>
 *  创建请求指令字符串
 * </summary>
 * <returns>发送给PC的请求指令</returns>
 */
- (NSString*)createCmdStr{
    NSString* cmdStr =@"";
    if([typeName isEqualToString: OrderConst_identityAction_name]){
        cmdStr = [[[CommandUtil createVerifyTVCommand:code] yy_modelToJSONString] stringByAppendingString:@"\n"];
    }
    return cmdStr;
}
/**
 * <summary>
 *  发送相应的Handler消息
 * </summary>
 */
-(void)reportResult:(BOOL) result andData:(NSString*)data{
    if(result){
        if([typeName isEqualToString:OrderConst_identityAction_name]){
            NSDictionary* message = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [NSNumber numberWithInt:200],@"what",
                                     data,@"obj",
                                     nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                [myhandler onHandler:message];
            });
        }
    }
    else{
        if([typeName isEqualToString:OrderConst_identityAction_name]){
            NSDictionary* message = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [NSNumber numberWithInt:404],@"what",
                                     data,@"obj",
                                     nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                [myhandler onHandler:message];
            });
        }
    }
}
@end
