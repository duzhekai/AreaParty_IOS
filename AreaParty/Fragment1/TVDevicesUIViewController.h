//
//  TVDevicesUIViewController.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/1/21.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "onHandler.h"
#import "YSCRippleView.h"
#import "nowifiView.h"
#import "NoWifiNoticeView.h"
#import "IPInforBean.h"
#import "onUIControllerResult.h"
#import "AFNetworking.h"
#import "MyUIApplication.h"
#import "MJRefresh.h"
#import "NetUtil.h"
#import "IdentityVerify.h"
#import "PCTVTableCell.h"
@interface TVDevicesUIViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,onHandler>{
    NSString* tag;
    int TVS_RESULTCODE;
    NSString* ISTVCHANGEDKEY;
    YSCRippleView* wifiExistDV;  // 处于Wifi下动态图
    nowifiView* noWifibgIV;  // 不处于Wifi下的静态图
    
    UITableView* devicesLV; // 处于Wifi下tv列表
    NoWifiNoticeView* noWifiNoticeLL; // 不处于Wifi下的bottom部分静态图
    NSMutableArray<IPInforBean*>* tvList;
    IPInforBean* selectedTVIPInfor;
    BOOL isTVChanged;
    IPInforBean* temp;
    NSString* code;
}
@property (strong,nonatomic) id<onUIControllerResult> pushcontroller;
@property (weak, nonatomic) IBOutlet UIView *top_view_container;
@property (weak, nonatomic) IBOutlet UIView *bottom_view_container;
@property (strong,nonatomic) AFNetworkReachabilityManager *manager;
@end
