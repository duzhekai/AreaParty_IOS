//
//  groupObj.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/7/2.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface groupObj : NSObject
@property(strong,nonatomic) NSString* groupId;
@property(strong,nonatomic) NSString* groupName;
@property(strong,nonatomic) NSString* groupCreateId;
@property(strong,nonatomic) NSMutableArray<NSString*>* memberUserId;
@end
