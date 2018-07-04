//
//  utorrent_file_item.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/5/23.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface utorrent_file_item : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameTV;
@property (weak, nonatomic) IBOutlet UILabel *sizeTV;
@property (weak, nonatomic) IBOutlet UILabel *downloadedTV;
@property (weak, nonatomic) IBOutlet UILabel *progressTV;
@property (weak, nonatomic) IBOutlet UIButton *checkBoxBtn;
@property (assign,nonatomic) BOOL ischecked;
@property (strong,nonatomic) NSIndexPath* index;
@property (strong,nonatomic) id delegate;
- (IBAction)Press_checkBox:(id)sender;
- (void) setCheckBox:(BOOL)b;
@end
