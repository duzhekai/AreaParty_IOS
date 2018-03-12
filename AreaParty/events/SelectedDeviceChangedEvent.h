//
//  SelectedDeviceChangedEvent.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/1/5.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IPInforBean.h"
@interface SelectedDeviceChangedEvent : NSObject{
     BOOL isDeviceOnline;
     IPInforBean* device;
}
- (instancetype)initWithOnline:(BOOL)isonline andDevice:(IPInforBean*) mdevice;
-(BOOL) isDeviceOnline;
-(IPInforBean*)getDevice;
@end
