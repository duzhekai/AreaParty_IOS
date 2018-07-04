//
//  UTFileViewController.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/5/23.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFile.h"
#import "UrlUtils.h"
#import "utorrent_file_item.h"
#import <AFNetworking/AFNetworking.h>
@interface UTFileViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
- (IBAction)Press_back:(id)sender;
@property (strong,nonatomic) NSString* mhash;
@property (weak, nonatomic) IBOutlet UITableView *recyclerView;

@end
