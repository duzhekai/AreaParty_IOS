//
//  FileRequestDBManager.m
//  AreaParty
//
//  Created by 杜哲凯 on 2017/12/26.
//  Copyright © 2017年 杜哲凯. All rights reserved.
//

#import "FileRequestDBManager.h"
#import "ChatSQLiteHelper.h"
@implementation FileRequestDBManager{
    ChatSQLiteHelper* fileRequestHelper;
}
- (instancetype)init{
    if(self = [super init]){
        fileRequestHelper = [[ChatSQLiteHelper alloc] initWithName:@"chatDB"];
    }
    return self;
}
/*
 * 添加一条文件请求
 * */
- (void) addFileRequestSQL:(fileObj*) request AndTable:(NSString*) table{
    NSLog(@"DB_start add to database");
    FMDatabase* db = nil;
    @try{
        db = [fileRequestHelper getdb];
        if([db open]){
            int count = [db intForQuery:[NSString stringWithFormat:@"SELECT COUNT(*) FROM [%@] WHERE [peer_id] = '%@' and [file_date] = '%@';",table,request.senderId,request.fileDate]];
            if(count ==0){
                NSLog(@"DB_该文件请求不存在");
                NSString *sql = [NSString stringWithFormat:@"INSERT INTO [%@] ([peer_id],[file_name],[file_date],[file_size]) VALUES ('%@','%@','%@',%d);",table,request.senderId,request.fileName,request.fileDate,request.fileSize];
                BOOL res = [db executeUpdate:sql];
                if (!res) {
                    NSLog(@"添加数据失败！");
                } else {
                    NSLog(@"添加数据成功！");
                }
            }
        }
    } @catch(NSException* e) {
        NSLog(@"%@",e.name);
    } @finally {
        [db close];
    }
}
- (NSMutableArray<fileObj*>*) selectFileRequestSQL:(NSString*) table{
    NSMutableArray<fileObj*>* list = [[NSMutableArray alloc] init];
    FMDatabase* db = nil;
    @try{
        db = [fileRequestHelper getdb];
        if([db open]){
            NSString *sql = [NSString stringWithFormat:@"SELECT * FROM [%@];",table];
            FMResultSet* cursor = [db executeQuery:sql];
            fileObj* request;
            while([cursor next]) {
                request = [[fileObj alloc] init];
                request.senderId = [cursor stringForColumn:DBConst_tableItem_peer_id];
                request.fileName = [cursor stringForColumn:DBConst_tableItem_file_name];
                request.fileDate = [cursor stringForColumn:DBConst_tableItem_file_date];
                request.fileSize = [cursor intForColumn:DBConst_tableItem_file_size];
                [list addObject:request];
            }
        }
    } @catch(NSException* e) {
        NSLog(@"%@",e.name);
    } @finally {
        [db close];
    }
    return list;
}
- (void) deleteFileRequestSQL:(NSString*) peerId Date:(NSString*)fileDate Table:(NSString*)table{
    FMDatabase* db = nil;
    @try{
        db = [fileRequestHelper getdb];
        if([db open]){
            NSString* sql = [NSString stringWithFormat:@"DELETE FROM [%@] WHERE [peer_id] = '%@' and [file_date] = '%@'",table,peerId,fileDate];
            [db executeUpdate:sql];
        }
    } @catch(NSException* e) {
        NSLog(@"%@",e.name);
    } @finally {
        [db close];
    }
}

@end
