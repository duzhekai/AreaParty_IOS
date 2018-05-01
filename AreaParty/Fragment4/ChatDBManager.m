//
//  ChatDBManager.m
//  AreaParty
//
//  Created by 杜哲凯 on 2017/12/26.
//  Copyright © 2017年 杜哲凯. All rights reserved.
//

#import "ChatDBManager.h"

@implementation ChatDBManager{
    ChatSQLiteHelper* chatDBHelper;
}
- (instancetype)init{
    if(self = [super init]){
        chatDBHelper = [[ChatSQLiteHelper alloc] initWithName:@"chatDB"];
    }
    return self;
}

/*
 * 离线发送消息，当接收的用户在相同手机登录时，会出现添加两次的现象，第一次为发送的时候添加，第二次为接收端登录时收到的消息
 * */
- (void) addChatSQL:(ChatObj*) chat AndTable:(NSString*) table{
    NSLog(@"DB_start add to database");
    FMDatabase* db = nil;
    @try{
        db = [chatDBHelper getdb];
        if([db open]){
            NSString *sql = [NSString stringWithFormat:@"INSERT INTO [%@] ([sender_id],[receiver_id],[msg],[date]) VALUES ('%@','%@','%@',%ld);",table,chat.sender_id,chat.receiver_id,chat.msg,chat.date];
            BOOL res = [db executeUpdate:sql];
            if (!res) {
                NSLog(@"添加数据失败！");
            } else {
                NSLog(@"添加数据成功！");
            }
        }
    } @catch(NSException* e) {
        NSLog(@"%@",e.name);
    } @finally {
        [db close];
    }
}
- (NSMutableArray<ChatObj*>*) selectMyChatSQL:(NSString*) table MyId:(NSString*) myId PeerId:(NSString*) peerId Size:(int) size{
    NSMutableArray<ChatObj*>* list = [[NSMutableArray alloc] init];
    FMDatabase* db = nil;
    NSString* limit = nil;
    if(size != -1)
        limit = [NSString stringWithFormat:@"%d",size];
    @try{
        db = [chatDBHelper getdb];
        if([db open]){
            NSString* sql = [NSString stringWithFormat:@"select * from [%@] where [sender_id] = '%@' and [receiver_id] = '%@' or [sender_id] = '%@' and [receiver_id] = '%@' order by [date] desc limit %@",table,myId,peerId,peerId,myId,limit];
            FMResultSet* cursor = [db executeQuery:sql];
            ChatObj* chat;
            while([cursor next]) {
                chat = [[ChatObj alloc] init];
                chat.obj_id = [cursor intForColumn:DBConst_tableItem_id];
                chat.sender_id = [cursor stringForColumn:DBConst_tableItem_senderID];
                chat.receiver_id = [cursor stringForColumn:DBConst_tableItem_receiverID];
                chat.msg = [cursor stringForColumn:DBConst_tableItem_msg];
                chat.date = [cursor longForColumn:DBConst_tableItem_date];
                [list addObject:chat];
            }
        }
    } @catch(NSException* e) {
        NSLog(@"%@",e.name);
    } @finally {
        [db close];
    }
    return list;
}
- (NSMutableArray<ChatObj*>*) selectMyChatSQL:(NSString*) table MyId:(NSString*) myId PeerId:(NSString*) peerId  Start:(long)startTime End:( long) endTime{
    NSMutableArray<ChatObj*>* list = [[NSMutableArray alloc] init];
    FMDatabase* db = nil;
    @try{
        db = [chatDBHelper getdb];
        if([db open]){
            NSString* sql = [NSString stringWithFormat:@"select * from [%@] where ([sender_id] = '%@' and [receiver_id] = '%@' or [sender_id] = '%@' and [receiver_id] = '%@') and [date] >= %ld and [date] <= %ld",table,myId,peerId,peerId,myId,startTime,endTime];
            FMResultSet* cursor = [db executeQuery:sql];
            ChatObj* chat;
            while([cursor next]) {
                chat = [[ChatObj alloc] init];
                chat.obj_id = [cursor intForColumn:DBConst_tableItem_id];
                chat.sender_id = [cursor stringForColumn:DBConst_tableItem_senderID];
                chat.receiver_id = [cursor stringForColumn:DBConst_tableItem_receiverID];
                chat.msg = [cursor stringForColumn:DBConst_tableItem_msg];
                chat.date = [cursor longForColumn:DBConst_tableItem_date];
                [list addObject:chat];
            }
        }
    } @catch(NSException* e) {
        NSLog(@"%@",e.name);
    } @finally {
        [db close];
    }
    return list;
}
- (void) deleteSharedFileSQL:(int) fid Table:(NSString*) table{
    FMDatabase* db = nil;
    @try{
        if([db open]){
            NSString* sql = [NSString stringWithFormat:@"DELETE FROM [%@] WHERE [%@] = %d",table,DBConst_tableItem_id,fid];
            [db executeUpdate:sql];
        }
    } @catch(NSException* e) {
        NSLog(@"%@",e.name);
    } @finally {
        [db close];
    }
}
@end
