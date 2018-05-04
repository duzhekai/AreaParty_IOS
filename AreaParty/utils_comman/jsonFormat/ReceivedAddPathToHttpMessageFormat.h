//
//  ReceivedAddPathToHttpMessageFormat.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/5/2.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReceivedAddPathToHttpMessageFormat : NSObject
@property(assign,nonatomic) int status;
@property(strong,nonatomic) NSString* message;
@property(strong,nonatomic) NSString* name;
@property(strong,nonatomic) NSArray<NSString*>* data;
@end
