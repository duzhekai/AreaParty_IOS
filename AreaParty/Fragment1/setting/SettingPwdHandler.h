//
//  SettingPwdHandler.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/3/6.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SettingPwdViewController.h"
#import "onHandler.h"
#import "MyUIApplication.h"
#import "Toast.h"
@interface SettingPwdHandler : NSObject<onHandler>
@property (strong,nonatomic) SettingPwdViewController* ctl;
- (instancetype)initWithController:(SettingPwdViewController*) controller;
@end
