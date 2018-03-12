//
//  onHandler.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/1/3.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol onHandler
//message@{@"obj":obj,@"what":nsstring}
- (void)onHandler:(NSDictionary*)message;

@end
@interface onHandler : NSObject

@end
