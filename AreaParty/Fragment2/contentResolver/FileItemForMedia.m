//
//  MFileItem.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/3/25.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "FileItemForMedia.h"

@implementation FileItemForMedia
- (instancetype)initWithmFileId:(NSString*)mFileId1 mFilePath:(NSString*)mFilePath1 mFileName:(NSString*)mFileName1 AssertUrl:(NSURL*)asserurl{
    self = [super init];
    if(self){
        _mFileId = mFileId1;
        _mFilePath = mFilePath1;
        _mFileName = mFileName1;
        _mAssertUrl = asserurl;
    }
    return self;
}
@end
