//
//  tab06_userinfo.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/4/24.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface tab06_userinfo : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *addFriendHead;
@property (weak, nonatomic) IBOutlet UILabel *requestUserName;
@property (weak, nonatomic) IBOutlet UILabel *requestUserFileNum;
@property (strong,nonatomic) NSObject* holder;
@property (strong,nonatomic) NSIndexPath* index;
- (IBAction)Press_agreeRequestBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *agree_btn;

@end
