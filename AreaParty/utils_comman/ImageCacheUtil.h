//
//  ImageCacheUtil.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/3/19.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ImageCacheUtil : NSObject
@property(strong,nonatomic) NSUserDefaults* defalts;
- (NSData*) readImage:(NSString*) url;
- (void)removeImage:(NSString*) url;
-(void) writeImage:(UIImage*)image andUrl:(NSString*)url;
@end
