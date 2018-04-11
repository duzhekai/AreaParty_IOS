//
//  PCCommandItem.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/1/2.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYModel.h"
@interface PCCommandItem : NSObject
@property(strong,nonatomic) NSString* command;
@property(strong,nonatomic) NSString* name;
@property(strong,nonatomic) NSMutableDictionary* param;
@end
