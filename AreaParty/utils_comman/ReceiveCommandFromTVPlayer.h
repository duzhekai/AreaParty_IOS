//
//  ReceiveCommandFromTVPlayer.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/3/26.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReceiveCommandFromTVPlayer : NSThread
- (instancetype)initWithIsRun:(BOOL) isrun;
+ (BOOL) getplayerIsRun;
+ (void) setplayerIsRun:(BOOL)isrun;
+ (NSString*) getplayerType;
+ (void) setplayerType:(NSString*)type;
@end
