//
//  userFriendItem.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/4/20.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface tab06_useritem : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userHead;
@property (weak, nonatomic) IBOutlet UILabel *userId;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *chatNumLabel;
@property (weak, nonatomic) IBOutlet UIView *chatNum;

@end
