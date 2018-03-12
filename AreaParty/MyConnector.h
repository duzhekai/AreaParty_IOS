//
//  MyConnector.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/1/3.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyUIApplication.h"
#import "IPAddressConst.h"
@interface MyConnector : NSObject<NSStreamDelegate>{
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    NSInputStream* minputstream;
    NSOutputStream* moutputstream;
}
@property(strong,nonatomic) NSString* IP;
@property(assign,nonatomic) BOOL connetedState;
+ (instancetype)sharedInstance;
- (void) closeLongConnect;
-(NSString*) getMonitorMsg;
-(BOOL)sentMonitorCommand:(NSString*) msg;
-(BOOL)sendMsgToIP:(NSString*)ip Port:(int)port Msg:(NSString*)msgSend;
-(NSString*)getAddPathToHttpStateMsg:(NSString*) msgSend;
-(NSString*)getActionStateMsg:(NSString*) msgSend;
- (BOOL) connect;
-(void) initial:(NSString*)ip;
@end
