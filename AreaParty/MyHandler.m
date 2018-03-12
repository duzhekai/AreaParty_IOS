//
//  MyHandler.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/3/6.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "MyHandler.h"
#import "MainTabbarController.h"
@implementation MyHandler
- (instancetype)initWithController:(MainTabbarController*) controller{
    self = [super init];
    if(self){
        _maincontroller = controller;
    }
    return self;
}
- (void)onHandler:(NSDictionary *)message{
    switch ([[message objectForKey:@"what"] intValue]) {
        //set_username
        case 0x119:{
            Fragment1ViewController* tab1 = (Fragment1ViewController*)_maincontroller.viewControllers[0];
            [tab1 setUserName:message];
            break;
        }
        default:
            break;
    }
}
@end
