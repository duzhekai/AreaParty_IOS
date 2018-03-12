//
//  RebootDialog.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/3/12.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "RebootDialog.h"
#import "prepareDataForFragment_monitor.h"
#import "OrderConst.h"
@implementation RebootDialog{
    UITapGestureRecognizer* rec;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
- (void) showDialogInView:(UIView*) outview{
    float width = outview.frame.size.width-50;
    UIView* contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 200)];
    contentView.backgroundColor = [UIColor whiteColor];
    UIView* titleView = [[UIView alloc] initWithFrame:CGRectMake(0,0,width, 50)];
    UILabel * title_label = [[UILabel alloc] initWithFrame:CGRectMake(10,15, 100, 20)];
    titleView.backgroundColor = [UIColor colorWithRed:230/255.0 green:87/255.0 blue:87/255.0 alpha:1];
    title_label.text = @"提示";
    title_label.textColor = [UIColor whiteColor];
    title_label.textAlignment = NSTextAlignmentCenter;
    title_label.center = titleView.center;
    
    UILabel* content_label = [[UILabel alloc] initWithFrame:CGRectMake(20, 65, width-20,50)];
    content_label.textAlignment = NSTextAlignmentLeft;
    content_label.numberOfLines = 6;
    CGFloat fontSize;
    NSString  *testString = @"即将重启电脑，此过程将无法获取监控信息。\n一旦重启成功，应用将自动获取监控信息。\n重启前请确保电脑能够开机自动登录。" ;
    UIFont *font = [UIFont systemFontOfSize:100];
    [testString sizeWithFont:font
                 minFontSize:7.0f
              actualFontSize:&fontSize
                    forWidth:(width-40)*3
               lineBreakMode:NSLineBreakByCharWrapping];
    [content_label setFont:[UIFont systemFontOfSize:fontSize]];
    [content_label setText:testString];
    [content_label sizeToFit];
    
    
    UILabel* link_text = [[UILabel alloc] initWithFrame:CGRectMake(20, content_label.frame.origin.y+content_label.frame.size.height+25,width, 20)];
    
    NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSString  *testString2 = @"windows开机自动登录指南";
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:testString2 attributes:attribtDic];
    rec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(taped:)];
    [link_text setFont:[UIFont systemFontOfSize:fontSize]];
    [link_text setTextColor:[UIColor colorWithRed:230/255.0 green:87/255.0  blue:87/255.0  alpha:1]];
    [link_text setAttributedText:attribtStr];
    link_text.userInteractionEnabled = YES;
    [link_text addGestureRecognizer:rec];
    
    
    
    UIButton* ok_button = [[UIButton alloc] initWithFrame:CGRectMake(width-80,link_text.frame.origin.y+45, 60, 20)];
    [ok_button setTitle:@"确定重启" forState:UIControlStateNormal];
    [ok_button setTitleColor:[UIColor colorWithRed:230/255.0 green:87/255.0  blue:87/255.0  alpha:1] forState:UIControlStateNormal];
    [ok_button setFont:[UIFont systemFontOfSize:fontSize]];
    [ok_button sizeToFit];
    [ok_button addTarget:self action:@selector(ok_button_pressed) forControlEvents:UIControlEventTouchUpInside];
    UIButton* cancel_button = [[UIButton alloc] initWithFrame:CGRectMake(ok_button.frame.origin.x-20-ok_button.frame.size.width,link_text.frame.origin.y+45,ok_button.frame.size.width, 20)];
    [cancel_button setTitle:@"取消重启" forState:UIControlStateNormal];
    [cancel_button setTitleColor:[UIColor colorWithRed:230/255.0 green:87/255.0  blue:87/255.0  alpha:1] forState:UIControlStateNormal];
    [cancel_button setFont:[UIFont systemFontOfSize:fontSize]];
    [cancel_button sizeToFit];
    [cancel_button addTarget:self action:@selector(cancel_button_pressed) forControlEvents:UIControlEventTouchUpInside];
    
    float height = 45+ ok_button.frame.origin.y;
    contentView.frame = CGRectMake(0, 0,width,height);
    [titleView addSubview:title_label];
    [contentView addSubview:titleView];
    [contentView addSubview:content_label];
    [contentView addSubview:ok_button];
    [contentView addSubview:link_text];
    [contentView addSubview:cancel_button];
    contentView.center = outview.center;
    contentView.layer.shadowColor = [UIColor blackColor].CGColor;
    contentView.layer.shadowOffset = CGSizeMake(0,0);
    contentView.layer.shadowOpacity = 0.5;//阴影透明度，默认0
    contentView.layer.shadowRadius = 3;//阴影半径，默认3
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    [self addSubview:contentView];
    [outview addSubview:self];
}
- (void)taped:(UITapGestureRecognizer*) rec{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://jingyan.baidu.com/article/95c9d20d4e8722ec4f75616f.html?qq-pf-to=pcqq.c2c"]];
}
- (void)ok_button_pressed{
    [NSThread detachNewThreadWithBlock:^(void){
        [prepareDataForFragment_monitor getActionStateData:OrderConst_computerAction_name Command:OrderConst_computerAction_reboot_command Param:@""];
    }];
    [self removeView];
}
- (void) cancel_button_pressed{
    [self removeView];
}
- (void)removeView{
    [self removeFromSuperview];
}

@end
