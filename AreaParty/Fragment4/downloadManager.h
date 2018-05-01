//
//  downloadManager.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/4/30.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface downloadManager : UIViewController<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *page_viewer_scrollView;
- (IBAction)Press_return:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *DownloadTitle;
@property (weak, nonatomic) IBOutlet UILabel *stateTitle;
@property (weak, nonatomic) IBOutlet UIView *Indicator;

@end
