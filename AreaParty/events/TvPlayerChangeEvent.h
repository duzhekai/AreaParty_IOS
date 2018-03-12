//
//  TvPlayerChangeEvent.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/1/5.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TvPlayerChangeEvent : NSObject{
    BOOL isPlayerRun;
}
- (instancetype) initWithIsRun:(BOOL)isrun;
- (BOOL)isPlayerRun;
@end
