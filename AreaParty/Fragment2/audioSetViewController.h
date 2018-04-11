//
//  audioSetViewController.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/3/29.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MediaSetBean.h"
#import "MyUIApplication.h"
#import "Toast.h"
#import "MediafileHelper.h"
#import "onHandler.h"
#import "tab02_audioset_item.h"
#import "audioSetContentViewController.h"
#import "LocalSetListContainer.h"
@interface audioSetViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,onHandler>
- (IBAction)press_return:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *shiftBar;
@property (weak, nonatomic) IBOutlet UIView *pc_file;
@property (weak, nonatomic) IBOutlet UILabel *pc_file_TV;
@property (weak, nonatomic) IBOutlet UIView *app_file;
@property (weak, nonatomic) IBOutlet UILabel *app_file_TV;
@property (weak, nonatomic) IBOutlet UITableView *fileSGV;
- (IBAction)press_add_set:(id)sender;
@property (assign,nonatomic) BOOL isAppContent;
@property (strong,nonatomic) UIAlertController* addSetDialog;
@end
