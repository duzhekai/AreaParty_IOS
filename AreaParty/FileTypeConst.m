//
//  FileTypeConst.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/1/25.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "FileTypeConst.h"
const int FileTypeConst_folder = 1;
const int FileTypeConst_excel = 2;
const int FileTypeConst_music =3;
const int FileTypeConst_pdf =4;
const int FileTypeConst_ppt =5;
const int FileTypeConst_video =6;
const int FileTypeConst_word=7;
const int FileTypeConst_zip=8;
const int FileTypeConst_txt=9;
const int FileTypeConst_pic=10;
const int FileTypeConst_apk=11;
const int FileTypeConst_none=12;
@implementation FileTypeConst


+(NSArray<NSString*>*) musicTypeList{
    return [NSArray arrayWithObjects:@"m4a", @"mp3", @"mid", @"xmf", @"ogg", @"wav", @"flac", @"ape", nil];
}
+(NSArray<NSString*>*) videoTypeList{
    return [NSArray arrayWithObjects:@"3gp", @"mp4", @"mkv", @"avi", @"flv", @"wmv", @"rmvb", @"mov", nil];
}
+(NSArray<NSString*>*) excelTypeList{
    return [NSArray arrayWithObjects:@"xls", @"xlsx", @"xlsb", @"xlsm", @"xlst", nil];
}
+(NSArray<NSString*>*) pptTypeList{
    return [NSArray arrayWithObjects:@"pptx", @"pptm", @"ppt", nil];
}
+(NSArray<NSString*>*) wordTypeList{
    return [NSArray arrayWithObjects:@"docx", @"docm", @"doc", @"dotx", @"dot", @"dotm", nil];
}
+(NSArray<NSString*>*) zipTypeList{
    return [NSArray arrayWithObjects:@"rar", @"zip", @"arj", nil];
}
+(NSArray<NSString*>*) picTypeList{
    return [NSArray arrayWithObjects:@"bmp", @"jpg", @"jpeg", @"png", @"gif", nil];
}
+ (int) determineFileType:(NSString*) fileName{
    int type = 0;
    int indexofdot = 0;
    // 获取文件扩展名
    for(int i =0 ; i< fileName.length ;i++){
        if([fileName characterAtIndex:i] == '.')
            indexofdot = i;
    }
    NSString* end = [fileName substringWithRange:NSMakeRange(indexofdot+1, fileName.length - indexofdot-1)];
    if([[self musicTypeList] containsObject:end]) {
        type = FileTypeConst_music;
    } else if([[self videoTypeList] containsObject:end]) {
        type = FileTypeConst_video;
    } else if([[self excelTypeList] containsObject:end]) {
        type = FileTypeConst_excel;
    } else if([[self pptTypeList] containsObject:end]) {
        type = FileTypeConst_ppt;
    } else if([[self wordTypeList] containsObject:end]) {
        type = FileTypeConst_word;
    } else if([[self zipTypeList] containsObject:end]) {
        type = FileTypeConst_zip;
    } else if([[self picTypeList] containsObject:end]) {
        type = FileTypeConst_pic;
    } else if([end isEqualToString:@"pdf"]) {
        type = FileTypeConst_pdf;
    } else if([end isEqualToString:@"txt"]) {
        type = FileTypeConst_txt;
    } else if([end isEqualToString:@"apk"]) {
        type = FileTypeConst_apk;
    } else {
        type = FileTypeConst_none;
    }
    
    return type;
}
@end
