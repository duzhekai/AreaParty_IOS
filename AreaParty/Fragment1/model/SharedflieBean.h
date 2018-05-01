//
//  SharedflieBean.h
//  AreaParty
//
//  Created by 杜哲凯 on 2017/12/4.
//  Copyright © 2017年 杜哲凯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedflieBean : NSObject
@property(assign,nonatomic) int mid;
@property(copy,nonatomic) NSString* name;
@property(copy,nonatomic) NSString* path;
@property(assign,nonatomic) int size;
@property(copy,nonatomic) NSString* des;
@property(copy,nonatomic) NSString* timeStr;
@property(assign,nonatomic) long timeLong;
@property(copy,nonatomic) NSString* url;
@property(copy,nonatomic) NSString* pwd;
- (instancetype)initWithId:(int)mid Name:(NSString*)mname Path:(NSString*)mpath Size:(int)msize Des:(NSString*)mdes TimeStr:(NSString*)mtime;
- (instancetype)initWithName:(NSString*)mname Path:(NSString*)mpath Size:(int)msize Des:(NSString*)mdes TimeLong:(long)mtimelong URL:(NSString*) murl Pwd:(NSString*) mpwd;
- (instancetype)initWithName:(NSString*)mname Size:(int)msize Des:(NSString*)mdes TimeLong:(long)mtimelong;
@end
