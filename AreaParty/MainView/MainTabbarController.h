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
#import "downloadManager.h"
#import "Fragment4ViewController.h"
#import "DownloadFolderFragment.h"
#import "DownloadStateFragment.h"
@class FriendRequestDBManager;
@class FileRequestDBManager;
@class ChatDBManager;
extern MyHandler* MainTabbarController_handlerTab01;
extern MyHandler* MainTabbarController_handlerTab06;
extern MyHandler* MainTabbarController_btHandler;
extern MyHandler* MainTabbarController_downloadHandler;
extern MyHandler* MainTabbarController_stateHandler;
extern DownloadFolderFragment* MainTabbarController_DownloadFolderFragment;
extern DownloadStateFragment* MainTabbarController_DownloadStateFragment;
@interface MainTabbarController : UITabBarController<UITabBarControllerDelegate>
@property(strong,nonatomic) UIPanGestureRecognizer* panGestureRecognizer;
@property(strong,nonatomic) NSDictionary* intentbundle;
+ (FriendRequestDBManager*)getFriendRequestDBManager;
+ (FileRequestDBManager*)getFileRequestDBManager;
+ (ChatDBManager*) getChatDBManager;
+ (NSUserDefaults*) getSp;
@end

