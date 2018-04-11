//
//  ActionDialog_page.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/4/11.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "ActionDialog_page.h"

@interface ActionDialog_page ()

@end

@implementation ActionDialog_page

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    _web_content_view.delegate = self;
    // Do any additional setup after loading the view.
    if([_type isEqualToString:@"dialog_page01"]){
        NSArray* arrs = _dialog_container.constraints;
        for(NSLayoutConstraint* attr in arrs){
            if(attr.firstAttribute == NSLayoutAttributeHeight){
                attr.constant = self.view.frame.size.height-100;
            }
        }
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"page01" ofType:@"html"];
        NSURL *url = [[NSURL alloc] initWithString:filePath];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [_web_content_view loadRequest:request];
    }
    else if([_type isEqualToString:@"dialog_page02"]){
        NSArray* arrs = _dialog_container.constraints;
        for(NSLayoutConstraint* attr in arrs){
            if(attr.firstAttribute == NSLayoutAttributeHeight){
                attr.constant = 300;
            }
        }
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"page02" ofType:@"html"];
        NSURL *url = [[NSURL alloc] initWithString:filePath];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [_web_content_view loadRequest:request];
    }
    else if([_type isEqualToString:@"dialog_page03"]){
        NSArray* arrs = _dialog_container.constraints;
        for(NSLayoutConstraint* attr in arrs){
            if(attr.firstAttribute == NSLayoutAttributeHeight){
                attr.constant = 350;
            }
        }
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"page03" ofType:@"html"];
        NSURL *url = [[NSURL alloc] initWithString:filePath];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [_web_content_view loadRequest:request];
    }
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
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;

{
    NSURL *requestURL =[ request URL ];
    if ( ( [ [ requestURL scheme ] isEqualToString: @"http" ] || [ [ requestURL scheme ] isEqualToString: @"https" ] || [ [ requestURL scheme ] isEqualToString: @"mailto" ])
        && ( navigationType == UIWebViewNavigationTypeLinkClicked ) ) {
        return ![ [ UIApplication sharedApplication ] openURL:requestURL];
    }
    return YES;
}

- (IBAction)press_off:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
