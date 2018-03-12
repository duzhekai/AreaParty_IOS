//
//  RemoteDownloadActivityViewController.h
//  AreaParty
//
//  Created by 杜哲凯 on 2018/1/5.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RemoteDownloadActivityViewController : UIViewController
+ (void)setbtFilesPath:(NSString*) path;
+ (NSString*)getbtFilesPath;
@end
