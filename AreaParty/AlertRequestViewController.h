//
//  AlertRequestViewController.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/4/26.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlertRequestViewController : UIViewController
- (IBAction)Press_accreditDialogOnly:(id)sender;
- (IBAction)Press_accreditDialogAlways:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *accreditRequestDialogInfo;

@property(strong,nonatomic)  NSMutableDictionary* intentBundle;
@end
