//
//  TVInforBean.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/1/14.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "TVInforBean.h"

@implementation TVInforBean
- (instancetype)init{
    self = [super init];
    self.brand =@"";
    self.model=@"";
    self.totalStorage=@"";
    self.freeStorage=@"";
    self.totalMemory=@"";
    self.resolution=@"";
    self.androidVersion=@"";
    self.isRoot=@"";
    return self;
}
-(BOOL) isEmpty {
    return [self.brand isEqualToString:@""] &&
    [self.model isEqualToString:@""] &&
    [self.totalStorage isEqualToString:@""] &&
    [self.freeStorage isEqualToString:@""] &&
    [self.totalMemory isEqualToString:@""] &&
    [self.resolution isEqualToString:@""] &&
    [self.androidVersion isEqualToString:@""] &&
    [self.isRoot isEqualToString:@""];
}
@end
