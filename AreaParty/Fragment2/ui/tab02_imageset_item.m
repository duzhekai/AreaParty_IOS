//
//  tab02_imageset_item.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/3/31.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "tab02_imageset_item.h"

@implementation tab02_imageset_item

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)press_delete_btn:(id)sender {
    [_perform_obj performSelector:@selector(deleteItemOn:) withObject:self.index];
}
@end
