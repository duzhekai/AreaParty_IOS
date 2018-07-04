//
//  tab06_addgroupitem.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/7/2.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface tab06_addgroupitem : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *groupUserHead;
@property (weak, nonatomic) IBOutlet UILabel *groupUserId;
@property (weak, nonatomic) IBOutlet UILabel *groupUserName;
@property (weak, nonatomic) IBOutlet UIButton *checkBox;
- (IBAction)Press_check:(id)sender;
@property(assign,nonatomic) BOOL ischecked;
@end
