//
//  changeSelectedDeviceNameEvent.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/1/5.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "changeSelectedDeviceNameEvent.h"

@implementation changeSelectedDeviceNameEvent
- (instancetype) initWithName:(NSString*)name{
    self = [super init];
    if(self){
        name = name;
    }
    return self;
}
-(NSString*) getName{
    return name;
}
@end
