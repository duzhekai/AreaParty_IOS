//
//  fileObj.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/4/25.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface fileObj : NSObject
@property(strong,nonatomic) NSString* fileName;
@property(strong,nonatomic) NSString* fileInfo;
@property(assign,nonatomic) int fileSize;
@property(strong,nonatomic) NSString* senderId;
@property(strong,nonatomic) NSString* receiverId;
@property(strong,nonatomic) NSString* fileDate;
@end
