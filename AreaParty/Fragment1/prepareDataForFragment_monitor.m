//
//  prepareDataForFragment_monitor.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/3/8.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "prepareDataForFragment_monitor.h"
#import "ProcessFormat.h"
#import "RequestFormat.h"
#import "OrderConst.h"
#import <YYModel/YYModel.h>
#import "MyConnector.h"
#import "ReceivedMonitorMessageFormat.h"
#import "ReceivedExeListFormat.h"
static int DataNub = 52;
static double memory_used = 0;
static double memory_available = 0;
static double memory_total = 0;
static double net_up = 0;
static double net_down = 0;
static NSMutableArray<NSNumber*>* processesId;
static NSMutableArray<ProcessFormat*>* currentProcesses;
static NSMutableArray<ProcessFormat*>* increasedProcesses;
static NSMutableArray<NSNumber*>* decreasedProcesses;
static int memoryPercentArray[52]={0};
static int cpuPercentArray[52]={0};
@implementation prepareDataForFragment_monitor
+ (void)load{
    processesId = [[NSMutableArray alloc] init];
    currentProcesses = [[NSMutableArray alloc] init];
    increasedProcesses = [[NSMutableArray alloc] init];
    decreasedProcesses = [[NSMutableArray alloc] init];
}
+ (NSMutableArray<ProcessFormat*>*)getcurrentProcesses{
    return currentProcesses;
}
+ (double) getMemory_used {
    return memory_used;
}
+ (double) getMemory_total {
    return memory_total;
}
+ (double) getMemory_available {
    return memory_available;
}
+ (double) getNet_up {
    return net_up;
}
+ (double) getNet_down {
    return net_down;
}
+ (int*) getMemoryPercentArray {
    return memoryPercentArray;
}
+ (int*) getCpuPercentArray {
    return cpuPercentArray;
}
+ (int) getMemoryPercentData {
    return memoryPercentArray[DataNub - 1];
}
+ (int) getCpuPercentData {
    return cpuPercentArray[DataNub - 1];
}
+(NSMutableArray<ProcessFormat*>*) getIncreasedProcesses {
    return increasedProcesses;
}
+(NSMutableArray<NSNumber*>*) getDecreasedProcesses {
    return decreasedProcesses;
}
/**
 * <summary>
 *  重置静态变量
 * </summary>
 */
+ (void) initDataGroups {
    [processesId removeAllObjects];
    [increasedProcesses removeAllObjects];
    [decreasedProcesses removeAllObjects];
    [currentProcesses removeAllObjects];
    for(int i = 0; i < 52; ++i) {
        memoryPercentArray[i] = 0;
        cpuPercentArray[i] = 0;
    }
}
+ (void) setMemoryPercentArray:(int) value {
    for(int i = 0;i<DataNub-1;i++)
        memoryPercentArray[i] = memoryPercentArray[i+1];
    
    memoryPercentArray[DataNub - 1] = value;
}
+ (void) setCpuPercentArray:(int) value {
    for(int i = 0;i<DataNub-1;i++)
        cpuPercentArray[i] = cpuPercentArray[i+1];
    cpuPercentArray[DataNub - 1] = value;
}
/**
 * 发送指令获取监控数据并更新静态变量
 */
+ (void) getMonitoringData {
    NSString* msgReceived;
    RequestFormat* request = [[RequestFormat alloc] init];
    
    [request setName:OrderConst_monitorActionData_name];
    [request setCommand:OrderConst_monitorData_get_command];
    [request setParam:@""];
    NSString* requestString = [request yy_modelToJSONString];
    BOOL temp = [[MyConnector sharedInstance] sentMonitorCommand:requestString];
    if(temp) {
        msgReceived = [[MyConnector sharedInstance] getMonitorMsg];
        if(![msgReceived isEqualToString:@""]) {
            [self resolvingMonitoringData:msgReceived];
        } else {
            [increasedProcesses removeAllObjects];
            [decreasedProcesses removeAllObjects];
            [self setMemoryPercentArray:memoryPercentArray[DataNub - 1]];
            [self setCpuPercentArray:cpuPercentArray[DataNub - 1]];
        }
    } else {
        net_up = 0;
        net_down = 0;
        memory_used = 0;
        memory_total = 0;
        memory_available = 0;
        
        [decreasedProcesses removeAllObjects];
        for (ProcessFormat* process in currentProcesses){
            [decreasedProcesses addObject:[NSNumber numberWithInt:process.p_id]];
        }
        for(int i = 0; i < DataNub; i++) {
            memoryPercentArray[i] = 0;
            cpuPercentArray[i] = 0;
        }
    }
}
/**
 * <summary>
 *  解析监控信息
 * </summary>
 * <param name="msgReceived">监控信息字符串</param>
 */
+ (void) resolvingMonitoringData:(NSString*) msgReceived {
    NSLog(@"Monitor,%@", msgReceived);
    ReceivedMonitorMessageFormat* message = [ReceivedMonitorMessageFormat yy_modelWithJSON:msgReceived];
    if(message != nil && message.status == 200) {
        MonitorData* data = message.data;
        net_up = data.net_up;
        net_down = data.net_down;
        memory_used = data.memory_used;
        memory_total = data.memory_total;
        memory_available = data.memory_available;
        
        [self setMemoryPercentArray:((int)(memory_used / memory_total * 100))];
        [self setCpuPercentArray:data.cpu];
        
        currentProcesses = data.processes;
        NSMutableArray<NSNumber *>* currentProcessesId = [[NSMutableArray alloc] init];
        
        for(ProcessFormat* process in currentProcesses) {
            [currentProcessesId addObject:[NSNumber numberWithLong:process.p_id]];
        }
        
        [increasedProcesses removeAllObjects];
        for(ProcessFormat* process in currentProcesses) {
            if(![processesId containsObject:[NSNumber numberWithInt:process.p_id]]) {
                [processesId addObject:[NSNumber numberWithInt:process.p_id]];
                [increasedProcesses addObject:process];
            }
        }
        [decreasedProcesses removeAllObjects];
        for(int i = 0; i < processesId.count; i++) {
            if(![currentProcessesId containsObject:processesId[i]]) {
                [decreasedProcesses addObject:processesId[i]];
                [processesId removeObjectAtIndex:i];
            }
        }
    }
}
/**
 * <summary>
 *  发送操作指令并获取执行状态
 * </summary>
 * <param name="name">操作名称</param>
 * <param name="command">操作</param>
 * <param name="param">参数</param>
 * <returns>执行状态</returns>
 */
+ (ReceivedActionMessageFormat*) getActionStateData:(NSString*) name Command:(NSString*) command Param:(NSString*) param{
    ReceivedActionMessageFormat* message = [[ReceivedActionMessageFormat alloc] init];
    RequestFormat* request = [[RequestFormat alloc] init];
    [request setName:name];
    [request setCommand:command];
    [request setParam:param];
    NSString* requestString = [request yy_modelToJSONString];
    if([name isEqualToString:OrderConst_processAction_name]){
        NSString* msgReceived;
        msgReceived = [[MyConnector sharedInstance] getActionStateMsg:requestString];
        NSLog(@"Send2PCThread2:%@",msgReceived);
        if(![msgReceived isEqualToString:@""]) {
            message = [ReceivedActionMessageFormat yy_modelWithJSON:msgReceived];
        }
    }
    else if([name isEqualToString:OrderConst_computerAction_name]){
        [[MyConnector sharedInstance] getActionStateMsg:requestString];
    }
    return message;
}
/**
 * <summary>
 *  通过进程ID获取进程当前信息
 * </summary>
 * <param name="id">进程ID</param>
 * <returns></returns>
 */
+ (ProcessFormat*) getProcessById:(int) pid {
    for(ProcessFormat* process in currentProcesses) {
        if(process.p_id == pid) {
            return process;
        }
    }
    return nil;
}
/**
 * <summary>
 *  发送PC应用操作指令并获取执行状态
 * </summary>
 * <param name="name">操作名称</param>
 * <param name="command">操作</param>
 * <param name="param">参数</param>
 * <returns>执行结果</returns>
 */
+ (NSObject*) getExeActionStateData:(NSString*)name command:(NSString*) command Param:(NSString*) param{
    NSObject* message = [[NSObject alloc] init];
    
    RequestFormat* request = [[RequestFormat alloc] init];
    [request setName:name];
    [request setCommand:command];
    [request setParam:param];
    // NSString* requestString = [request yy_modelToJSONString];
    if([command isEqualToString:OrderConst_appAction_get_command]){
        message = [self getExeInforArray:request];
    }
    return message;
}
+ (NSObject*) getExeInforArray:(RequestFormat*) request {
    NSMutableArray<ReceivedExeListFormat*>* receivedExeInforArray = [[NSMutableArray alloc] init];
    NSString* requestMsg = [request yy_modelToJSONString];
    
    ReceivedExeListFormat* messageTemp = [[ReceivedExeListFormat alloc] init];
    NSString* msgReceived = [[MyConnector sharedInstance] getActionStateMsg:requestMsg];
    NSLog(@"GETEXE:首次发送%@",requestMsg);
    NSLog(@"GETEXE:首次接收%@", msgReceived);
    @try{
        messageTemp = [ReceivedExeListFormat yy_modelWithJSON:msgReceived];
        [receivedExeInforArray addObject:messageTemp];
    } @catch(NSException* e) {}
    
    BOOL signal = (messageTemp.status == OrderConst_success) &&
    [messageTemp.message isEqualToString:OrderConst_exeAction_get_more_message];
    while(signal) {
        [request setParam:OrderConst_exeAction_get_more_param];
        requestMsg = [request yy_modelToJSONString];
        msgReceived = [[MyConnector sharedInstance] getActionStateMsg:requestMsg];
        NSLog(@"GETEXE,发送获取更多%@" , requestMsg);
        NSLog(@"GETEXE,接收获取更多%@" ,msgReceived);
        @try{
            messageTemp = [ReceivedExeListFormat yy_modelWithJSON:msgReceived];
            [receivedExeInforArray addObject:messageTemp];
        } @catch(NSException* e) {}
        signal = (messageTemp.status == OrderConst_success) &&
        [messageTemp.message isEqualToString:OrderConst_exeAction_get_more_message];
    }
    
    ReceivedExeListFormat* allExeInfor = [[ReceivedExeListFormat alloc] init];
    NSMutableArray<ExeInformat*>* allExes = [[NSMutableArray alloc] init];
    for (ReceivedExeListFormat* temp in receivedExeInforArray) {
        [allExes addObjectsFromArray:temp.data];
    }
    int status = OrderConst_success;
    NSString* message = nil;
    if(allExes.count == 0) {
        status = messageTemp.status;
        message = messageTemp.message;
    }
    [allExeInfor setStatus:status];
    [allExeInfor setMessage:message];
    [allExeInfor setData:allExes];
    return allExeInfor;
}

@end
