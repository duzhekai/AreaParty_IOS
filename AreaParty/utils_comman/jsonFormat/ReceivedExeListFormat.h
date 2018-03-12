//
//  ReceivedExeListFormat.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/3/8.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ExeInformat.h"
@interface ReceivedExeListFormat : NSObject
@property(assign,nonatomic) int status;
@property(strong,nonatomic)  NSString* message;
@property(strong,nonatomic)  NSMutableArray<ExeInformat*>* data;

@end
