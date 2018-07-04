//
//  diskContentVC.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/2/28.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCFileHelper.h"
#import "AVLoadingIndicatorView.h"
#import "File_item_cell.h"
#import "OrderConst.h"
#import "Toast.h"
#import "LoginViewController.h"
#import "ActionDialog_reName.h"
#import "AddToMediaListDialog.h"
@interface diskContentVC : UIViewController<onHandler,UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *page04DiskContentTitleTV;
@property (weak, nonatomic) IBOutlet UILabel *page04DiskContentCurrentPathTV;
@property (weak, nonatomic) IBOutlet UITableView *page04DiskContentLV;
@property (weak, nonatomic) IBOutlet UIImageView *page04DiskContentErrorIV;
@property (weak, nonatomic) IBOutlet UIView *page04DiskContentActionBar01LL;
@property (weak, nonatomic) IBOutlet UIButton *bar01AddFolderLL;
- (IBAction)onclick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *bar01RefreshLL;
@property (weak, nonatomic) IBOutlet UIButton *bar01SortLL;
@property (weak, nonatomic) IBOutlet UIButton *bar01SearchLL;
@property (weak, nonatomic) IBOutlet UIButton *bar01MoreLL;
@property (weak, nonatomic) IBOutlet UIView *page04DiskContentActionBar02LL;
@property (weak, nonatomic) IBOutlet UIButton *bar02CopyLL;
@property (weak, nonatomic) IBOutlet UIButton *bar02CutLL;
@property (weak, nonatomic) IBOutlet UIImageView *bar02IconCopyIV;
@property (weak, nonatomic) IBOutlet UILabel *bar02TxCopyTV;
@property (weak, nonatomic) IBOutlet UIImageView *bar02IconCutIV;
@property (weak, nonatomic) IBOutlet UILabel *bar02TxCutTV;
@property (weak, nonatomic) IBOutlet UIButton *bar02DeleteLL;
@property (weak, nonatomic) IBOutlet UIImageView *bar02IconDeleteIV;
@property (weak, nonatomic) IBOutlet UILabel *bar02TxDeleteTV;
@property (weak, nonatomic) IBOutlet UIButton *bar02SelectAllLL;
@property (weak, nonatomic) IBOutlet UIImageView *bar02IconSelectAllIV;
@property (weak, nonatomic) IBOutlet UILabel *bar02TxSelectAllTV;
@property (weak, nonatomic) IBOutlet UIButton *bar02MoreLL;
@property (weak, nonatomic) IBOutlet UIView *page04DiskContentBar02MoreRootLL;
- (IBAction)press_back_button:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *bar02MoreRenameLL;
@property (weak, nonatomic) IBOutlet UIButton *bar02MoreShareLL;
@property (weak, nonatomic) IBOutlet UIButton *bar02MoreDetailLL;
@property (weak, nonatomic) IBOutlet UIButton *bar02MoreSaveLL;
@property (weak, nonatomic) IBOutlet UIButton *bar02MoreAddToVideoList;
@property (weak, nonatomic) IBOutlet UIView *page04DiskContentBar01MoreRootLL;
@property (weak, nonatomic) IBOutlet UIButton *bar01MoreAction1;
@property (weak, nonatomic) IBOutlet UIButton *bar01MoreAction2;
@property (weak, nonatomic) IBOutlet UIView *page04DiskContentCopyBarLL;
@property (weak, nonatomic) IBOutlet UIButton *ccopyAddFolderLL;
@property (weak, nonatomic) IBOutlet UIButton *ccopyCancelLL;
@property (weak, nonatomic) IBOutlet UIButton *ccopyPasteLL;
@property (weak, nonatomic) IBOutlet UIView *page04DiskContentCutBarLL;
@property (weak, nonatomic) IBOutlet UIView *cutAddFolderLL;
@property (weak, nonatomic) IBOutlet UIButton *cutCancelLL;
@property (weak, nonatomic) IBOutlet UIButton *cutPasteLL;

 
@property (strong,nonatomic) NSString* diskName;
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
+ (PCFileHelper*) getPCFileHelper;

@end
