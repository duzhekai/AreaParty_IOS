//
//  Share_File_Dialog.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/5/3.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Share_File_Dialog : UIViewController
- (IBAction)Press_Delete:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *NameLabel;
@property (weak, nonatomic) IBOutlet UILabel *SizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *DesLabel;
@property (strong,nonatomic) NSMutableDictionary<NSString*,NSObject*>* h;
@property (strong,nonatomic) id delegate;
@end
