//
//  GroupChatDBManager.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/7/2.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "GroupChatDBManager.h"

@implementation GroupChatDBManager{
    ChatSQLiteHelper* chatDBHelper;
}
- (instancetype)init{
    if(self = [super init]){
        chatDBHelper = [[ChatSQLiteHelper alloc] initWithName:@"chatDB"];
    }
    return self;
}
- (void) addGroupChatSQL:(GroupChatObj*) chat Table:(NSString*) table{
    NSLog(@"DB_start add to database");
    FMDatabase* db = nil;
    @try{
        db = [chatDBHelper getdb];
        if([db open]){
            NSString *sql = [NSString stringWithFormat:@"INSERT INTO [%@] ([sender_id],[receiver_id],[msg],[date],[group_id]) VALUES ('%@','%@','%@',%ld,'%@');",table,chat.sender_id,chat.receiver_id,chat.msg,chat.date,chat.group_id];
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
- (NSMutableArray<GroupChatObj*>*) selectMyGroupChatSQL:(NSString*) table MyId:(NSString*) myId GroupId:(NSString*) groupId Size:(int) size{
    NSMutableArray<GroupChatObj*>* list = [[NSMutableArray alloc] init];
    FMDatabase* db = nil;
    NSString* limit = nil;
    if(size != -1)
        limit = [NSString stringWithFormat:@"%d",size];
    @try{
        db = [chatDBHelper getdb];
        if([db open]){
            NSString* sql = [NSString stringWithFormat:@"select * from [%@] where [sender_id] = '%@' and [receiver_id] = '%@' and [group_id] = '%@' order by [date] desc limit %@",table,myId,groupId,groupId,limit];
            FMResultSet* cursor = [db executeQuery:sql];
            GroupChatObj* chat;
            while([cursor next]) {
                chat = [[GroupChatObj alloc] init];
                chat.gid = [cursor intForColumn:DBConst_tableItem_id];
                chat.sender_id = [cursor stringForColumn:DBConst_tableItem_senderID];
                chat.receiver_id = [cursor stringForColumn:DBConst_tableItem_receiverID];
                chat.msg = [cursor stringForColumn:DBConst_tableItem_msg];
                chat.date = [cursor longForColumn:DBConst_tableItem_date];
                chat.group_id = [cursor stringForColumn:DBConst_tableItem_groupId];
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
- (NSMutableArray<ChatObj*>*) selectMyGroupChatSQL:(NSString*) table GroupId:(NSString*) groupId Start:(long)startTime End:( long) endTime{
    NSMutableArray<ChatObj*>* list = [[NSMutableArray alloc] init];
    FMDatabase* db = nil;
    @try{
        db = [chatDBHelper getdb];
        if([db open]){
            NSString* sql = [NSString stringWithFormat:@"select * from [%@] where ([group_id] = '%@') and [date] >= %ld and [date] <= %ld",table,groupId,startTime,endTime];
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
@end
