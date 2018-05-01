//
//  RequestFriendObj.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/4/24.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "RequestFriendObj.h"

@implementation RequestFriendObj
- (instancetype)initWithId:(NSString*)fid Name:(NSString*)fname HeadIndex:(int)headindex filenum:(int) num Agree:(int) isagree{
    if(self = [super init]){
        _friend_id = fid;
        _friend_name = fname;
        _friend_filenum = num;
        _friend_headindex = headindex;
        _isagree = isagree;
    }
    return self;
}
@end
