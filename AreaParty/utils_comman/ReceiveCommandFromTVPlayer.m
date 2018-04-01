//
//  ReceiveCommandFromTVPlayer.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/3/26.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "ReceiveCommandFromTVPlayer.h"
#import "OrderConst.h"
#import "FillingIPInforList.h"
#import "GCDAsyncUdpSocket.h"
#import "MyUIApplication.h"

static BOOL playerIsRun = NO;
static NSString* tag = @"CommandFromTVPlayer";
static NSString* playerType = @"VIDEO";
@implementation ReceiveCommandFromTVPlayer

- (void)main{
    [self runReceiveBroadCast];
}
- (instancetype)initWithIsRun:(BOOL) isrun{
    if(self = [super init]){
        playerIsRun = isrun;
    }
    return self;
}
- (void) runReceiveBroadCast{
    /*在这里同样使用约定好的端口*/
    GCDAsyncUdpSocket* udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:[UIApplication sharedApplication].delegate delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    @try{
        NSError *error = nil;
        if(![udpSocket bindToPort :IPAddressConst_REVEIVE_FROM_TVPLAYER_PORT error:&error])
        {
            NSLog(@"error in bindToPort");
            return;
        }
        NSLog(@"CommandFromTVPlayer,开始监听");
        while(![FillingIPInforList getCloseSingnal] && playerIsRun){
            [udpSocket receiveOnce:&error];
        }
    }@catch (NSException* e){
        NSLog(@"ReceiveCommandFromTVPlayer:%@",e);
    }@finally {
        if (udpSocket!=nil){
            [udpSocket close];
        }
    }
}
+(BOOL) getplayerIsRun{
    return playerIsRun;
}
+ (void) setplayerIsRun:(BOOL)isrun{
    playerIsRun = isrun;
}
+ (NSString*) getplayerType{
    return playerType;
}
+ (void) setplayerType:(NSString*)type{
    playerType = type;
}
@end
