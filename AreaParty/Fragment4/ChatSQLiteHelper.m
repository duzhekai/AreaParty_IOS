//
//  ChatSQLiteHelper.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/4/23.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "ChatSQLiteHelper.h"

@implementation ChatSQLiteHelper{
    FMDatabase* db;
}

- (instancetype)initWithName:(NSString*) dbName{
    if(self = [super init]){
        NSString* dbpath = [NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@.db",dbName]];
        db = [FMDatabase databaseWithPath:dbpath];
        if([db open]){
            NSLog(@"数据库连接成功！");
            BOOL b1 = [self createChatTables:[DBConst chatTB]];
            BOOL b2 = [self createFriendTables:[DBConst friendTB]];
            BOOL b3 = [self createFileRequestTables:[DBConst fileRequestTB]];
            BOOL b4 = [self createGroupTables:[DBConst groupchatTB]];
        }
    }
    return self;
}
- (BOOL)createChatTables:(NSString*) table_name{
    NSMutableString* sBuffer = [[NSMutableString alloc] init];
    [sBuffer appendString:@"CREATE TABLE IF NOT EXISTS["];
    [sBuffer appendString:table_name];
    [sBuffer appendString:@"] ("];  //创建表和定义表明
    [sBuffer appendString:@"[_id] INTEGER PRIMARY KEY AUTOINCREMENT, "];        //设置_id为主键，不能为空与自增性质
    [sBuffer appendString:@"[sender_id] TEXT,"];                                //发送者id
    [sBuffer appendString:@"[receiver_id] TEXT,"];                              //接收者id
    [sBuffer appendString:@"[msg] TEXT,"];                                      //信息
    [sBuffer appendString:@"[date] INTEGER)"];                                  //发送或接收时间
    return [db executeUpdate:sBuffer];
}
- (BOOL) createGroupTables:(NSString*) table_name{
    NSMutableString* sBuffer = [[NSMutableString alloc] init];
    [sBuffer appendString:@"CREATE TABLE IF NOT EXISTS["];
    [sBuffer appendString:table_name];
    [sBuffer appendString:@"] ("];  //创建表和定义表明
    [sBuffer appendString:@"[_id] INTEGER PRIMARY KEY AUTOINCREMENT, "];        //设置_id为主键，不能为空与自增性质
    [sBuffer appendString:@"[sender_id] TEXT,"];                                //发送者id
    [sBuffer appendString:@"[receiver_id] TEXT,"];                              //接收者id
    [sBuffer appendString:@"[msg] TEXT,"];                                      //信息
    [sBuffer appendString:@"[date] INTEGER,"];                                  //发送或接收时间
    [sBuffer appendString:@"[group_id] TEXT)"];
    return [db executeUpdate:sBuffer];
}
- (BOOL)createFriendTables:(NSString*) table_name {
    NSMutableString* sBuffer = [[NSMutableString alloc] init];
    [sBuffer appendString:@"CREATE TABLE IF NOT EXISTS["];
    [sBuffer appendString:table_name];
    [sBuffer appendString:@"] ("];  //创建表和定义表明
    [sBuffer appendString:@"[friend_id] TEXT,"];                                //请求者id
    [sBuffer appendString:@"[friend_name] TEXT,"];                              //请求者name
    [sBuffer appendString:@"[friend_headindex] INTEGER,"];                      //请求者头像
    [sBuffer appendString:@"[friend_filenum] INTEGER,"];                        //请求者文件数
    [sBuffer appendString:@"[isagree] INTEGER)"];                               //是否已接受请求
    return [db executeUpdate:sBuffer];
}
- (BOOL)createFileRequestTables:(NSString*) table_name {
    NSMutableString* sBuffer = [[NSMutableString alloc] init];
    [sBuffer appendString:@"CREATE TABLE IF NOT EXISTS["];
    [sBuffer appendString:table_name];
    [sBuffer appendString:@"] ("];  //创建表和定义表明
    [sBuffer appendString:@"[peer_id] TEXT,"];                                //请求者id
    [sBuffer appendString:@"[file_name] TEXT,"];                              //请求文件的name
    [sBuffer appendString:@"[file_date] INTEGER,"];                           //请求文件的date
    [sBuffer appendString:@"[file_size] TEXT)"];                              //请求文件的size
    return [db executeUpdate:sBuffer];
}

- (FMDatabase*) getdb{
    return db;
}
@end
