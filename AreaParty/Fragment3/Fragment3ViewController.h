//
//  Fragment3ViewController.h
//  AreaParty
//
//  Created by 杜哲凯 on 2017/11/13.
//  Copyright © 2017年 杜哲凯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "onHandler.h"
#import "MyUIApplication.h"
#import "PCAppHelper.h"
#import "TVAppHelper.h"
#import "cellView.h"
@interface Fragment3ViewController : UIViewController<onHandler,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
//页面选择容器视图
@property (weak, nonatomic) IBOutlet UIView *TVBarView;
@property (weak, nonatomic) IBOutlet UIView *PCBarView;
// 页面选择按钮
@property (weak, nonatomic) IBOutlet UILabel *TVBarTV;
@property (weak, nonatomic) IBOutlet UILabel *PCBarTV;
//页面选择的按钮的容器视图，用于设置圆角和边框
@property (weak, nonatomic) IBOutlet UIView *middle_button_view;
// TV内容页面
@property (weak, nonatomic) IBOutlet UIView *TVInforLL;
@property (weak, nonatomic) IBOutlet UIView *TVRestartLL;
@property (weak, nonatomic) IBOutlet UIView *TVShutdownLL;
@property (weak, nonatomic) IBOutlet UIView *TVDevicesLL;
@property (weak, nonatomic) IBOutlet UIView *TVUninstallAppLL;
@property (weak, nonatomic) IBOutlet UIView *TVSettingLL;
@property (weak, nonatomic) IBOutlet UIButton *TVRestartBtn;
@property (weak, nonatomic) IBOutlet UIButton *TVShutdownBtn;
@property (weak, nonatomic) IBOutlet UIButton *TVDevicesBtn;
@property (weak, nonatomic) IBOutlet UIButton *TVUninstallAppBtn;
@property (weak, nonatomic) IBOutlet UIButton *TVSettingBtn;
@property (weak, nonatomic) IBOutlet UIButton *TVInfoBtn;
- (IBAction)onclick:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *TVPageSV; //TV界面的滚动视图
@property (weak, nonatomic) IBOutlet UIView *TVPageView; //整个TV界面的视图
@property (weak, nonatomic) IBOutlet UIView *TVInstalledAppSGV_container;//TV已安装应用的容器视图
@property (weak, nonatomic) IBOutlet UICollectionView *TVInstalledAppSGV;//TV已安装应用
@property (weak, nonatomic) IBOutlet UIView *TVOwnAppSGV_container;//TV自带应用容器视图
@property (weak, nonatomic) IBOutlet UICollectionView *TVOwnAppSGV;//TV自带应用

@end
