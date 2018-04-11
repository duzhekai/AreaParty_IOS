//
//  tab02_vediolib_item.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/3/26.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "tab02_vediolib_item.h"
#import "MyUIApplication.h"
#import "Toast.h"
#import "MediafileHelper.h"
#import "videoLibViewController.h"
@implementation tab02_vediolib_item

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)press_play:(id)sender {
    [_handler performSelector:@selector(press_castIB:) withObject:_index];
}
@end
