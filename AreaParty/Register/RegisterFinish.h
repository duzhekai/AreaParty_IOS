//
//  RegisterFinish.h
//  AreaParty
//
//  Created by 杜哲凯 on 2017/12/11.
//  Copyright © 2017年 杜哲凯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
@interface RegisterFinish : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *finish_label;
@property (strong,nonatomic) NSString* userId;
@property (strong,nonatomic) NSString* psw;
@end
