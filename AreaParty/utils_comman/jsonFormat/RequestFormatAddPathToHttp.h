//
//  RequestFormatAddPathToHttp.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/5/2.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AddPathToHttpParamBean.h"
@interface RequestFormatAddPathToHttp : NSObject
@property(strong,nonatomic) NSString* name;
@property(strong,nonatomic) NSString* command;
@property(strong,nonatomic) AddPathToHttpParamBean* param;
@end
