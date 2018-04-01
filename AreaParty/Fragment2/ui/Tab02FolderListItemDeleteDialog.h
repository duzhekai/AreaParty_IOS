//
//  Tab02FolderListItemDeleteDialog.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/3/28.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "onHandler.h"
@interface Tab02FolderListItemDeleteDialog : UIViewController
@property (strong,nonatomic) NSString* type;
- (IBAction)press_cancel:(id)sender;
- (IBAction)press_delete:(id)sender;
@property (strong,nonatomic) NSString* filepath;
@property (strong,nonatomic) id<onHandler> handler;
@end
