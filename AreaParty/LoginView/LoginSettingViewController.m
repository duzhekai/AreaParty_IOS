//
//  LoginSettingViewController.m
//  AreaParty
//
//  Created by 杜哲凯 on 2017/11/10.
//  Copyright © 2017年 杜哲凯. All rights reserved.
//

#import "LoginSettingViewController.h"

@interface LoginSettingViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *setting_outline;
@property (weak, nonatomic) IBOutlet UITextField *setting_ip;
@property (weak, nonatomic) IBOutlet UITextField *setting_port;

@end

@implementation LoginSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //设置navigationbar的文字和颜色
    self.navigationItem.title = @"设置";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:24],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //设置navigationbar右侧确认图标
    UIView* rightview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    UIImageView* rightimageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"get.png"]];
    rightimageview.frame = CGRectMake(0, 0, 23, 23);
    rightview.userInteractionEnabled=YES;
    //添加手势
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressbtnget)];
    //将手势添加到需要相应的view中去
    [rightview addGestureRecognizer:tapGesture];
    [rightview addSubview:rightimageview];
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightview];
    self.navigationItem.rightBarButtonItem= rightItem;
    //
    [self initView];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_setting_ip resignFirstResponder];
    [_setting_port resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)pressbtnget{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:[_setting_port.text integerValue] forKey:@"SERVER_PORT"];
    [defaults setObject:_setting_ip.text forKey:@"SERVER_IP"];
    LoginViewController* root = (LoginViewController*)self.navigationController.viewControllers[0];
    [root setmport:[_setting_port.text integerValue] ];
    [root sethost:_setting_ip.text];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void) initView{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSInteger mport = [defaults integerForKey:@"SERVER_PORT"];
    NSString* mhost = [defaults stringForKey:@"SERVER_IP"];
    [_setting_ip setText:mhost];
    [_setting_port setText:[NSString stringWithFormat:@"%ld",(long)mport]];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
