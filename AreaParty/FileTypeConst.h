//
//  FileTypeConst.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/1/25.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <Foundation/Foundation.h>
extern const int FileTypeConst_folder;
extern const int FileTypeConst_excel;
extern const int FileTypeConst_music;
extern const int FileTypeConst_pdf;
extern const int FileTypeConst_ppt;
extern const int FileTypeConst_video;
extern const int FileTypeConst_word;
extern const int FileTypeConst_zip;
extern const int FileTypeConst_txt;
extern const int FileTypeConst_pic;
extern const int FileTypeConst_apk;
extern const int FileTypeConst_none;

@interface FileTypeConst : NSObject
+(NSArray<NSString*>*) musicTypeList;
+(NSArray<NSString*>*) videoTypeList;
+(NSArray<NSString*>*) excelTypeList;
+(NSArray<NSString*>*) pptTypeList;
+(NSArray<NSString*>*) wordTypeList;
+(NSArray<NSString*>*) zipTypeList;
+(NSArray<NSString*>*) picTypeList;
+ (int) determineFileType:(NSString*) fileName;
@end
