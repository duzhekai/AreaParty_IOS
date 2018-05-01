//
//  ChatObj.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/4/25.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatObj : NSObject
@property(assign,nonatomic) int obj_id;
@property(strong,nonatomic) NSString* sender_id;
@property(strong,nonatomic) NSString* receiver_id;
@property(strong,nonatomic) NSString* msg;
@property(assign,nonatomic) long date;
@end
