//
//  userObj.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/4/19.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FileData.pbobjc.h"
@interface userObj : NSObject
@property(strong,nonatomic) NSString* userId;
@property(strong,nonatomic) NSString* userName;
@property(assign,nonatomic) BOOL isFriend;
@property(assign,nonatomic) int  fileNum;
@property(assign,nonatomic) BOOL isOnline;
@property(assign,nonatomic) int headIndex;
@property(strong,nonatomic) NSMutableArray<FileItem*>* shareFiles;
@property(strong,nonatomic) NSString* chatMsg;
@end
