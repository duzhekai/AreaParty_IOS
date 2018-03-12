//
//  SettingAddressHandler.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/3/7.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SettingAddressViewController.h"
@interface SettingAddressHandler : NSObject<onHandler>
@property (strong,nonatomic) SettingAddressViewController* ctl;
- (instancetype)initWithController:(SettingAddressViewController*) controller;
@end
