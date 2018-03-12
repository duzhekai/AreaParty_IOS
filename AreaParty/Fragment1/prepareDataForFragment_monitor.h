//
//  prepareDataForFragment_monitor.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/3/8.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ProcessFormat;
@class ReceivedActionMessageFormat;
@interface prepareDataForFragment_monitor : NSObject
+ (double) getMemory_used;
+ (double) getMemory_total;
+ (double) getMemory_available;
+ (double) getNet_up;
+ (double) getNet_down;
+ (int*) getMemoryPercentArray;
+ (int*) getCpuPercentArray;
+ (int) getMemoryPercentData;
+ (int) getCpuPercentData;
+ (ProcessFormat*) getProcessById:(int) pid ;
+(NSMutableArray<ProcessFormat*>*) getIncreasedProcesses;
+(NSMutableArray<NSNumber*>*) getDecreasedProcesses;
+ (void) initDataGroups;
+ (void) getMonitoringData;
+ (NSMutableArray<ProcessFormat*>*)getcurrentProcesses;
+ (ReceivedActionMessageFormat*) getActionStateData:(NSString*) name Command:(NSString*) command Param:(NSString*) param;
@end
