//
//  RegisterUserInfo.h
//  AreaParty
//
//  Created by 杜哲凯 on 2017/12/5.
//  Copyright © 2017年 杜哲凯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Toast.h"
#import "RegisterMsg.pbobjc.h"
#import "Base.h"
#import "NetworkPacket.h"
#import "ProtoHead.pbobjc.h"
#import "DataTypeTranslater.h"
#import "RegisterPersonalInfo.h"
@interface RegisterUserInfo : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *et_keyword;
@property (weak, nonatomic) IBOutlet UITextField *et_userName;
@property (weak, nonatomic) IBOutlet UITextField *et_keywordAgain;
@property (weak, nonatomic) IBOutlet UIButton *Next_Btn;
@property (weak, nonatomic) IBOutlet UITextField *et_userId;
@property (assign,nonatomic) BOOL checked;
@property (weak, nonatomic) IBOutlet UIButton *Checkbox_btn;
- (IBAction)Press_checkbox:(id)sender;
- (IBAction)Press_Next_btn:(id)sender;

@end
