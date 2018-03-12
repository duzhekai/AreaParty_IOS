//
//  AppItem.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/1/7.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "AppItem.h"

@implementation AppItem

- (BOOL)isEqual:(id)other
{
    if (other == self) {
        return YES;
    }
    if (other == nil){
        return NO;
    }
    if (![other isKindOfClass:[self class]]) {
        return NO;
    }
    AppItem* temp = (AppItem*) other;
    if(self.packageName != temp.packageName){
        return false;
    }
    if(self.appName != temp.appName){
        return false;
    }
    return true;
}

- (NSUInteger)hash
{
    int prime = 31;
    int result = 1;
    result = prime * result + (int)[self.appName hash];
    result = prime * result + (int)[self.packageName hash];
    return result;
}

@end
