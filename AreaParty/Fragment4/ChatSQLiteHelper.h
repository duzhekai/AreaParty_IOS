//
//  ChatSQLiteHelper.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/4/23.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB/FMDatabase.h>
#import "DBConst.h"
#import "ChatSQLiteHelper.h"
@interface ChatSQLiteHelper : NSObject
- (instancetype)initWithName:(NSString*) dbName;
- (FMDatabase*) getdb;


@end
