//
//  Send2TVThread.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/1/6.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IPInforBean.h"
#import "MyUIApplication.h"
@interface Send2TVThread : NSThread{
     NSString* cmd;
     const NSString* tag;
}
-(instancetype)initWithCmd:(NSString*)cmd_;
@end
