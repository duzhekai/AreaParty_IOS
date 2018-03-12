//
//  IdentityVerify.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/1/2.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "onHandler.h"
#import "Send2SpecificPCThread.h"
#import "Send2SpecificTVThread.h"
@interface IdentityVerify : NSObject
+ (void) identifyPCwithHandler:(id<onHandler>)handler andCode:(NSString*)code andIP:(NSString*)ip andPort:(int)port;
+ (void) identifyTVwithHandler:(id<onHandler>)handler andCode:(NSString*)code andIP:(NSString*)ip andPort:(int)port;
@end
