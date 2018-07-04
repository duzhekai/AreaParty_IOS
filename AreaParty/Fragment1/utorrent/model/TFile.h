//
//  TFile.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/5/23.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TFile : NSObject
@property (strong,nonatomic) NSString* name;
@property (strong,nonatomic) NSString* size;
@property (strong,nonatomic) NSString* progress;
@property (assign,nonatomic) int priority;
@property (strong,nonatomic) NSString* downloaded;
- (void) setTFile:(TFile*) f;
@end
