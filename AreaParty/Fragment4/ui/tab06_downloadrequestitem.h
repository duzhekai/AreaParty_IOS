//
//  tab06_downloadrequestitem.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/4/25.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface tab06_downloadrequestitem : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *requestFileImg;
@property (weak, nonatomic) IBOutlet UILabel *requestUserId;
@property (weak, nonatomic) IBOutlet UILabel *requestFileName;
- (IBAction)Press_agreeFileRequestBtn:(id)sender;
- (IBAction)Press_disagreeFileRequestBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *agreeFileRequestBtn;
@property (strong,nonatomic) id holder;
@property (weak, nonatomic) IBOutlet UIButton *disagreeFileRequestBtn;
@property (strong,nonatomic) NSIndexPath* index;
@end
