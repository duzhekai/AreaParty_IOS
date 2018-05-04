//
//  MysharedFileItem.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/5/4.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MysharedFileItem : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *FileImgIV;
@property (weak, nonatomic) IBOutlet UILabel *NameTV;
@property (weak, nonatomic) IBOutlet UILabel *DesTV;
@property (weak, nonatomic) IBOutlet UILabel *SizeTV;
@property (weak, nonatomic) IBOutlet UILabel *DateTV;

@end
