//
//  downloadVC.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/2/28.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface downloadVC : UIViewController<UIScrollViewDelegate>
- (IBAction)Press_Back:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *Tab1;
@property (weak, nonatomic) IBOutlet UILabel *Tab2;
@property (weak, nonatomic) IBOutlet UIScrollView *page04DownloadVP;
@property (weak, nonatomic) IBOutlet UIView *Indicator;

@end
