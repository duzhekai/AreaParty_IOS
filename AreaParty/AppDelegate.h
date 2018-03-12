//
//  AppDelegate.h
//  AreaParty
//
//  Created by 杜哲凯 on 2017/11/5.
//  Copyright © 2017年 杜哲凯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCDAsyncUdpSocket.h"
#import "FillingIPInforList.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate,GCDAsyncUdpSocketDelegate>


@property (strong, nonatomic) UIWindow *window;


@end

