//
//  MainActivity.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/5/8.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "Toast.h"
#import "DownloadManeger_torrent.h"
@interface MainActivity : UIViewController<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *mWebView;
- (IBAction)Press_return:(id)sender;
- (IBAction)Press_refresh:(id)sender;
@property(strong,nonatomic) NSMutableDictionary* intent_bundle;
- (IBAction)Press_remote_download:(id)sender;
- (IBAction)Press_go_home:(id)sender;
@property (strong,nonatomic) UIViewController* parent;
@end
