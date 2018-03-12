//
//  PCDevicesUIControllerViewController.h
//  AreaParty
//
//  Created by 杜哲凯 on 2017/12/28.
//  Copyright © 2017年 杜哲凯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSCRippleView.h"
#import "nowifiView.h"
#import "IPInforBean.h"
#import "NetUtil.h"
#import "PCTVTableCell.h"
#import "MyUIApplication.h"
#import "MJRefresh.h"
#import "NoWifiNoticeView.h"
#import "Fragment1ViewController.h"
#import "onHandler.h"
#import "IdentityVerify.h"
#import "onUIControllerResult.h"
#import "TVAppHelper.h"
@interface PCDevicesUIControllerViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,onHandler>{
  NSString* tag;
  int PCS_RESULTCODE;
  NSString* ISPCCHANGEDKEY;
  YSCRippleView* wifiExistDV;  // 处于Wifi下动态图
  nowifiView* noWifibgIV;  // 不处于Wifi下的静态图
    
  UITableView* devicesLV; // 处于Wifi下pc列表
  NoWifiNoticeView* noWifiNoticeLL; // 不处于Wifi下的bottom部分静态图
  NSMutableArray<IPInforBean*>* pcList;
  IPInforBean* selectedPCIPInfor;
  BOOL isPCChanged;
  IPInforBean* temp;
  NSString* code;
}
@property (strong,nonatomic) id<onUIControllerResult> pushcontroller;
@property (weak, nonatomic) IBOutlet UIView *top_view_container;
@property (weak, nonatomic) IBOutlet UIView *bottom_view_container;
@property (strong,nonatomic) AFNetworkReachabilityManager *manager;
@end
