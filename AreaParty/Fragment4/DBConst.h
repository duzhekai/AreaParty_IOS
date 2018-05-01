//
//  DBConst.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/4/23.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginViewController.h"
extern NSString* DBConst_tableItem_id;
extern NSString* DBConst_tableItem_senderID;
extern NSString* DBConst_tableItem_receiverID;
extern NSString* DBConst_tableItem_msg;
extern NSString* DBConst_tableItem_date;
extern NSString* DBConst_tableItem_friend_id;
extern NSString* DBConst_tableItem_friend_name;
extern NSString* DBConst_tableItem_friend_headindex;
extern NSString* DBConst_tableItem_friend_filenum;
extern NSString* DBConst_tableItem_isagree;
extern NSString* DBConst_tableItem_peer_id;
extern NSString* DBConst_tableItem_file_name;
extern NSString* DBConst_tableItem_file_date;
extern NSString* DBConst_tableItem_file_size;

@interface DBConst : NSObject
+ (NSString*)chatTB;
+ (NSString*)friendTB;
+ (NSString*)fileRequestTB;
@end
