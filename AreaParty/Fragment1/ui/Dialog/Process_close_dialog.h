//
//  Process_close_dialog.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/3/10.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "onHandler.h"
#import "OrderConst.h"
#import "computerMonitorViewController.h"
#import "ProcessFormat.h"
#import "ReceivedActionMessageFormat.h"
@interface Process_close_dialog : UIView<onHandler>
@property (strong,nonatomic) ProcessFormat* process;
@property (strong,nonatomic) computerMonitorViewController* mhandler;
- (void) showDialogInView;
- (void) removeView;
@end
