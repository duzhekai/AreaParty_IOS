//
//  RequestFormat.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/1/5.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestFormat : NSObject
@property(strong,nonatomic) NSString* name;
@property(strong,nonatomic) NSString* command;
@property(strong,nonatomic) NSString* param;
@end
