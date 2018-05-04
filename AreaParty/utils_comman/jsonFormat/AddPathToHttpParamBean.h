//
//  AddPathToHttpParamBean.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/5/2.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddPathToHttpParamBean : NSObject
@property (strong,nonatomic) NSString* paths;
- (void)makePath:(NSArray<NSString*>*)path;
@end
