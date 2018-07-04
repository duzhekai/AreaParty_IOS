//
//  utorrent_torrent_item.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/5/22.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "utorrent_torrent_item.h"

@implementation utorrent_torrent_item

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)Press_stop:(id)sender {
    [_delegate performSelector:@selector(stop:) withObject:_index];
}

- (IBAction)Press_remove:(id)sender {
    [_delegate performSelector:@selector(remove:) withObject:_index];
}

- (IBAction)Press_startOrPause:(id)sender {
    if([_startOrPause.titleLabel.text isEqualToString:@"暂停"])
        [_delegate performSelector:@selector(pause:) withObject:_index];
    else
        [_delegate performSelector:@selector(start:) withObject:_index];
}
@end
