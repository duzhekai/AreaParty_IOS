//
//  myFileList.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/4/19.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FileData.pbobjc.h"
@interface myFileList : NSObject
@property(strong,nonatomic) NSMutableArray<FileItem*>* list;
- (instancetype)initWithList:(NSMutableArray<FileItem*>*)list1;
@end
