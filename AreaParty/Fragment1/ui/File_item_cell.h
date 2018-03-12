//
//  File_item_cell.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/3/1.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "diskContentVC.h"
@interface File_item_cell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *typeView;
@property (weak, nonatomic) IBOutlet UILabel *nameView;
@property (weak, nonatomic) IBOutlet UILabel *inforView;
@property (weak, nonatomic) IBOutlet UIButton *checkBox;
@property (assign,nonatomic) BOOL ischecked;
- (void)setcheckbox:(BOOL) b;

@end
