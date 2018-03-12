//
//  exe_item_cell.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/3/12.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface exe_item_cell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *exe_name;
@property (weak, nonatomic) IBOutlet UILabel *publisherInformation;
@property (weak, nonatomic) IBOutlet UILabel *versionInformation;

@end
