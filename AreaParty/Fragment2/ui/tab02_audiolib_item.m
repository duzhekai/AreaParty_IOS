//
//  tab02_audiolib_item.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/3/27.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "tab02_audiolib_item.h"
#import "tab02_listdialog.h"
#import "OrderConst.h"
@implementation tab02_audiolib_item

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)press_addToList:(id)sender {
    [_handler performSelector:@selector(press_add_list:) withObject:_index];
}
@end
