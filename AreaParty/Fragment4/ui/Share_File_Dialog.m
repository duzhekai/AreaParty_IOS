//
//  Share_File_Dialog.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/5/3.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "Share_File_Dialog.h"

@interface Share_File_Dialog ()

@end

@implementation Share_File_Dialog

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    // Do any additional setup after loading the view.
    [_NameLabel setText:[@"文件名： " stringByAppendingString:(NSString*)_h[@"fileName"] ]];
    [_SizeLabel setText:[@"文件大小： " stringByAppendingString:[self getSize:[((NSString*)_h[@"fileSize"]) intValue]]]];
    
    if(![((NSString*)_h[@"fileInfo"]) isEqualToString:@""])
        [_DesLabel setText:[@"文件描述： " stringByAppendingString:(NSString*)_h[@"fileInfo"]]];
    else
        [_DesLabel setText:@"文件描述： 这家伙什么都没写"];
     
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

- (IBAction)Press_Delete:(id)sender {
    [_delegate performSelector:@selector(Press_DeleteSharedFile:) withObject:_h];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(NSString*) getSize:(int) size{
    //如果原字节数除于1024之后，少于1024，则可以直接以KB作为单位
    //因为还没有到达要使用另一个单位的时候
    //接下去以此类推
    if (size < 1024) {
        return [NSString stringWithFormat:@"%dKB",size];
    } else {
        size = size*10 / 1024;
    }
    if (size < 10240) {
        //保留1位小数，
        return [NSString stringWithFormat:@"%d.%dMB",size/10,size%10];
    } else {
        //保留2位小数
        size = size * 10 / 1024;
        return [NSString stringWithFormat:@"%d.%dGB",size/100,size%100];
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self.view];
    if((touchPoint.x > _containerView.frame.origin.x) && (touchPoint.x < _containerView.frame.origin.x+_containerView.frame.size.width) && (touchPoint.y > _containerView.frame.origin.y) && (touchPoint.y < _containerView.frame.origin.y+_containerView.frame.size.height)){
        
    }
    else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
@end
