//
//  ReceivedMonitorMessageFormat.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/3/8.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MonitorData.h"
@interface ReceivedMonitorMessageFormat : NSObject
@property(assign,nonatomic) int status;
@property(strong,nonatomic) NSString* message;
@property(strong,nonatomic) MonitorData* data;
@end
