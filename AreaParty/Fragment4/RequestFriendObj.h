//
//  RequestFriendObj.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/4/24.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestFriendObj : NSObject
@property(strong,nonatomic) NSString* friend_id;
@property(strong,nonatomic) NSString* friend_name;
@property(assign,nonatomic) int friend_headindex;
@property(assign,nonatomic) int friend_filenum;
@property(assign,nonatomic) int isagree;
- (instancetype)initWithId:(NSString*)fid Name:(NSString*)fname HeadIndex:(int)headindex filenum:(int) num Agree:(int) isagree;
@end
