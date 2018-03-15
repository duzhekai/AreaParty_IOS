//
//  tvInforViewController.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/3/15.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "onHandler.h"
@interface tvInforViewController : UIViewController<onHandler>
@property (weak, nonatomic) IBOutlet UILabel *nameTV;
@property (weak, nonatomic) IBOutlet UILabel *brandTV;
@property (weak, nonatomic) IBOutlet UILabel *modelTV;
@property (weak, nonatomic) IBOutlet UILabel *androidVersionTV;
@property (weak, nonatomic) IBOutlet UILabel *totalMemoryTV;
@property (weak, nonatomic) IBOutlet UILabel *storageTV;
@property (weak, nonatomic) IBOutlet UILabel *resolutionTV;
@property (weak, nonatomic) IBOutlet UILabel *isRootTV;
@property (weak, nonatomic) IBOutlet UIView *nameTV_container;
- (IBAction)press_return:(id)sender;

@end
