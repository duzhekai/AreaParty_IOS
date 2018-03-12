//
//  Update_SendMsgBean.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/3/5.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "Update_SendMsgBean.h"

@implementation Update_SendMsgBean
- (instancetype)initWithType:(NSString*) type Version:(NSString*) version{
    self = [super init];
    if(self){
        _version = version;
        _type = type;
    }
    return self;
}
@end
