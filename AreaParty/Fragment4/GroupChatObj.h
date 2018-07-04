//
//  GroupChatObj.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/7/2.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GroupChatObj : NSObject
@property(assign,nonatomic) int gid;
@property(strong,nonatomic) NSString* sender_id;
@property(strong,nonatomic) NSString* receiver_id;
@property(strong,nonatomic) NSString* msg;
@property(assign,nonatomic) long date;
@property(strong,nonatomic) NSString* group_id;
@end
