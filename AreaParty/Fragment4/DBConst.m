//
//  DBConst.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/4/23.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "DBConst.h"
NSString* DBConst_tableItem_id     = @"_id";
NSString* DBConst_tableItem_senderID   = @"sender_id";
NSString* DBConst_tableItem_receiverID   = @"receiver_id";
NSString* DBConst_tableItem_msg   = @"msg";
NSString* DBConst_tableItem_date    = @"date";

NSString* DBConst_tableItem_friend_id = @"friend_id";
NSString* DBConst_tableItem_friend_name = @"friend_name";
NSString* DBConst_tableItem_friend_headindex = @"friend_headindex";
NSString* DBConst_tableItem_friend_filenum = @"friend_filenum";
NSString* DBConst_tableItem_isagree = @"isagree";

NSString* DBConst_tableItem_peer_id = @"peer_id";
NSString* DBConst_tableItem_file_name = @"file_name";
NSString* DBConst_tableItem_file_date = @"file_date";
NSString* DBConst_tableItem_file_size = @"file_size";
@implementation DBConst

+ (NSString*)chatTB{
    return Login_userId;
}
+ (NSString*)friendTB{
    return [NSString stringWithFormat:@"%@friend",Login_userId];
}
+ (NSString*)fileRequestTB{
    return [NSString stringWithFormat:@"%@transform",Login_userId];
}
@end
