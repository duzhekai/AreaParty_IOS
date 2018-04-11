//
//  ContentDataLoadTask.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/3/24.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FileSystemType.h"
#import "ContentDataControl.h"
@protocol OnContentDataLoadListener
- (void)onStartLoad;
- (void)onFinishLoad;
@end
@interface ContentDataLoadTask : NSThread
@property(strong,atomic) id<OnContentDataLoadListener> mOnContentDataLoadListener;
- (instancetype)initWithType:(File_Sys_Type) type1;
@end
