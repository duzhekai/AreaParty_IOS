//
//  ImageCacheUtil.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/3/19.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "ImageCacheUtil.h"

@implementation ImageCacheUtil

-(void) writeImage:(UIImage*)image andUrl:(NSString*)url{
    if (url != nil && ![url isEqualToString:@""]) {
        int index_of_line = 0;
        for(int i = 0; i <url.length; i++){
            if([url characterAtIndex:i] == '/')
            index_of_line = i;
        }
        NSString* pic_name = [url substringFromIndex:index_of_line+1];
        [self.defalts setObject:UIImagePNGRepresentation(image) forKey:pic_name];
    }
}
- (void)removeImage:(NSString*) url{
    if (url != nil && ![url isEqualToString:@""]) {
        int index_of_line = 0;
        for(int i = 0; i <url.length; i++){
            if([url characterAtIndex:i] == '/')
                index_of_line = i;
        }
        NSString* pic_name = [url substringFromIndex:index_of_line+1];
        [self.defalts removeObjectForKey:pic_name];
    }
}
- (NSData*) readImage:(NSString*) url{
    if (url != nil && ![url isEqualToString:@""]) {
        int index_of_line = 0;
        for(int i = 0; i <url.length; i++){
            if([url characterAtIndex:i] == '/')
                index_of_line = i;
        }
    NSString* pic_name = [url substringFromIndex:index_of_line+1];
    return [self.defalts objectForKey:pic_name];
    }
    else return nil;
}
- (NSUserDefaults *)defalts{
    if(!_defalts){
        _defalts = [NSUserDefaults standardUserDefaults];
    }
    return _defalts;
}
@end
