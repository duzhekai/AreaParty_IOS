//
//  tab04_downloaded_item.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/5/3.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "tab04_downloaded_item.h"

@implementation tab04_downloaded_item

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)Press_cast:(id)sender {
    [_delegate performSelector:@selector(CellPress_cast:) withObject:_index];
}

- (IBAction)Press_delete:(id)sender {
    [_delegate performSelector:@selector(CellPress_Delete:) withObject:_index];
}
@end
