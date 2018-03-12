//
//  exeContentVC.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/3/12.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExeInformat.h"
#import "ReceivedExeListFormat.h"
#import "prepareDataForFragment_monitor.h"
#import "OrderConst.h"
#import "onHandler.h"
#import "Toast.h"
#import "exe_item_cell.h"
@interface exeContentVC : UIViewController<onHandler,UITableViewDelegate,UITableViewDataSource>
- (IBAction)press_return:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *exe_table_view;

@end
