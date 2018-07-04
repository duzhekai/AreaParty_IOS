//
//  tab06_addgroupitem.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/7/2.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "tab06_addgroupitem.h"

@implementation tab06_addgroupitem

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)Press_check:(id)sender {
    if(!_ischecked){
        [_checkBox setImage:[UIImage imageNamed:@"checkedbox.png"] forState:UIControlStateNormal];
        _ischecked = YES;
    }
    else{
        [_checkBox setImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
        _ischecked = NO;
    }
}
@end
