//
//  headIndexToImgId.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/1/12.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "headIndexToImgId.h"

@implementation headIndexToImgId
+ (NSString*) toImgId:(int) headIndex{
    switch (headIndex){
        case 0:
            return @"tx1.png";
        case 1:
            return @"tx2.png";
        case 2:
            return @"tx3.png";
        case 3:
            return @"tx4.png";
        case 4:
            return @"tx5.png";
        default:
            return @"tx1.png";
    }
}
@end
