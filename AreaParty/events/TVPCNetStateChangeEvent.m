//
//  TVPCNetStateChangeEvent.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/1/5.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "TVPCNetStateChangeEvent.h"

@implementation TVPCNetStateChangeEvent

- (instancetype)initWithTVOnline:(BOOL)istvonline andPCOnline:(BOOL)ispconline{
    self = [super init];
    if(self){
        isTVOnline = istvonline;
        isPCOnline = ispconline;
    }
    return self;
}
-(BOOL)isTVOnline{
    return isTVOnline;
}
-(BOOL)isPCOnline{
    return isPCOnline;
}
@end
