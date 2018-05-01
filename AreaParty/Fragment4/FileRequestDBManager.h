//
//  FileRequestDBManager.h
//  AreaParty
//
//  Created by 杜哲凯 on 2017/12/26.
//  Copyright © 2017年 杜哲凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "fileObj.h"
#import <FMDB/FMDB.h>
#import "DBConst.h"
@interface FileRequestDBManager : NSObject
- (void) addFileRequestSQL:(fileObj*) request AndTable:(NSString*) table;
- (NSMutableArray<fileObj*>*) selectFileRequestSQL:(NSString*) table;
- (void) deleteFileRequestSQL:(NSString*) peerId Date:(NSString*)fileDate Table:(NSString*)table;
@end
