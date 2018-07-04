//
//  MainActivity.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/5/8.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "MainActivity.h"

@interface MainActivity (){
    NSString* StringUrl;
}

@end

@implementation MainActivity

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    StringUrl = (NSString*)_intent_bundle[@"URL"];
    _mWebView.delegate = self;
    [_mWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:StringUrl]]];
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
    if(_mWebView.canGoBack)
        [_mWebView goBack];
    else
        [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)Press_refresh:(id)sender {
    [_mWebView reload];
}
- (IBAction)Press_remote_download:(id)sender {
    [self presentViewController:[[UIStoryboard storyboardWithName:@"Main2" bundle:nil] instantiateViewControllerWithIdentifier:@"RemoteDownloadActivityViewController"] animated:YES completion:nil];
}

- (IBAction)Press_go_home:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        if(_parent)
           [_parent dismissViewControllerAnimated:YES completion:nil];
    }];
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request1 navigationType:(UIWebViewNavigationType)navigationType{
    if (navigationType==UIWebViewNavigationTypeLinkClicked) {
        NSError *error = nil;
        NSURLResponse *response = nil;
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:request1.URL];
        [NSURLConnection connectionWithRequest:request delegate:nil];
        [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        NSHTTPURLResponse *httpRes = (NSHTTPURLResponse*)response;
        NSDictionary *dic = [httpRes allHeaderFields];
        NSString *strValue = (NSString*)[dic objectForKey:@"Content-Disposition"];
        if(strValue){
            [self onDownloadStart:request.URL.absoluteString ContentDisposition:strValue];
            return NO;
        }
    }
    
    return YES;
}
- (void) onDownloadStart:(NSString*)url ContentDisposition:(NSString*) contentDisposition{
    NSRange range1 = [contentDisposition rangeOfString:@"="];
    NSRange range2 = [contentDisposition rangeOfString:@"torrent"];
    NSString* filename = [contentDisposition substringWithRange:NSMakeRange(range1.location+2, range2.location+5-range1.location)];
    UIAlertController* builder = [UIAlertController alertControllerWithTitle:@"种子文件下载" message:[NSString stringWithFormat:@"文件名_ %@",filename] preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击了按钮1，进入按钮1的事件");
        NSFileManager* fileMgr = [NSFileManager defaultManager];
        NSString *cacheDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES).firstObject;
        NSString* cacheFolder = [cacheDir stringByAppendingPathComponent:TorrentDownloadCacheFolderName];
        NSString* filepath = [cacheFolder stringByAppendingPathComponent:filename];
        if ([fileMgr fileExistsAtPath:filepath]){
            [Toast ShowToast:@"种子已经存在" Animated:YES time:1 context:self.view];
        }else{
            [self downloadTorrent:url FileName:filename];
        }
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击了取消");
    }];
    [builder addAction:action1];
    [builder addAction:action2];
    [self presentViewController:builder animated:YES completion:nil];
}
- (void) downloadTorrent:(NSString*) url FileName:(NSString*) name{
    [[DownloadManeger_torrent defaultInstance] downloadFileWithURL:url FileName:name progress:nil destination:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSURL * _Nonnull filePath) {
        [Toast ShowToast:@"下载成功" Animated:YES time:1 context:self.view];
    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        [Toast ShowToast:@"下载失败" Animated:YES time:1 context:self.view];
    }];
}
@end
