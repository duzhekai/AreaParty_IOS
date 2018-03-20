//
//  pcInforViewController.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/3/20.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "onHandler.h"
#import "AlterDeviceNameDialog.h"
@interface pcInforViewController : UIViewController<onHandler>
- (IBAction)press_return_btn:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *nameTV;
@property (weak, nonatomic) IBOutlet UILabel *systemVersionTV;
@property (weak, nonatomic) IBOutlet UILabel *systemTypeTV;
@property (weak, nonatomic) IBOutlet UILabel *memoryTV;
@property (weak, nonatomic) IBOutlet UILabel *cpuNameTV;
@property (weak, nonatomic) IBOutlet UILabel *storageTV;
@property (weak, nonatomic) IBOutlet UILabel *pcNameTV;
@property (weak, nonatomic) IBOutlet UILabel *pcDes;
@property (weak, nonatomic) IBOutlet UILabel *workGroupTV;
@property (weak, nonatomic) IBOutlet UIView *nameLL;

@end
