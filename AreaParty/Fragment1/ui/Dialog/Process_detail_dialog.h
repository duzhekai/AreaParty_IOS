//
//  Process_detail_dialog.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/3/10.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Process_detail_dialog : UIView
@property(strong,nonatomic) UIView* bg_view;
@property(strong,nonatomic) UIView* contentView;
- (void) showDialogInView:(UIView*) outview Title:(NSString*) title Path:(NSString*) path CPU:(NSString*) cpu Memory:(NSString*) memory;
- (void) removeView;
@end
