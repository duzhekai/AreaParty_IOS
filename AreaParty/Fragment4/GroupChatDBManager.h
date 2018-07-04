//
//  GroupChatDBManager.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/7/2.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB/FMDB.h>
#import "DBConst.h"
#import "GroupChatObj.h"
@interface GroupChatDBManager : NSObject
- (void) addGroupChatSQL:(GroupChatObj*) chat Table:(NSString*) table;
- (NSMutableArray<GroupChatObj*>*) selectMyGroupChatSQL:(NSString*) table MyId:(NSString*) myId GroupId:(NSString*) groupId Size:(int) size;
- (NSMutableArray<ChatObj*>*) selectMyGroupChatSQL:(NSString*) table GroupId:(NSString*) groupId Start:(long)startTime End:( long) endTime;
@end
