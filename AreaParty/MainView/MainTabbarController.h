//
//  MainTabbarController.h
//  AreaParty
//
//  Created by 杜哲凯 on 2017/11/13.
//  Copyright © 2017年 杜哲凯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyUIApplication.h"
#import "LoginViewController.h"
#import "OrderConst.h"
#import "Fragment1ViewController.h"
#import "MyHandler.h"
@interface MainTabbarController : UITabBarController<UITabBarControllerDelegate>
@property(strong,nonatomic) UIPanGestureRecognizer* panGestureRecognizer;
@property(strong,nonatomic) NSDictionary* intentbundle;
+ (MyHandler*)getMyhandler;
@end

