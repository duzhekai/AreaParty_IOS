//
//  SelectedDeviceChangedEvent.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/1/5.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "SelectedDeviceChangedEvent.h"

@implementation SelectedDeviceChangedEvent

- (instancetype)initWithOnline:(BOOL)isonline andDevice:(IPInforBean*) mdevice{
    self = [super init];
    if(self){
        isDeviceOnline = isonline;
        device = mdevice;
    }
    return self;
}
-(BOOL) isDeviceOnline{
    return isDeviceOnline;
}
-(IPInforBean*)getDevice{
    return device;
}
@end
