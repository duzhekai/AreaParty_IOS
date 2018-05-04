//
//  downloadedFileBean.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/5/4.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface downloadedFileBean : NSObject
@property(strong,nonatomic) NSString* name;
@property(strong,nonatomic) NSString* sizeInfor;
@property(assign,nonatomic) long createTimeLong;
@property(strong,nonatomic) NSString* createTimeStr;
@property(assign,nonatomic) int timeLength;
@property(strong,nonatomic) NSString* timeLenStr;
@property(assign,nonatomic) int fileType;
@property(strong,nonatomic) NSString* path;
@end
