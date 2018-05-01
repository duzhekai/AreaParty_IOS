//
//  ActionDialog_reName.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/5/1.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <UIKit/UIKit.h>
@class diskContentVC;
@interface ActionDialog_reName : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *oldname;
@property (weak, nonatomic) NSString* oldfileName;
@property (weak, nonatomic) IBOutlet UITextField *valueEditText;
@property (strong,nonatomic) diskContentVC* holder;
@property (assign,nonatomic) int filetype;
- (IBAction)Press_cancel:(id)sender;
- (IBAction)Press_sure:(id)sender;

@end
