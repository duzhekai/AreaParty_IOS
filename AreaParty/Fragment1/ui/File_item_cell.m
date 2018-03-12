//
//  File_item_cell.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/3/1.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "File_item_cell.h"

@implementation File_item_cell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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
@end
