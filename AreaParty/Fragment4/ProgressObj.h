//
//  ProgressObj.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/6/27.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProgressObj : NSObject
@property(strong,nonatomic) NSString* fileName;
@property(strong,nonatomic) NSString* fileSize;
@property(strong,nonatomic) NSString* fileTotalSize;
@property(strong,nonatomic) NSString* progress;
@property(assign,nonatomic) int state;
@end
