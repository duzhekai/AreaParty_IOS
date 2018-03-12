//
//  SettingNameHandler.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/3/6.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "onHandler.h"
#import "MainTabbarController.h"
#import "Toast.h"
@class SettingNameViewController;
@interface SettingNameHandler : NSObject<onHandler>
@property (strong,nonatomic) SettingNameViewController* ctl;
- (instancetype)initWithController:(SettingNameViewController*) controller;
@end
