//
//  AlertAccreditActivity.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/5/4.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlertAccreditActivity : UIViewController
@property (strong,nonatomic) NSMutableDictionary* intentBundle;
@property (weak, nonatomic) IBOutlet UILabel *accreditRequestDialogInfo;
- (IBAction)Press_accreditDialogOnly:(id)sender;
- (IBAction)Press_accreditDialogAlways:(id)sender;
- (IBAction)Press_accreditDialogRefuse:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *accreditDialogOnly;

@end
