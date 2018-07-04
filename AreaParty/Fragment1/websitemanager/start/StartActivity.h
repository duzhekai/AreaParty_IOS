//
//  StartActivity.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/5/8.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainActivity.h"
@interface StartActivity : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *image1;
@property (weak, nonatomic) IBOutlet UIButton *url1;
@property (weak, nonatomic) IBOutlet UIImageView *image2;
@property (weak, nonatomic) IBOutlet UIButton *url2;
@property (weak, nonatomic) IBOutlet UIImageView *image3;
@property (weak, nonatomic) IBOutlet UIView *downloadManagementLL;
@property (strong,nonatomic) UITapGestureRecognizer* download_tap;
@property (weak, nonatomic) IBOutlet UIButton *url3;
@property (weak, nonatomic) IBOutlet UIImageView *image4;
@property (weak, nonatomic) IBOutlet UIButton *url4;
@property (weak, nonatomic) IBOutlet UIImageView *image5;
@property (weak, nonatomic) IBOutlet UIButton *url5;
- (IBAction)Press_helpInfo:(id)sender;
- (IBAction)Press_back:(id)sender;

@end
