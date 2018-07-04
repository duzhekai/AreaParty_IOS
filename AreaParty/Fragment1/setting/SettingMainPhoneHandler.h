//
//  SettingMainPhoneHandler.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/7/3.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SettingMainPhoneViewController.h"
#import "onHandler.h"
@interface SettingMainPhoneHandler : NSObject<onHandler>
@property (strong,nonatomic) SettingMainPhoneViewController* ctl;
- (instancetype)initWithController:(SettingMainPhoneViewController*) controller;
@end
