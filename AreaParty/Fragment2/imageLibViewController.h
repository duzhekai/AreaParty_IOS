//
//  imageLibViewController.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/3/30.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "onHandler.h"
#import "tab02_folder_item.h"
#import "ContentDataLoadTask.h"
#import <SDWebImage/UIImage+WebP.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "DownloadFileManagerHelper.h"
@interface imageLibViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,onHandler,OnContentDataLoadListener>
- (IBAction)press_return:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *pcStateIV;
@property (weak, nonatomic) IBOutlet UILabel *pcStateNameTV;
@property (weak, nonatomic) IBOutlet UIImageView *tvStateIV;
@property (weak, nonatomic) IBOutlet UILabel *tvStateNameTV;
@property (weak, nonatomic) IBOutlet UITableView *folderSLV;
@property (weak, nonatomic) IBOutlet UICollectionView *fileSGV;
@property (weak, nonatomic) IBOutlet UIView *shiftBar;
@property (weak, nonatomic) IBOutlet UIView *pc_file;
@property (weak, nonatomic) IBOutlet UILabel *pc_file_TV;
@property (weak, nonatomic) IBOutlet UIView *app_file;
@property (weak, nonatomic) IBOutlet UILabel *app_file_TV;
@property (weak, nonatomic) IBOutlet UIView *picsPlayListLL;
@property (weak, nonatomic) IBOutlet UILabel *picsPlayListNumTV;
@property (weak, nonatomic) IBOutlet UIView *menuList;
@property (weak, nonatomic) IBOutlet UIView *file_view;
@property (weak, nonatomic) IBOutlet UIView *play_folder_list;
@property (weak, nonatomic) IBOutlet UIView *to_select_bgm;

@end
