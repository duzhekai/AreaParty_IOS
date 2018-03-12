//
//  IdentityVerify.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/1/2.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "IdentityVerify.h"
#import "OrderConst.h"
@implementation IdentityVerify
/**
 * <summary>
 *  验证当前选中PC
 *  <param name="handler">消息传递句柄</param>
 * </summary>
 */
+ (void) identifyPCwithHandler:(id<onHandler>)handler andCode:(NSString*)code andIP:(NSString*)ip andPort:(int)port {
    NSLog(@"IdentityVerify PC code:%@ IP:%@ port:%d",code,ip,port);
    [[[Send2SpecificPCThread alloc] initWithtypeName:OrderConst_identityAction_name commandType:OrderConst_identityAction_command myhandler:handler IP:ip port:port code:code] start];
}
/**
 * <summary>
 *  验证当前选中TV
 *  <param name="handler">消息传递句柄</param>
 * </summary>
 */
+ (void) identifyTVwithHandler:(id<onHandler>)handler andCode:(NSString*)code andIP:(NSString*)ip andPort:(int)port {
    NSLog(@"IdentityVerify TV code:%@ IP:%@ port:%d",code,ip,port);
    [[[Send2SpecificTVThread alloc] initWithtypeName:OrderConst_identityAction_name commandType:OrderConst_identityAction_command myhandler:handler IP:ip port:port code:code] start];
}
@end
