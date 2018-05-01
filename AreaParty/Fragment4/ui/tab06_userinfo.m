//
//  tab06_userinfo.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/4/24.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "tab06_userinfo.h"

@implementation tab06_userinfo

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)Press_agreeRequestBtn:(id)sender {
    if(_holder){
        [_holder performSelector:@selector(agree_request:) withObject:_index];
    }
}
@end
