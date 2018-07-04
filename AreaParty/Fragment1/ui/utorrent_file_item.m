//
//  utorrent_file_item.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/5/23.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "utorrent_file_item.h"

@implementation utorrent_file_item

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void) setCheckBox:(BOOL)b{
    if(b){
        [_checkBoxBtn setImage:[UIImage imageNamed:@"checkedbox.png"] forState:UIControlStateNormal];
        _ischecked = YES;
    }
    else{
        [_checkBoxBtn setImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
        _ischecked = NO;
    }
}

- (IBAction)Press_checkBox:(id)sender {
    if(_ischecked)
       [_delegate performSelector:@selector(checked:) withObject:_index];
    else
        [_delegate performSelector:@selector(unchecked:) withObject:_index];
}
@end
