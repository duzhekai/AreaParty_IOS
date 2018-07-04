//
//  UTorrentViewController.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/5/22.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UTFileViewController.h"
@interface UTorrentViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
- (IBAction)Press_return:(id)sender;
- (IBAction)Press_home:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *recyclerView_torrent;

@end
