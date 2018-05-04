//
//  downloadVC.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/2/28.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "downloadVC.h"
#import "downloadTab01Fragment.h"
#import "downloadTab02Fragment.h"
@interface downloadVC (){
    int initial_offset_x;
}

@end

@implementation downloadVC{
    downloadTab01Fragment* fragment1;
    downloadTab02Fragment* fragment2;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    int SCREEN_W = [UIScreen mainScreen].bounds.size.width;
    initial_offset_x = _Indicator.frame.origin.x;
    fragment1 = [[UIStoryboard storyboardWithName:@"Main2" bundle:nil] instantiateViewControllerWithIdentifier:@"downloadTab01Fragment"];
    [fragment1 viewWillAppear:YES];
    fragment1.view.frame = CGRectMake(0, 0,_page04DownloadVP.frame.size.width, _page04DownloadVP.frame.size.height);
    fragment2 = [[UIStoryboard storyboardWithName:@"Main2" bundle:nil] instantiateViewControllerWithIdentifier:@"downloadTab02Fragment"];
    [fragment2 viewWillAppear:YES];
    fragment2.view.frame = CGRectMake(SCREEN_W, 0,_page04DownloadVP.frame.size.width, _page04DownloadVP.frame.size.height);
    [_page04DownloadVP addSubview:fragment1.view];
    [_page04DownloadVP addSubview:fragment2.view];
    _page04DownloadVP.contentSize = CGSizeMake(SCREEN_W*2,_page04DownloadVP.frame.size.height);
    _page04DownloadVP.delegate = self;
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

- (IBAction)Press_Back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(scrollView == _page04DownloadVP){
        int content_off = scrollView.contentOffset.x;
        int window_width = [UIScreen mainScreen].bounds.size.width;
        int distance = _Tab2.frame.origin.x - _Tab1.frame.origin.x;
        [_Indicator setFrame:CGRectMake(initial_offset_x+((float)((float)content_off/(float)window_width))*distance, _Indicator.frame.origin.y, _Indicator.frame.size.width, _Indicator.frame.size.height)];
    }
}
@end
