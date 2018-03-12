//
//  MySocket.h
//  AreaParty
//
//  Created by 杜哲凯 on 2017/11/29.
//  Copyright © 2017年 杜哲凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>
#include <sys/socket.h>
#include <netinet/in.h>
#import "Toast.h"
#import "ProtoHead.pbobjc.h"
#import "NetworkPacket.h"
#import "PersonalSettingsMsg.pbobjc.h"
#import "SettingNameViewController.h"
#import "SettingPwdViewController.h"
#import "SettingAddressViewController.h"
@interface Base : NSObject<NSStreamDelegate>{
    
}
@property(strong,atomic) NSInputStream* inputStream;
@property(strong,atomic) NSOutputStream* outputStream;
@property(strong,atomic) NSMutableArray* onlineUserId;
- (instancetype)initWithHost:(NSString*)host andPort:(int)port;
-(NSData*) readFromServer:(NSInputStream*) inputstream;
-(void) writeToServer:(NSOutputStream*) outputstream arrayBytes:(NSData*)bytes;
-(void) close;
-(int)getFileNum;
@end
