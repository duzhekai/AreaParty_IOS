//
//  prepareDataForFragment.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/1/25.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestFormat.h"
#import "YYModel.h"
#import "OrderConst.h"
#import "MyConnector.h"
#import "ReceivedDiskListFormat.h"
#import "MyConnector.h"
#import "ReceivedFileManagerMessageFormat.h"
#import "NodeFormat.h"
@interface prepareDataForFragment : NSObject
+(NSObject*)getDiskActionStateData:(NSString*)name command:(NSString*)command param:(NSString*) param;
+ (NSObject*) getFileActionStateData:(NSString*)name command:(NSString*) command param:(NSString*) param;
@end
