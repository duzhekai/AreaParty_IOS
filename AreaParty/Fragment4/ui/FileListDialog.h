//
//  FileListDialog.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/4/28.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileData.pbobjc.h"
@interface FileListDialog : UIViewController
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (assign,nonatomic) int num;
@property (strong,nonatomic) NSMutableArray<FileItem*>* fileArray;
@end
