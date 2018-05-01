//
//  tab06_downloadrequestitem.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/4/25.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "tab06_downloadrequestitem.h"

@implementation tab06_downloadrequestitem

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)Press_agreeFileRequestBtn:(id)sender {
    if(_holder){
        [_holder performSelector:@selector(agree_request:) withObject:_index];
    }
}

- (IBAction)Press_disagreeFileRequestBtn:(id)sender {
    if(_holder){
        [_holder performSelector:@selector(disagree_request:) withObject:_index];
    }
}
@end
