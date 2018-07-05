//
//  PCNASFileSysViewController.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/7/5.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileSysDiskListCell.h"
@interface PCNASFileSysViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
- (IBAction)Press_return:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *page04DiskListLV;
@property (weak, nonatomic) IBOutlet UIView *page04DiskListActionBarLL;
@property (weak, nonatomic) IBOutlet UIButton *page04DiskListRefreshLL;
- (IBAction)onClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *page04DiskListMoreLL;
@property (weak, nonatomic) IBOutlet UIView *page04CopyBarLL;
@property (weak, nonatomic) IBOutlet UIButton *page04CopyCancelLL;
@property (weak, nonatomic) IBOutlet UIView *page04CutBarLL;
@property (weak, nonatomic) IBOutlet UIButton *page04CutCancelLL;

@end
