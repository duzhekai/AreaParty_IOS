//
//  TvPlayerChangeEvent.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/1/5.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "TvPlayerChangeEvent.h"

@implementation TvPlayerChangeEvent

- (instancetype) initWithIsRun:(BOOL)isrun{
    self = [super init];
    if(self){
        isPlayerRun = isrun;
    }
    return self;
}
- (BOOL)isPlayerRun{
    return isPlayerRun;
}

@end
