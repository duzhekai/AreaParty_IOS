//
//  tab02_audioset_item.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/3/29.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "tab02_audioset_item.h"

@implementation tab02_audioset_item

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)press_delete:(id)sender {
    [_perform_obj performSelector:@selector(deleteItemOn:) withObject:self.index];
}
@end
