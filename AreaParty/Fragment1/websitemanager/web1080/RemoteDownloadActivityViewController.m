//
//  RemoteDownloadActivityViewController.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/1/5.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "RemoteDownloadActivityViewController.h"

@interface RemoteDownloadActivityViewController ()

@end
static NSString* btFilesPath;
@implementation RemoteDownloadActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
+ (void)setbtFilesPath:(NSString*) path{
    btFilesPath = path;
}
+ (NSString*)getbtFilesPath{
    return btFilesPath;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end