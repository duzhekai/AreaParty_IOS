//
//  torrentFileItem.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/5/10.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "torrentFileItem.h"

@implementation torrentFileItem

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setcheckbox:(BOOL) b{
    if(b){
        [_checkBox setImage:[UIImage imageNamed:@"checkedbox.png"] forState:UIControlStateNormal];
        _ischecked = YES;
    }
    else{
        [_checkBox setImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
        _ischecked = NO;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
