//
//  MyTableView.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/5/1.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "MyTableView.h"
#import "diskContentVC.h"
@implementation MyTableView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if(((diskContentVC*)self.nextResponder.nextResponder).page04DiskContentBar01MoreRootLL.hidden == NO ||((diskContentVC*)self.nextResponder.nextResponder).page04DiskContentBar02MoreRootLL.hidden == NO)
    [self.superview touchesBegan:touches withEvent:event];
    else
        [super touchesBegan:touches withEvent:event];
}
@end
