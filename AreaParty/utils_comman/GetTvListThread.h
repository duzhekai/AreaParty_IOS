//
//  GetTvListThread.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/1/14.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//
/**
 * Created by borispaul on 2017/6/23.
 * 获取TV的应用、鼠标列表、信息的线程
 */
#import <Foundation/Foundation.h>
#import "onHandler.h"
#import "OrderConst.h"
#import "CommandUtil.h"
#import "AppItem.h"
@interface GetTvListThread : NSThread{
    const NSString* tag;
    NSString* type;   // "GET_TV_INSTALLEDAPPS, GET_TV_SYSAPPS, GET_TV_MOUSES, GET_TV_INFOR"
    id<onHandler> handler;
}
- (instancetype)initWithType:(NSString*)type1 andHandler:(id<onHandler>)handler1;
@end
