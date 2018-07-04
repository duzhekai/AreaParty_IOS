//
//  StartActivity.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/5/8.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "StartActivity.h"
#import "IPAddressConst.h"
#import <AFNetworking/AFNetworking.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface StartActivity (){
    //图片按钮
    NSMutableArray<UIImageView*>* image;
    //链接按钮
    NSMutableArray<UIButton*>* btn;
}

@end

static NSMutableArray<NSString*>* url;
static NSMutableArray<NSString*>* imageUrl;
static NSMutableArray<NSNumber*>* type;
@implementation StartActivity

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
}
- (void) initView{
    image = [[NSMutableArray alloc] init];
    btn = [[NSMutableArray alloc] init];
    [image addObject:_image1];
    [image addObject:_image2];
    [image addObject:_image3];
    [image addObject:_image4];
    [image addObject:_image5];
    [btn addObject:_url1];
    [btn addObject:_url2];
    [btn addObject:_url3];
    [btn addObject:_url4];
    [btn addObject:_url5];
    _download_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Tapped:)];
    [_downloadManagementLL addGestureRecognizer:_download_tap];
    if (url == nil || imageUrl == nil) {
        [self getWebSiteUrl];
    }else {
        [self initWebSite];
    }
}
- (void) Tapped:(UITapGestureRecognizer*) tap{
    if(tap == _download_tap){
        [self presentViewController:[[UIStoryboard storyboardWithName:@"Main2" bundle:nil] instantiateViewControllerWithIdentifier:@"RemoteDownloadActivityViewController"] animated:YES completion:nil];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) getWebSiteUrl{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString* URL = [NSString stringWithFormat:@"http://%@/bt_website/get_data.json",IPAddressConst_statisticServer_ip];
    [manager GET:URL parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    }
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             NSLog(@"%@",responseObject);
             @try {
                 NSArray* jsonArray = (NSArray*) responseObject;
                 url = [[NSMutableArray alloc] init];
                 imageUrl = [[NSMutableArray alloc] init];
                 type = [[NSMutableArray alloc] init];
                 for (int i =0 ; i< jsonArray.count; i++){
                     NSDictionary* jsonObject = jsonArray[i];
                     [url addObject:jsonObject[@"url"]];
                     [imageUrl addObject:[NSString stringWithFormat:@"http://%@/bt_website/%@",IPAddressConst_statisticServer_ip,jsonObject[@"image"]]];
                     [type addObject:jsonObject[@"type"]];
                 }
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [self initWebSite];
                 });
             } @catch (NSException* e) {

             }
             
         }
     
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
             
             NSLog(@"%@",error);  //这里打印错误信息
             
         }];

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void) initWebSite{
    for (int i = 0; i< 5; i++){
        [image[i] sd_setImageWithURL:[NSURL URLWithString:imageUrl[i]] placeholderImage:nil];
        [btn[i] setTitle:[url[i] stringByReplacingOccurrencesOfString:@"http://" withString:@""]forState:UIControlStateNormal];
        [btn[i] addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}
- (void) onClick:(UIButton*) sender{
    if(sender == btn[0]){
        [self goToWebSite:0];
    }
    else if(sender == btn[1]){
        [self goToWebSite:1];
    }
    else if(sender == btn[2]){
        [self goToWebSite:2];
    }
    else if(sender == btn[3]){
        [self goToWebSite:3];
    }
    else if(sender == btn[4]){
        [self goToWebSite:4];
    }
}
- (IBAction)Press_helpInfo:(id)sender {
}
- (void) goToWebSite:(int) i{
    if (i > 4 ) return;
//    if ([type[i] intValue] == 0){
        MainActivity* mainActivity = [[UIStoryboard storyboardWithName:@"Main2" bundle:nil] instantiateViewControllerWithIdentifier:@"MainActivity"];
        mainActivity.intent_bundle = [NSMutableDictionary dictionaryWithObject:url[i] forKey:@"URL"];
        mainActivity.parent = self;
        [self presentViewController:mainActivity animated:YES completion:nil];
//    }else if ([type[i] intValue] == 1){
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url[i]]];
//    }
}
- (IBAction)Press_back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
