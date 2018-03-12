//
//  Fragment2ViewController.m
//  AreaParty
//
//  Created by 杜哲凯 on 2017/11/13.
//  Copyright © 2017年 杜哲凯. All rights reserved.
//

#import "Fragment2ViewController.h"

@interface Fragment2ViewController ()

@end

@implementation Fragment2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //阴影设置
    _middleview.layer.shadowColor = [[UIColor blackColor] CGColor];
    _middleview.layer.shadowOffset = CGSizeMake(0,0);//偏移距离
    _middleview.layer.shadowRadius = 2;//半径
    _middleview.layer.cornerRadius = 5;
    _middleview.layer.shadowOpacity = 0.25;
    _middleview.clipsToBounds=NO;
    _Playlist.layer.shadowColor = [[UIColor blackColor] CGColor];
    _Playlist.layer.shadowOffset = CGSizeMake(0,0);//偏移距离
    _Playlist.layer.shadowRadius = 3;//半径
    _Playlist.layer.cornerRadius = 5;
    _Playlist.layer.shadowOpacity = 0.25;
    _Playlist.clipsToBounds=NO;
    _Music_playlist.layer.cornerRadius = 5;
    _Pic_playlist.layer.cornerRadius = 5;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
