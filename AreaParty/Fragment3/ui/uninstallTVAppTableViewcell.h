//
//  uninstallTVAppTableViewcell.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/3/20.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface uninstallTVAppTableViewcell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailIV;
@property (weak, nonatomic) IBOutlet UILabel *nameTV;
@property (assign,nonatomic) int position;
@property (strong,nonatomic) UITableView* table_view;
- (IBAction)press_uninstall:(id)sender;

@end
