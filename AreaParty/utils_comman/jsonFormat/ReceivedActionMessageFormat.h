//
//  ReceivedActionMessageFormat.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/1/2.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYModel.h"
@interface ReceivedActionMessageFormat : NSObject
@property(assign,nonatomic) int status;
@property(strong,nonatomic) NSString* message;
@property(strong,nonatomic) NSString* data;
@property(strong,nonatomic) NSString* name;
@end
