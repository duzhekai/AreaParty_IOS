//
//  AVLoadingIndicatorView.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/1/24.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingViewForOC.h"
@interface AVLoadingIndicatorView : UIView
@property(assign,nonatomic) BOOL isshown;
@property(retain,nonatomic) UIView* backgroundview;
@property(retain,nonatomic) UILabel* loading_txt;
-(void)showPromptViewOnView:(UIView *)view;
-(void) removeView;
@end
