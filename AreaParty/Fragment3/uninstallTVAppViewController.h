//
//  uninstallTVAppViewController.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/3/20.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface uninstallTVAppViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
- (IBAction)press_return:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *appListTableView;

@end
