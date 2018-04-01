//
//  tab02_imagelib_item.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/3/30.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "tab02_imagelib_item.h"

@implementation tab02_imagelib_item

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)press_cast:(id)sender {
    [_handler performSelector:@selector(cast_pressed:) withObject:_index];
}
- (IBAction)press_add_logo:(id)sender {
    [_handler performSelector:@selector(add_pressed:) withObject:_index];
}
@end
