//
//  uninstallTVAppTableViewcell.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/3/20.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "uninstallTVAppTableViewcell.h"
#import "MyUIApplication.h"
#import "uninstalledTVAppEvent.h"
#import "TVAppHelper.h"
#import "Toast.h"
@implementation uninstallTVAppTableViewcell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)press_uninstall:(id)sender {
    if([MyUIApplication getselectedTVOnline]) {
        [TVAppHelper uninstallApp:[TVAppHelper getinstalledAppList][_position].packageName];
        [[TVAppHelper getinstalledAppList]removeObjectAtIndex:_position];
        [_table_view reloadData];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"uninstalledTVAPP" object:nil userInfo:[NSDictionary dictionaryWithObject:[[uninstalledTVAppEvent alloc] init] forKey:@"data"]];
        [Toast ShowToast:@"应用即将卸载, 请操作电视" Animated:YES time:1 context:_table_view];
    } else  [Toast ShowToast:@"当前电视不在线" Animated:YES time:1 context:_table_view];
}
@end
