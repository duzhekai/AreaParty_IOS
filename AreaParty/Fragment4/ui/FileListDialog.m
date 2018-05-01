//
//  FileListDialog.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/4/28.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "FileListDialog.h"

@interface FileListDialog ()

@end

@implementation FileListDialog

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    int height = 50*_num;
    NSArray* arrs = _contentView.constraints;
    for(NSLayoutConstraint* attr in arrs){
        if(attr.firstAttribute == NSLayoutAttributeHeight){
            attr.constant = height;
        }
    }
    [_containerView updateConstraints];
    for(int i = 0;i<_num;i++){
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(20, 50*i, 200, 25)];
        label.text = [NSString stringWithFormat:@"文件%d   %@",i,_fileArray[i].fileName];
        [_contentView addSubview:label];
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
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self.view];
    if((touchPoint.x > _containerView.frame.origin.x) && (touchPoint.x < _containerView.frame.origin.x+_containerView.frame.size.width) && (touchPoint.y > _containerView.frame.origin.y) && (touchPoint.y < _containerView.frame.origin.y+_containerView.frame.size.height)){
        
    }
    else{
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}
@end
