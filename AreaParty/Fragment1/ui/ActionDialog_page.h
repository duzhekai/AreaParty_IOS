//
//  ActionDialog_page.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/4/11.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActionDialog_page : UIViewController<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *dialog_container;
- (IBAction)press_off:(id)sender;
@property (weak, nonatomic) IBOutlet UIWebView *web_content_view;
@property(strong,nonatomic) NSString* type;
@end
