//
//  downloadManager.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/4/30.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "downloadManager.h"
#import "DownloadFolderFragment.h"
#import "DownloadStateFragment.h"
#import "MainTabbarController.h"
@interface downloadManager (){
        int initial_offset_x;
}

@end

@implementation downloadManager{
    DownloadFolderFragment* downloadFolderFragment;
    DownloadStateFragment* downloadStateFragment;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    int SCREEN_W = [UIScreen mainScreen].bounds.size.width;
    initial_offset_x = _Indicator.frame.origin.x;
    downloadFolderFragment = MainTabbarController_DownloadFolderFragment;
    [downloadFolderFragment viewWillAppear:YES];
    downloadFolderFragment.view.frame = CGRectMake(0, 0, _page_viewer_scrollView.frame.size.width, _page_viewer_scrollView.frame.size.height);
    
    downloadStateFragment = MainTabbarController_DownloadStateFragment;
    [downloadStateFragment viewWillAppear:YES];
    downloadStateFragment.view.frame = CGRectMake(SCREEN_W, 0, _page_viewer_scrollView.frame.size.width, _page_viewer_scrollView.frame.size.height);
    
    [_page_viewer_scrollView addSubview:downloadFolderFragment.view];
    [_page_viewer_scrollView addSubview:downloadStateFragment.view];
    _page_viewer_scrollView.contentSize = CGSizeMake(SCREEN_W*2,_page_viewer_scrollView.frame.size.height);
    _page_viewer_scrollView.delegate = self;
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

- (IBAction)Press_return:(id)sender {
    if([MyUIApplication getselectedPCOnline]){
        [downloadFolderFragment onkeyup:self];
    }
    else
        [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(scrollView == _page_viewer_scrollView){
        int content_off = scrollView.contentOffset.x;
        int window_width = [UIScreen mainScreen].bounds.size.width;
        int distance = _stateTitle.frame.origin.x - _DownloadTitle.frame.origin.x;
        [_Indicator setFrame:CGRectMake(initial_offset_x+((float)((float)content_off/(float)window_width))*distance, _Indicator.frame.origin.y, _Indicator.frame.size.width, _Indicator.frame.size.height)];
    }
}
@end
