//
//  MediaSetBean.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/3/28.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "MediaSetBean.h"

@implementation MediaSetBean
- (instancetype)init{
    if(self = [super init]){
        _name = @"";
        _numInfor = @"0首";
        _thumbnailURL = @"";
    }
    return self;
}
@end
