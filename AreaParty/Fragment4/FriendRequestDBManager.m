//
//  FriendRequestDBManager.m
//  AreaParty
//
//  Created by 杜哲凯 on 2017/12/26.
//  Copyright © 2017年 杜哲凯. All rights reserved.
//

#import "FriendRequestDBManager.h"

@implementation FriendRequestDBManager{
    ChatSQLiteHelper* friendDBHelper;
}
- (instancetype)init{
    if(self = [super init]){
        friendDBHelper = [[ChatSQLiteHelper alloc] initWithName:@"chatDB"];
    }
    return self;
}
/*
 * 添加一条好友请求
 *
 */
-(void)addRequestFriendSQL:(RequestFriendObj*) request AndTable:(NSString*)table {
    NSLog(@"DB_start add to database");
    FMDatabase* db = nil;
    @try{
        db = [friendDBHelper getdb];
        if([db open]){
            NSLog(@"数据书打开成功");
            int count = [db intForQuery:[NSString stringWithFormat:@"SELECT COUNT(*) FROM [%@] WHERE [friend_id] = '%@';",table,request.friend_id]];
            if(count == 0){
                NSLog(@"该好友请求不存在");
                NSString *sql = [NSString stringWithFormat:@"INSERT INTO [%@] ([friend_id],[friend_name],[friend_headindex],[friend_filenum],[isagree])VALUES ('%@','%@',%d,%d,%d);",table,request.friend_id,request.friend_name,request.friend_headindex,request.friend_filenum,request.isagree];
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
- (NSMutableArray<RequestFriendObj*>*) selectRequestFriendSQL:(NSString*) table{
    NSMutableArray<RequestFriendObj*>* list = [[NSMutableArray alloc] init];
    FMDatabase* db = nil;
    @try{
        db = [friendDBHelper getdb];
        if([db open]){
            NSLog(@"数据书打开成功");
            NSString *sql = [NSString stringWithFormat:@"SELECT * FROM [%@] WHERE [isagree] = 0;",table];
            FMResultSet* cursor = [db executeQuery:sql];
            RequestFriendObj* request;
            while([cursor next]) {
                request = [[RequestFriendObj alloc] init];
                request.friend_id = [cursor stringForColumn:DBConst_tableItem_friend_id];
                request.friend_name = [cursor stringForColumn:DBConst_tableItem_friend_name];
                request.friend_headindex =[cursor intForColumn:DBConst_tableItem_friend_headindex];
                request.friend_filenum = [cursor intForColumn:DBConst_tableItem_friend_filenum];
                request.isagree = [cursor intForColumn:DBConst_tableItem_isagree];
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
- (void) changeRequestStateSQL:(RequestFriendObj*) request Table:(NSString*) table{
    FMDatabase* db = nil;
    NSLog(@"DB_开始更改好友请求");
    @try{
        db = [friendDBHelper getdb];
        if([db open]){
            NSLog(@"数据书打开成功");
            NSString *sql = [NSString stringWithFormat:@"UPDATE [%@] SET [friend_id] = '%@',[friend_name]= '%@',[friend_headindex] = %d,[friend_filenum] = %d,[isagree] = %d WHERE [friend_id] = '%@'",table,request.friend_id,request.friend_name,request.friend_headindex,request.friend_filenum,request.isagree,request.friend_id];
            
            NSLog(@"DB_update start");
            [db executeUpdate:sql];
            NSLog(@"DB_update finish");
        }
    } @catch(NSException* e) {
        NSLog(@"%@",e.name);
    } @finally {
        [db close];
    }
}
@end
