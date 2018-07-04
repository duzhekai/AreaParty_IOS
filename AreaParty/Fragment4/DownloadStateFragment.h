//
//  DownloadStateFragment.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/4/30.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "onHandler.h"
#import "ProgressObj.h"
#import <YYModel/YYModel.h>
#import "tab06_download_manager_stateitem.h"
#import "ReceiveDownloadProcessFormat.h"
@interface DownloadStateFragment : UIViewController<onHandler,UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *downloadFileStateFragmentList;
@property (weak, nonatomic) IBOutlet UIView *downloadStateFragmentRefresh;
- (IBAction)Press_refresh:(id)sender;
- (void) agreeDownload:(NSDictionary*) msg;
@end
