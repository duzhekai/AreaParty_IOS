//
//  onUIControllerResult.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/1/3.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol onUIControllerResult

- (void)onUIControllerResultWithCode:(int)resultCode andData:(NSDictionary*)data;

@end
@interface onUIControllerResult : NSObject

@end
