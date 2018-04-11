//
//  audioLibViewController.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/3/27.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "onHandler.h"
#import "MediaItem.h"
#import "ContentDataLoadTask.h"
#import "AVLoadingIndicatorView.h"
#import "DownloadFileManagerHelper.h"
#import "listBottomDialog_app.h"
@interface audioLibViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,onHandler,OnContentDataLoadListener>
- (IBAction)press_return:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *pcStateIV;
@property (weak, nonatomic) IBOutlet UIImageView *tvStateIV;
@property (weak, nonatomic) IBOutlet UILabel *pcStateNameTV;
@property (weak, nonatomic) IBOutlet UILabel *tvStateNameTV;
@property (weak, nonatomic) IBOutlet UIView *shiftBar;
@property (weak, nonatomic) IBOutlet UIView *pc_file;
@property (weak, nonatomic) IBOutlet UIView *app_file;
@property (weak, nonatomic) IBOutlet UILabel *pc_file_TV;
@property (weak, nonatomic) IBOutlet UILabel *app_file_TV;
@property (weak, nonatomic) IBOutlet UIView *audiosPlayListLL;
@property (weak, nonatomic) IBOutlet UIView *folderSLV_container;
@property (weak, nonatomic) IBOutlet UITableView *folderSLV;
@property (weak, nonatomic) IBOutlet UILabel *audiosPlayListNumTV;
@property (weak, nonatomic) IBOutlet UITableView *fileSLV;
@property (weak, nonatomic) IBOutlet UIScrollView *Folder_scroll_view;
@property (weak, nonatomic) IBOutlet UIView *file_view;
@property (weak, nonatomic) IBOutlet UIView *music_count;
@property (weak, nonatomic) IBOutlet UILabel *numTV;
- (void) setcurrentfile:(MediaItem*) item;
@property (weak, nonatomic) IBOutlet UIView *menuList;
@property (weak, nonatomic) IBOutlet UIView *audioPlayControl;
@property (weak, nonatomic) IBOutlet UILabel *currentMusicNameTV;
@property (weak, nonatomic) IBOutlet UIImageView *playOrPauseIV;
@property (weak, nonatomic) IBOutlet UIButton *playOrPauseBtn;
- (IBAction)press_playOrPauseBtn:(id)sender;

@end
