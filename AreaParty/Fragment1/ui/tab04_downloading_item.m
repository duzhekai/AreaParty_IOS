//
//  tab04_downloading_item.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/5/2.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "tab04_downloading_item.h"

@implementation tab04_downloading_item

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)Press_button:(id)sender {
    [self.delegate performSelector:@selector(Press_stateBtn:) withObject:_index];
}

- (IBAction)Press_Delete:(id)sender {
    [self.delegate performSelector:@selector(Press_DeleteBtn:) withObject:_index];
}
- (void)setFrame:(CGRect)frame
{
    frame.size.width = [UIScreen mainScreen].bounds.size.width;
    [super setFrame:frame];
    
}
@end
