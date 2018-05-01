//
//  UserInfoListDialog.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/4/28.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInfoListDialog : UIViewController
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (strong,nonatomic) NSString* label1_text;
@property (strong,nonatomic) NSString* label2_text;
@property (strong,nonatomic) NSString* label3_text;
@property (strong,nonatomic) UIViewController* holder;
- (IBAction)Press_more:(id)sender;

@end
