//
//  ActionDialog_playPicList.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/4/15.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActionDialog_playPicList : UIViewController
@property(strong,nonatomic) UIViewController* holder;
- (IBAction)press_5:(id)sender;
- (IBAction)press_6:(id)sender;
- (IBAction)press_7:(id)sender;
- (IBAction)press_8:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btn5;
@property (weak, nonatomic) IBOutlet UIButton *btn6;
@property (weak, nonatomic) IBOutlet UIButton *btn7;
@property (weak, nonatomic) IBOutlet UIButton *btn8;
- (IBAction)press_cancel:(id)sender;
- (IBAction)press_ok:(id)sender;
+ (int)getT;
@end
