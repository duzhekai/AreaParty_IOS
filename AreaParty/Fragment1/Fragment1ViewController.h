//
//  Fragment1ViewController.h
//  AreaParty
//
//  Created by 杜哲凯 on 2017/11/13.
//  Copyright © 2017年 杜哲凯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "onUIControllerResult.h"
#import "tvpcAppHelper.h"
#import "changeSelectedDeviceNameEvent.h"
#import "cellView.h"
#import "TVPCNetStateChangeEvent.h"
#import "TVDevicesUIViewController.h"
#import "PCFileSysViewController.h"
#import "MainTabbarController.h"
#import "headIndexToImgId.h"
#import "TVAppHelper.h"
#import "PCAppHelper.h"
#import "onHandler.h"
#import "SettingMainViewController.h"
#import "SettingNavigationVC.h"
@interface Fragment1ViewController : UIViewController<onUIControllerResult,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate,onHandler>{
    NSString* tag;
    int PCS_RESULTCODE;
    int PCS_REQUESTCODE;
    int TVS_RESULTCODE;
    int TVS_REQUESTCODE;
    NSString* ISPCCHANGEDKEY;
    NSString* ISTVCHANGEDKEY;
    BOOL outline;
    BOOL viewOk;
}
@property (strong,nonatomic) UITapGestureRecognizer* recognizer_pc;
@property (strong,nonatomic) UITapGestureRecognizer* recognizer_tv;
@property (strong,nonatomic) UITapGestureRecognizer* recognizer_file;
@property (strong,nonatomic) UITapGestureRecognizer* recognizer_setting;
@property (strong,nonatomic) UITapGestureRecognizer* recognizer_userlogo;
@property (strong,nonatomic) UITapGestureRecognizer* recognizer_lastPCInforLL;
@property (weak, nonatomic) IBOutlet UITextView *textview_left;
@property (weak, nonatomic) IBOutlet UITextView *textview_right;
@property (weak, nonatomic) IBOutlet UIImageView *tab01_loginWrap;
@property (weak, nonatomic) IBOutlet UITextView *id_top01_userName;
@property (weak, nonatomic) IBOutlet UIImageView *userLogo_imgButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *PCDevicesLL;
@property (weak, nonatomic) IBOutlet UIView *TVDevicesLL;
@property (weak, nonatomic) IBOutlet UIView *blueDevicesLL;
@property (weak, nonatomic) IBOutlet UIView *settingLL;
@property (weak, nonatomic) IBOutlet UILabel *lastPCInforNameTV;
@property (weak, nonatomic) IBOutlet UILabel *lastPCInforStateTV;
@property (weak, nonatomic) IBOutlet UILabel *lastTVInforNameTV;
@property (weak, nonatomic) IBOutlet UITextView *isLastUsedTVExistTV;
@property (weak, nonatomic) IBOutlet UILabel *lastTVInforStateTV;
@property (weak, nonatomic) IBOutlet UITextView *isLastUsedPCExistTV;
@property (weak, nonatomic) IBOutlet UICollectionView *tvRecentAppView;
@property (weak, nonatomic) IBOutlet UICollectionView *pcRecentAppView;
@property (weak, nonatomic) IBOutlet UIView *lastPCInforLL;
@property (weak, nonatomic) IBOutlet UIView *lastTVInforLL;
@property (strong,nonatomic) NSMutableArray<AppItem*>* pcappList;
@property (strong,nonatomic) NSMutableArray<AppItem*>* tvappList;
- (void) setUserName:(NSDictionary *)message;


@end
