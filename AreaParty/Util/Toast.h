//
//  Toast.h
//  AreaParty
//
//  Created by 杜哲凯 on 2017/11/19.
//  Copyright © 2017年 杜哲凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface Toast : NSObject

+(void) ShowToast:(NSString*) text Animated:(BOOL)ani time:(NSInteger)time context:(UIView*)view;

@end
