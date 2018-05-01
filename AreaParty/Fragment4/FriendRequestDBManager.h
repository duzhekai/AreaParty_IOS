//
//  FriendRequestDBManager.h
//  AreaParty
//
//  Created by 杜哲凯 on 2017/12/26.
//  Copyright © 2017年 杜哲凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChatSQLiteHelper.h"
#import "RequestFriendObj.h"
#import <FMDB/FMDB.h>
#import "DBConst.h"
@interface FriendRequestDBManager : NSObject
- (void) addRequestFriendSQL:(RequestFriendObj*) request AndTable:(NSString*)table;
- (NSMutableArray<RequestFriendObj*>*) selectRequestFriendSQL:(NSString*) table;
- (void) changeRequestStateSQL:(RequestFriendObj*) request Table:(NSString*) table;
@end
