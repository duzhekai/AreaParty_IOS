//
//  Process_detail_dialog.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/3/10.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "Process_detail_dialog.h"

@implementation Process_detail_dialog

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void) showDialogInView:(UIView*) outview Title:(NSString*) title Path:(NSString*) path CPU:(NSString*) cpu Memory:(NSString*) memory{
    float width = outview.frame.size.width-50;
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 300)];
    _contentView.backgroundColor = [UIColor whiteColor];
    UIView* titleView = [[UIView alloc] initWithFrame:CGRectMake(0,0,width, 50)];
    UILabel * title_label = [[UILabel alloc] initWithFrame:CGRectMake(10,15, 300, 20)];
    UILabel * path_title_label = [[UILabel alloc] initWithFrame:CGRectMake(10,65, width/2.0-10, 20)];
    UILabel * path_text_label = [[UILabel alloc] initWithFrame:CGRectMake(width/2.0,65,width/2.0-10, 40)];
    titleView.backgroundColor = [UIColor colorWithRed:230/255.0 green:87/255.0 blue:87/255.0 alpha:1];
    title_label.text = title;
    title_label.textColor = [UIColor whiteColor];
    path_title_label.text = @"路径名称";
    path_text_label.numberOfLines = 5;
    path_text_label.textColor = [UIColor colorWithRed:168/255.0 green:168/255.0 blue:168/255.0 alpha:1];
    path_text_label.text = path;
    [path_text_label sizeToFit];
    UILabel* CPU_text_label = [[UILabel alloc] initWithFrame:CGRectMake(width/2.0,path_text_label.frame.origin.y+path_text_label.frame.size.height+25, width/2.0,20)];
    UILabel* CPU_title_label = [[UILabel alloc] initWithFrame:CGRectMake(10,CPU_text_label.frame.origin.y,width/2.0-10,20)];
    CPU_title_label.text = @"当前CPU使用率(%)";
    CPU_text_label.textColor =  [UIColor colorWithRed:168/255.0 green:168/255.0 blue:168/255.0 alpha:1];
    CPU_text_label.text = cpu;
    
    UILabel* Memory_text_label = [[UILabel alloc] initWithFrame:CGRectMake(width/2.0, CPU_text_label.frame.origin.y+45, width/2.0,20)];
    UILabel* Memory_title_label = [[UILabel alloc] initWithFrame:CGRectMake(10,Memory_text_label.frame.origin.y,width/2.0-10,20)];
    Memory_title_label.text = @"当前内存大小(KB)";
    Memory_text_label.textColor =  [UIColor colorWithRed:168/255.0 green:168/255.0 blue:168/255.0 alpha:1];
    Memory_text_label.text = memory;
    
    UIButton* ok_button = [[UIButton alloc] initWithFrame:CGRectMake(width-60, Memory_text_label.frame.origin.y+30, 40, 20)];
    [ok_button setTitle:@"确定" forState:UIControlStateNormal];
    [ok_button setTitleColor:[UIColor colorWithRed:230/255.0 green:87/255.0  blue:87/255.0  alpha:1] forState:UIControlStateNormal];
    [ok_button addTarget:self action:@selector(ok_button_pressed) forControlEvents:UIControlEventTouchUpInside];
    float height = 45+ ok_button.frame.origin.y;
    _contentView.frame = CGRectMake(0, 0,width,height);
    [titleView addSubview:title_label];
    [_contentView addSubview:titleView];
    [_contentView addSubview:path_title_label];
    [_contentView addSubview:path_text_label];
    [_contentView addSubview:CPU_title_label];
    [_contentView addSubview:CPU_text_label];
    [_contentView addSubview:Memory_text_label];
    [_contentView addSubview: Memory_title_label];
    [_contentView addSubview: ok_button];
    _contentView.center = outview.center;
    _contentView.backgroundColor = [UIColor whiteColor];
    _contentView.layer.shadowColor = [UIColor blackColor].CGColor;
    _contentView.layer.shadowOffset = CGSizeMake(0,0);
    _contentView.layer.shadowOpacity = 0.5;//阴影透明度，默认0
    _contentView.layer.shadowRadius = 3;//阴影半径，默认3
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    [self addSubview:_contentView];
    [outview addSubview:self];
}
- (void)ok_button_pressed{
    [self removeView];
}
- (void)removeView{
    [self removeFromSuperview];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    if((touchPoint.x > _contentView.frame.origin.x) && (touchPoint.x < _contentView.frame.origin.x+_contentView.frame.size.width) && (touchPoint.y > _contentView.frame.origin.y) && (touchPoint.y < _contentView.frame.origin.y+_contentView.frame.size.height)){
        
    }
    else{
        [self removeView];
    }
}
@end
