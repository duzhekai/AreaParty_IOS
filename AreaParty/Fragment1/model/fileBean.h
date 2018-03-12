//
//  fileBean.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/1/25.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface fileBean : NSObject
@property(strong,nonatomic) NSString* name;
@property(assign,nonatomic) int type;
@property(assign,nonatomic) int size;
@property(strong,nonatomic) NSString* lastChangeTime;
@property(assign,nonatomic) int subNum;
@property(assign,nonatomic) BOOL isShow;    // 是否显示CheckBox
@property(assign,nonatomic) BOOL isChecked; // 是否选中
@end
