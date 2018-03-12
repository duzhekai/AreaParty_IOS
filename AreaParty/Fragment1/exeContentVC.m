//
//  exeContentVC.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/3/12.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "exeContentVC.h"
#import "AVLoadingIndicatorView.h"
@interface exeContentVC (){
    NSMutableArray<ExeInformat*>* exeDatas;
    AVLoadingIndicatorView* loadingview;
}

@end

@implementation exeContentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    exeDatas = [[NSMutableArray alloc] init];
    loadingview = [[AVLoadingIndicatorView alloc] initWithFrame:self.view.frame];
    _exe_table_view.separatorStyle = NO;
    _exe_table_view.delegate = self;
    _exe_table_view.dataSource = self;
    [self loadingExe];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) loadingExe{
    [loadingview showPromptViewOnView:self.view];
    [NSThread detachNewThreadWithBlock:^(void){
        @try {
            ReceivedExeListFormat* exes = (ReceivedExeListFormat*)
            [prepareDataForFragment_monitor getExeActionStateData:(NSString *)OrderConst_exeAction_name command:OrderConst_appAction_get_command Param:@""];
            if(exes.status == OrderConst_success) {
                int num = (int)exes.data.count;
                exeDatas = [[NSMutableArray alloc] init];
                for(int i = 0; i < num; i++) {
                    ExeInformat* temp = [[ExeInformat alloc] init];
                    temp.displayName = exes.data[i].displayName;
                    temp.displayVersion = exes.data[i].displayVersion;
                    temp.publisher = exes.data[i].publisher;
                    [exeDatas addObject:temp];
                    
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                [self onHandler:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:OrderConst_getExeList_order_successful],@"what",nil]];
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                [self onHandler:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:OrderConst_getExeList_order_fail],@"what",nil]];
                });
            }
        } @catch (NSException* e) {
                dispatch_async(dispatch_get_main_queue(), ^{
                [self onHandler:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:OrderConst_getExeList_order_fail],@"what",nil]];
                });
        }
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
- (void)onHandler:(NSDictionary *)message{
    if([[message objectForKey:@"what"] intValue] == OrderConst_getExeList_order_successful){
        [_exe_table_view reloadData];
        [loadingview removeView];
    }
    if([[message objectForKey:@"what"] intValue] == OrderConst_getExeList_order_fail){
        [Toast ShowToast:@"获取应用列表失败，请刷新" Animated:YES time:1 context:self.view];
    }
}
- (IBAction)press_return:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
//tableview delegete start
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return exeDatas.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseIdentifier = @"exe_item_cell";
    
    exe_item_cell* cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    //如果缓存池中没有,那么创建一个新的cell
    if (!cell) {
        //这里换成自己定义的cell,并调用类方法加载xib文件
        cell = [[[NSBundle mainBundle] loadNibNamed:@"exe_item_cell" owner:nil options:nil] firstObject];
    }
    [cell.exe_name setText: exeDatas[indexPath.row].displayName];
    [cell.publisherInformation setText:exeDatas[indexPath.row].publisher];
    [cell.versionInformation setText:exeDatas[indexPath.row].displayVersion];
    return cell;
}
//tableview delegete end
@end
