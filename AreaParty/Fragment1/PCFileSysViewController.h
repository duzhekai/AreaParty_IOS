//
//  PCFileSysViewController.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/1/24.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AVLoadingIndicatorView.h"
#import "DiskInformat.h"
#import "MyUIApplication.h"
#import "ReceivedDiskListFormat.h"
#import "prepareDataForFragment.h"
#import "onHandler.h"
#import "OrderConst.h"
#import "LoginViewController.h"
#import "PCFileHelper.h"
#import "FileSysDiskListCell.h"
#import "diskContentVC.h"
#import "downloadTab01Fragment.h"
#import "downloadTab02Fragment.h"
extern NSMutableArray<DiskInformat*>* PCFileSysViewController_diskDatas;
extern NSMutableArray<DiskInformat*>* PCFileSysViewController_diskDatasList;
extern NSMutableArray<DiskInformat*>* PCFileSysViewController_diskNetworkDatasList;

@interface PCFileSysViewController : UIViewController<onHandler,UITableViewDelegate,UITableViewDataSource>{
    NSString* disk_SYS;
    NSString* disk_Fixed;
    NSString* disk_Removable;
    NSString* disk_Network;
}
@property (weak, nonatomic) IBOutlet UIView *page04CutCancelLL;
@property (weak, nonatomic) IBOutlet UIView *page04CutBarLL;
@property (weak, nonatomic) IBOutlet UIView *page04CopyBarLL;
@property (weak, nonatomic) IBOutlet UIView *page04CopyCancelLL;
@property (weak, nonatomic) IBOutlet UIView *page04NASRootLL;
- (IBAction)press_backbutton:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll_view;
@property (weak, nonatomic) IBOutlet UITableView *diskList;
@property (weak, nonatomic) IBOutlet UIView *page04LocalFolderRootLL;
@property (weak, nonatomic) IBOutlet UIView *page04SharedFilesRootLL;
@property (weak, nonatomic) IBOutlet UIView *page04DiskListMoreLL;
@property (weak, nonatomic) IBOutlet UIView *page04DiskListRefreshLL;
@property (weak, nonatomic) IBOutlet UIView *page04DiskListActionBarLL;
@property (strong,nonatomic) AVLoadingIndicatorView* page04LoadingAVLIV;// 上方加载动画的控件
+ (void) handleDatas;
@end
