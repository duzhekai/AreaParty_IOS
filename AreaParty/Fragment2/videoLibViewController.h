//
//  videoLibViewController.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/3/22.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "onHandler.h"
#import "ContentDataLoadTask.h"
#import "AVLoadingIndicatorView.h"
#import "FileItemForMedia.h"
#import "DownloadFileManagerHelper.h"
@class MediaItem;
@interface videoLibViewController : UIViewController<onHandler,UITableViewDelegate,UITableViewDataSource,OnContentDataLoadListener>
@property (weak, nonatomic) IBOutlet UIView *shiftBar;
@property (weak, nonatomic) IBOutlet UIView *pc_file;
@property (weak, nonatomic) IBOutlet UIView *app_file;
@property (weak, nonatomic) IBOutlet UITableView *folderSLV;
@property (weak, nonatomic) IBOutlet UIView *folderSLV_container;
@property (weak, nonatomic) IBOutlet UIScrollView *Scroll_View;
@property (weak, nonatomic) IBOutlet UITableView *fileSLV;
- (IBAction)press_return:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *pc_file_TV;
@property (weak, nonatomic) IBOutlet UILabel *app_file_TV;
@property (weak, nonatomic) IBOutlet UIImageView *pcStateIV;
@property (weak, nonatomic) IBOutlet UIImageView *tvStateIV;
@property (weak, nonatomic) IBOutlet UILabel *pcStateNameTV;
@property (weak, nonatomic) IBOutlet UILabel *tvStateNameTV;
- (void) setcurrentfile:(MediaItem*) item;

@end
