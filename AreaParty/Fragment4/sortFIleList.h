//
//  sortFIleList.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/4/27.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface sortFIleList : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property(strong,nonatomic) NSMutableDictionary* intentBundle;
- (IBAction)Press_back:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *sortFileListTitle;
@property (weak, nonatomic) IBOutlet UITableView *fileListView;

@end
