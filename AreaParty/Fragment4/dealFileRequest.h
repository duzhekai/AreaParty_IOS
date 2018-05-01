//
//  dealFileRequest.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/4/24.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileRequestDBManager.h"
#import "MainTabbarController.h"
#import "onHandler.h"
#import "tab06_downloadrequestitem.h"
@class  dealFileRequestHandler;
@interface dealFileRequest : UIViewController<UITableViewDelegate,UITableViewDataSource>
- (IBAction)Press_return:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *downloadRequestList;
+ (dealFileRequestHandler*)getmHandler;
@end



@interface dealFileRequestHandler :NSObject<onHandler>
@property(strong,nonatomic) dealFileRequest* holder;
- (instancetype)initWithController:(dealFileRequest*) ctl;
@end
