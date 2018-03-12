//
//  RegisterOperatorVC.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/3/12.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Toast.h"
#import "AVLoadingIndicatorView.h"
@interface RegisterOperatorVC : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *register_key_et;
@property (weak, nonatomic) IBOutlet UITextField *register_value_et;
@property (strong,nonatomic) AVLoadingIndicatorView* loadingview;
@property (strong,nonatomic) UIViewController* pushview;
- (IBAction)press_cancel:(id)sender;
- (IBAction)press_ok:(id)sender;

@end
