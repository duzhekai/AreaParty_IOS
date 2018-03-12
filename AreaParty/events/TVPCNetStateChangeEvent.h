//
//  TVPCNetStateChangeEvent.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/1/5.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TVPCNetStateChangeEvent : NSObject{
    BOOL isTVOnline;
    BOOL isPCOnline;
}
- (instancetype)initWithTVOnline:(BOOL)istvonline andPCOnline:(BOOL)ispconline;
-(BOOL)isTVOnline;
-(BOOL)isPCOnline;
@end
