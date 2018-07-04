//
//  torrentFileItem.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/5/10.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface torrentFileItem : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *filename_label;
@property (weak, nonatomic) IBOutlet UIButton *checkBox;
@property (assign,nonatomic) BOOL ischecked;
- (void)setcheckbox:(BOOL) b;
@end
