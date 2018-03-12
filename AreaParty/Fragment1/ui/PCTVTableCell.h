//
//  PCTVTableCell.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/3/11.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PCTVTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *selected_image;
@property (weak, nonatomic) IBOutlet UILabel *nameTV;
@property (weak, nonatomic) IBOutlet UILabel *ipTV;

@end
