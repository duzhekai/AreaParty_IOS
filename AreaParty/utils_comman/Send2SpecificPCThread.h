//
//  Send2SpecificPCThread.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/1/2.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderConst.h"
#import "CommandUtil.h"
#import "Base.h"
#import "ReceivedActionMessageFormat.h"
#import "onHandler.h"
@interface Send2SpecificPCThread : NSThread{
     NSString* typeName;
     NSString* commandType;
     NSString* IP;
     int port;
     NSString* code;
     id<onHandler> myhandler;
}
-(instancetype) initWithtypeName:(NSString*)typeName1 commandType:(NSString*)commandType1 myhandler:(id<onHandler>)myhandler1 IP:(NSString*)ip1 port:(int)port1 code:(NSString*)code1;
@end
