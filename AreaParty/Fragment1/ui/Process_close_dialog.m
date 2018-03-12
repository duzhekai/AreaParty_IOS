//
//  Process_close_dialog.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/3/10.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "Process_close_dialog.h"
#import "Toast.h"
#import "prepareDataForFragment_monitor.h"
@implementation Process_close_dialog

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void) showDialogInView{
    float width = _mhandler.view.frame.size.width-50;
    UIView* contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 200)];
    contentView.backgroundColor = [UIColor whiteColor];
    UIView* titleView = [[UIView alloc] initWithFrame:CGRectMake(0,0,width, 50)];
    UILabel * title_label = [[UILabel alloc] initWithFrame:CGRectMake(10,15, 100, 20)];
    titleView.backgroundColor = [UIColor colorWithRed:230/255.0 green:87/255.0 blue:87/255.0 alpha:1];
    title_label.text = @"提示";
    title_label.textColor = [UIColor whiteColor];
    title_label.textAlignment = NSTextAlignmentCenter;
    title_label.center = titleView.center;
    
    
    UILabel* content_label = [[UILabel alloc] initWithFrame:CGRectMake(20, 65, width-40,50)];
    content_label.numberOfLines = 3;
    content_label.text = [NSString stringWithFormat:@"尝试从主机系统中关闭进程 %@",_process.name];
    [content_label sizeToFit];
    UIButton* ok_button = [[UIButton alloc] initWithFrame:CGRectMake(width-60,160, 40, 20)];
    [ok_button setTitle:@"确定" forState:UIControlStateNormal];
    [ok_button setTitleColor:[UIColor colorWithRed:230/255.0 green:87/255.0  blue:87/255.0  alpha:1] forState:UIControlStateNormal];
    [ok_button addTarget:self action:@selector(ok_button_pressed) forControlEvents:UIControlEventTouchUpInside];
    UIButton* cancel_button = [[UIButton alloc] initWithFrame:CGRectMake(width-120,160, 40, 20)];
    [cancel_button setTitle:@"取消" forState:UIControlStateNormal];
    [cancel_button setTitleColor:[UIColor colorWithRed:230/255.0 green:87/255.0  blue:87/255.0  alpha:1] forState:UIControlStateNormal];
    [cancel_button addTarget:self action:@selector(cancel_button_pressed) forControlEvents:UIControlEventTouchUpInside];
    
    float height = 45+ ok_button.frame.origin.y;
    contentView.frame = CGRectMake(0, 0,width,height);
    [titleView addSubview:title_label];
    [contentView addSubview:titleView];
    [contentView addSubview:content_label];
    [contentView addSubview:ok_button];
    [contentView addSubview:cancel_button];
    contentView.center = _mhandler.view.center;
    contentView.layer.shadowColor = [UIColor blackColor].CGColor;
    contentView.layer.shadowOffset = CGSizeMake(0,0);
    contentView.layer.shadowOpacity = 0.5;//阴影透明度，默认0
    contentView.layer.shadowRadius = 3;//阴影半径，默认3
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    [self addSubview:contentView];
    [_mhandler.view addSubview:self];
}
- (void)ok_button_pressed{
    [self removeView];
    [NSThread detachNewThreadWithBlock:^(void){
        ReceivedActionMessageFormat* message = [prepareDataForFragment_monitor getActionStateData:OrderConst_processAction_name Command:OrderConst_process_closeById_command Param:[NSString stringWithFormat:@"%d",_process.p_id]];
        if(message.status == 404) {
                    dispatch_async(dispatch_get_main_queue(), ^{
            [self onHandler:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:OrderConst_actionFail_order],@"what",nil]];
                    });
        }
        if(message.status == 200) {
                                dispatch_async(dispatch_get_main_queue(), ^{
            [self onHandler:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:OrderConst_actionSuccess_order],@"what",nil]];
                                });
        }
    }];
}
- (void) cancel_button_pressed{
    [self removeView];
}
- (void)removeView{
    [self removeFromSuperview];
}
- (void)onHandler:(NSDictionary *)message{
    if([[message objectForKey:@"what"]intValue] == OrderConst_actionFail_order){
        [Toast ShowToast:[NSString stringWithFormat:@"操作失败，失败信息：%@",[message objectForKey:@"obj"]] Animated:YES time:1 context:_mhandler.view];
    }
    else if([[message objectForKey:@"what"]intValue] == OrderConst_actionSuccess_order){
        [Toast ShowToast:@"操作成功" Animated:YES time:1 context:_mhandler.view];
        NSMutableArray* temp = [prepareDataForFragment_monitor getcurrentProcesses];
        ProcessFormat* dele_item = [prepareDataForFragment_monitor getProcessById:_process.p_id];
        [temp removeObject:dele_item];
        [_mhandler._process_listView reloadData];
    }
}
@end
