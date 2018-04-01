//
//  MFileItem.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/3/25.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileItemForMedia : NSObject
@property(strong,nonatomic) NSString* mFileId;
@property(strong,nonatomic) NSString* mFilePath;
@property(strong,nonatomic) NSString* mFileName;
- (instancetype)initWithmFileId:(NSString*)mFileId1 mFilePath:(NSString*)mFilePath1 mFileName:(NSString*)mFileName1;
@end
