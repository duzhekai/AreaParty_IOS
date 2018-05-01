//
//  tab06_fileitem.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/4/20.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "tab06_fileitem.h"

@implementation tab06_fileitem

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)press_download:(id)sender {
    [_holder performSelector:@selector(Press_DownLoad:) withObject:_i];
}
@end
