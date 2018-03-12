//
//  MyHandler.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/3/6.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "onHandler.h"
@class  MainTabbarController;
@interface MyHandler : NSObject<onHandler>
@property (strong,nonatomic) MainTabbarController* maincontroller;
- (instancetype)initWithController:(MainTabbarController*) controller;
@end
