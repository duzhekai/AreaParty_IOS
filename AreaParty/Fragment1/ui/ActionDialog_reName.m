//
//  ActionDialog_reName.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/5/1.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "ActionDialog_reName.h"
#import "FileTypeConst.h"
#import "diskContentVC.h"
@interface ActionDialog_reName ()

@end

@implementation ActionDialog_reName

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self.oldname setText:[NSString stringWithFormat:@"原文件名:%@",_oldfileName]];
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

- (IBAction)Press_cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)Press_sure:(id)sender {
    if([_holder isKindOfClass:[diskContentVC class]]){
        ((diskContentVC*)_holder).page04DiskContentBar02MoreRootLL.hidden= YES;
    }
    else
        ((DownloadFolderFragment*)_holder).page04DiskContentBar02MoreRootLL.hidden= YES;
    NSString* des = _valueEditText.text;
    if([des isEqualToString:@""]|| [des characterAtIndex:des.length-1] == '.' ||
       [des containsString:@"\\"] || [des containsString:@"/"] ||
       [des containsString:@":"] || [des containsString:@"*"] ||
       [des containsString:@"?"]   || [des containsString:@"\""] ||
       [des containsString:@"<"]  || [des containsString:@">"] ||
       [des containsString:@"|"]){
        [Toast ShowToast:@"设备名不能为空，不能包含\\ / : * ? \" < > |字符" Animated:YES time:1 context:self.view];
        [_valueEditText setText:@""];
    } else {
        if (_filetype == FileTypeConst_folder){
            if([_holder isKindOfClass:[diskContentVC class]]){
                [[diskContentVC getPCFileHelper] reNameFolder:_oldfileName Path:des];
            }
            else
                [[DownloadFolderFragment getPCFileHelper] reNameFolder:_oldfileName Path:des];
        }else {
            NSArray*a =  [_oldname.text componentsSeparatedByString:@"."];
            NSString* houzhui =  [a lastObject];
            if (![des containsString:@"."] && a.count!=1)
                des = [NSString stringWithFormat:@"%@.%@",des,houzhui];
            if([_holder isKindOfClass:[diskContentVC class]]){
                [[diskContentVC getPCFileHelper] reNameFile:_oldfileName Path:des];
            }
            else
                [[DownloadFolderFragment getPCFileHelper] reNameFile:_oldfileName Path:des];
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_valueEditText resignFirstResponder];
}
@end
