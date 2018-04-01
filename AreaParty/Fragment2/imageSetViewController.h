//
//  imageSetViewController.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/3/31.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "onHandler.h"
#import "tab02_imageset_item.h"
#import <SDWebImage/UIImage+WebP.h>
#import <SDWebImage/UIImageView+WebCache.h>
@interface imageSetViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,onHandler>
- (IBAction)press_return_btn:(id)sender;
- (IBAction)press_add_set:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *shiftBar;
@property (weak, nonatomic) IBOutlet UIView *pc_file;
@property (weak, nonatomic) IBOutlet UILabel *pc_file_TV;
@property (weak, nonatomic) IBOutlet UIView *app_file;
@property (weak, nonatomic) IBOutlet UILabel *app_file_TV;
@property (weak, nonatomic) IBOutlet UITableView *fileSGV;
@property (assign,nonatomic) BOOL isAppContent;
@property (strong,nonatomic) UIAlertController* addSetDialog;
@end
