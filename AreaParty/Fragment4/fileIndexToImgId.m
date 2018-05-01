//
//  fileIndexToImgId.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/4/20.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "fileIndexToImgId.h"

@implementation fileIndexToImgId
+ (NSString*) toImgId:(int) fileIndex{
    switch (fileIndex){
        case 1:
            return @"folder.png";
        case 2:
            return @"excel.png";
        case 3:
            return @"music.png";
        case 4:
            return @"pdf.png";
        case 5:
            return @"ppt.png";
        case 6:
            return @"video.png";
        case 7:
            return @"word.png";
        case 8:
            return @"zip.png";
        case 9:
            return @"txt.png";
        case 10:
            return @"pic.png";
        default:
            return @"none.png";
    }
}
@end
