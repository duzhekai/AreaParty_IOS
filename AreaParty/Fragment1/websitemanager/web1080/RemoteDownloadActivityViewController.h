//
//  RemoteDownloadActivityViewController.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/1/5.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TorrentFile.h"
#import "onHandler.h"
#import "UrlUtils.h"
#import "Send2PCThread.h"
#import "GTMBase64.h"
extern NSString* RemoteDownload_rootPath;
extern NSString* RemoteDownload_btFilesPath;
extern NSString* RemoteDownload_targetPath;
extern NSString* RemoteDownload_downloadPath;
@interface RemoteDownloadActivityViewController : UIViewController<onHandler,UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *app_file;
@property (weak, nonatomic) IBOutlet UIView *pc_file;
@property (weak, nonatomic) IBOutlet UIView *Middle_View;
- (IBAction)Press_back:(id)sender;
- (IBAction)Press_goHome:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *recycler_view_torrent_file;
@property (weak, nonatomic) IBOutlet UITableView *recycler_view_torrent_pcFile;
@property (weak, nonatomic) IBOutlet UILabel *app_file_text;
@property (weak, nonatomic) IBOutlet UILabel *pc_file_text;
@property (weak, nonatomic) IBOutlet UIView *download_remote_control;
@property (weak, nonatomic) IBOutlet UIView *menu_list;
@property (weak, nonatomic) IBOutlet UIView *addToDownload;
@property (weak, nonatomic) IBOutlet UIView *sendToPc;
@property (weak, nonatomic) IBOutlet UIView *torrentDelete;
@property (weak, nonatomic) IBOutlet UIView *menu_list_pc;
@property (weak, nonatomic) IBOutlet UIView *addToDownload_pc;
@property (weak, nonatomic) IBOutlet UIView *torrentDelete_pc;
@end


@interface FileClient:NSObject
@property(strong,nonatomic) NSString* fileStr;
@property(strong,nonatomic) UIViewController* delegate;
- (instancetype)initWithFileStr:(NSString*) str Delegate:(UIViewController*) ctl;
@end
