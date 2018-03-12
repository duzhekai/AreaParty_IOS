//
//  MediaItem.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/1/18.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "MediaItem.h"

@implementation MediaItem
- (BOOL) equals:(MediaItem*) item {
    return [item.name isEqualToString:self.name] && [item.pathName isEqualToString:self.pathName];
}
- (instancetype)initWithName:(NSString*)name1 andType:(NSString*)type1{
    if(self = [super init]){
        self.name = name1;
        self.type = type1;
    }
    return self;
}

@end
