//
//  HistoryMsg.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/4/28.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKJChatTableViewCell_History.h"
@interface HistoryMsg : UIViewController<UITableViewDelegate,UITableViewDataSource>
- (IBAction)Press_back:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *historyMsgTitle;
- (IBAction)Press_selectDate:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *historyMsgList;
@property (weak, nonatomic) IBOutlet UILabel *historyMsg_tip;
@property (strong,nonatomic) NSMutableDictionary<NSString*,NSObject*>* intentBundle;

@end
