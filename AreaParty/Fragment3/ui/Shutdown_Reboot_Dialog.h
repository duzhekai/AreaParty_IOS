//
//  Shutdown_Reboot_Dialog.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/3/20.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Shutdown_Reboot_Dialog : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *title_label;
@property (weak, nonatomic) IBOutlet UIButton *left_button;
@property (weak, nonatomic) IBOutlet UIButton *right_button;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (strong,nonatomic) NSString* command;
@end
