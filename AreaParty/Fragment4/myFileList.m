//
//  myFileList.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/4/19.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "myFileList.h"
@implementation myFileList
- (instancetype)initWithList:(NSMutableArray<FileItem*>*)list1{
    if(self = [super init]){
        _list = list1;
    }
    return self;
}
@end
