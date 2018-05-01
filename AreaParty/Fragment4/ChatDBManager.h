//
//  ChatDBManager.h
//  AreaParty
//
//  Created by 杜哲凯 on 2017/12/26.
//  Copyright © 2017年 杜哲凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChatSQLiteHelper.h"
#import "ChatObj.h"
#import <FMDB/FMDB.h>
#import "DBConst.h"
@interface ChatDBManager : NSObject
- (void) addChatSQL:(ChatObj*) chat AndTable:(NSString*) table;
- (NSMutableArray<ChatObj*>*) selectMyChatSQL:(NSString*) table MyId:(NSString*) myId PeerId:(NSString*) peerId Size:(int) size;
- (NSMutableArray<ChatObj*>*) selectMyChatSQL:(NSString*) table MyId:(NSString*) myId PeerId:(NSString*) peerId  Start:(long)startTime End:( long) endTime;
- (void) deleteSharedFileSQL:(int) fid Table:(NSString*) table;
@end
