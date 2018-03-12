//
//  Update_ReceiveMsgBean.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/3/5.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "Update_ReceiveMsgBean.h"

@implementation Update_ReceiveMsgBean


- (instancetype)initWithisNew:(BOOL) isnew version:(NSString*)version url:(NSString*)url{
    self = [super init];
    if(self){
        _isNew = isnew;
        _version = version;
        _url = url;
    }
    return self;
}
- (BOOL)isEmpty{
    if(_version && _url){
        return _isNew && [_version isEqualToString:@""] && [_url isEqualToString:@""];
    }
    else
        return YES;
}
@end
