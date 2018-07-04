//
//  DownloadFolderFragment.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/4/30.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AVLoadingIndicatorView.h"
#import "fileBean.h"
#import "PCFileHelper.h"
#import "Toast.h"
#import "onHandler.h"
#import "File_item_cell.h"
#import "MyUIApplication.h"
extern NSString* DownloadFolderFragment_rootPath;
@interface DownloadFolderFragment : UIViewController<UITableViewDelegate,UITableViewDataSource,onHandler>
@property (weak, nonatomic) IBOutlet UIView *page04DiskContentActionBar01LL;
@property (weak, nonatomic) IBOutlet UITableView *page04DiskContentLV;
@property (weak, nonatomic) IBOutlet UIButton *bar01RefreshBtn;
- (IBAction)onClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *page04DiskContentActionBar02LL;
@property (weak, nonatomic) IBOutlet UIButton *bar02CutBtn;
@property (weak, nonatomic) IBOutlet UIButton *bar02DeleteBtn;
@property (weak, nonatomic) IBOutlet UIImageView *bar02IconCopyIV;
@property (weak, nonatomic) IBOutlet UIButton *bar02CopyBtn;
@property (weak, nonatomic) IBOutlet UILabel *bar02TxCutTV;
@property (weak, nonatomic) IBOutlet UIImageView *bar02IconCutIV;
@property (weak, nonatomic) IBOutlet UILabel *bar02TxDeleteTV;
@property (weak, nonatomic) IBOutlet UILabel *bar02TxSelectAllTV;
@property (weak, nonatomic) IBOutlet UIImageView *bar02IconDeleteIV;
@property (weak, nonatomic) IBOutlet UIImageView *bar02IconSelectAllIV;
@property (weak, nonatomic) IBOutlet UIButton *bar02SelectAllBtn;
@property (weak, nonatomic) IBOutlet UILabel *bar02TxCopyTV;
@property (weak, nonatomic) IBOutlet UIButton *bar02MoreBtn;
@property (weak, nonatomic) IBOutlet UIView *page04DiskContentCopyBarLL;
@property (weak, nonatomic) IBOutlet UIButton *ccopyAddFolderBtn;
@property (weak, nonatomic) IBOutlet UIButton *ccopyCancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *ccopyPasteBtn;
@property (weak, nonatomic) IBOutlet UIView *page04DiskContentCutBarLL;
@property (weak, nonatomic) IBOutlet UIButton *cutAddFolderBtn;
@property (weak, nonatomic) IBOutlet UIButton *cutCancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *cutPasteBtn;
@property (weak, nonatomic) IBOutlet UIView *page04DiskContentBar02MoreRootLL;
@property (weak, nonatomic) IBOutlet UIButton *bar02MoreRenameBtn;
@property (weak, nonatomic) IBOutlet UIButton *bar02MoreShareBtn;
@property (weak, nonatomic) IBOutlet UIButton *bar02MoreSaveBtn;
@property (weak, nonatomic) IBOutlet UIButton *bar02MoreAddToVideoList;

@property (assign,nonatomic) int lastPoint;
@property (assign,nonatomic) BOOL isBack;
@property (assign,nonatomic) BOOL isCheckBoxIn;
@property (strong,nonatomic) AVLoadingIndicatorView* LoadingDialog;// 上方加载动画的控件
@property (weak,nonatomic) NSMutableArray<fileBean*>* datalist;
@property (strong,nonatomic) UIAlertController* add_folder_dialog;
@property (weak,nonatomic) UITextField* add_folder_name_tf;
@property (strong,nonatomic) UIAlertController* delete_folder_dialog;
@property (strong,nonatomic) UIAlertController* share_file_dialog;
@property (weak,nonatomic) UITextField* sshareFileDesET;
@property (weak,nonatomic) UITextField* sshareFileUrlET;
@property (weak,nonatomic) UITextField* sshareFilePwdET;

- (void) agreeDownload:(NSMutableDictionary*) msg;
+ (PCFileHelper*) getPCFileHelper;
- (void) onkeyup:(UIViewController*) vc;
@end
