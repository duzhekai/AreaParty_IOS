//
//  tab02_listdialog.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/3/28.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "tab02_listdialog.h"
#import "MediafileHelper.h"
#import "OrderConst.h"
#import "tab02_listdialog_item.h"
#import "Toast.h"
@interface tab02_listdialog ()

@end

@implementation tab02_listdialog

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _fileSGV.delegate = self;
    _fileSGV.dataSource = self;
    _fileSGV.separatorStyle = NO;
    if([_MediaType isEqualToString:OrderConst_audioAction_name]){
        [_typeNameTV setText:@"音频:"];
    }
    else
        [_typeNameTV setText:@"图片:"];
    NSString* filenames = @"";
    for(MediaItem* item in _currentFileList){
        filenames = [filenames stringByAppendingString:[NSString stringWithFormat:@"%@,",item.name]];
    }
    [_nameTV setText:filenames];
    [self initDialog];
}
- (void) initDialog{
    _addSetDialog = [UIAlertController alertControllerWithTitle:@"新建列表" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击了取消");
    }];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"保存" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSString* tempName = _addSetDialog.textFields.lastObject.text;
        if([tempName isEqualToString:@""] || [tempName characterAtIndex:tempName.length-1]=='.' ||
           [tempName containsString:@"\\"] || [tempName containsString:@"/"] ||
           [tempName containsString:@":"]  || [tempName containsString:@"*"] ||
           [tempName containsString:@"?"]  || [tempName containsString:@"\""] ||
           [tempName containsString:@"<"]  || [tempName containsString:@">"] ||
           [tempName containsString:@"|"]){
            [Toast ShowToast:@"列表名不能为空，不能包含\\ / : * ? \" < > |字符" Animated:YES time:1 context:self.view];
        } else {
            if([self isSetContained:tempName]) {
                [Toast ShowToast:@"当前列表名称已存在" Animated:YES time:1 context:self.view];
            } else {
                if([[MediafileHelper getMediaType] isEqualToString:OrderConst_audioAction_name]){
                    [MediafileHelper addAudioPlaySet:tempName Handler:self];
                    MediaSetBean* file = [[MediaSetBean alloc] init];
                    file.name = tempName;
                    file.numInfor = @"0首";
                    [_setlist insertObject:file atIndex:0];
                    [[MediafileHelper getaudioSets] setObject:[[NSMutableArray alloc] init] forKey:tempName];
                    [_fileSGV reloadData];
                } else {
                    [MediafileHelper addImagePlaySet:tempName Handler:self];
                    MediaSetBean* file = [[MediaSetBean alloc] init];
                    file.name = tempName;
                    file.numInfor = @"0张";
                    [_setlist insertObject:file atIndex:0];
                    [[MediafileHelper getimageSets] setObject:[[NSMutableArray alloc] init] forKey:tempName];
                    [_fileSGV reloadData];
                }
        NSLog(@"点击了确定");
            }}
    }];
    [_addSetDialog addAction:action];
    [_addSetDialog addAction:action1];
    [_addSetDialog addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入新增列表名称";
    }];
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

- (IBAction)press_new_list:(id)sender {
    [self presentViewController:_addSetDialog animated:YES completion:nil];
}

- (NSMutableArray<MediaItem *> *)currentFileList{
    if(_currentFileList == nil){
        _currentFileList = [[NSMutableArray alloc] init];
    }
    return _currentFileList;
}
- (NSMutableArray<MediaSetBean *> *)setlist{
    if(_setlist == nil){
        _setlist = [[NSMutableArray alloc] init];
    }
    return _setlist;
}
//tableview delegete start
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if([_MediaType isEqualToString:OrderConst_audioAction_name]){
        [self.setlist removeAllObjects];
        [[MediafileHelper getaudioSets] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            MediaSetBean* tempbean = [[MediaSetBean alloc] init];
            tempbean.name = (NSString*)key;
            NSArray * array =(NSArray*) obj;
            tempbean.numInfor = [NSString stringWithFormat:@"%lu首",(unsigned long)array.count];
            [self.setlist addObject:tempbean];
        }];
    }
    else{
        [self.setlist removeAllObjects];
        [[MediafileHelper getimageSets] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            MediaSetBean* tempbean = [[MediaSetBean alloc] init];
            tempbean.name = (NSString*)key;
            NSArray * array =(NSArray*) obj;
            tempbean.numInfor = [NSString stringWithFormat:@"%lu张",(unsigned long)array.count];
            [self.setlist addObject:tempbean];
        }];
    }
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if([_MediaType isEqualToString:OrderConst_audioAction_name]){
        return [MediafileHelper getaudioSets].count;
    }
    else{
        return [MediafileHelper getimageSets].count;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([_MediaType isEqualToString:OrderConst_audioAction_name]){
        static NSString *reuseIdentifier = @"tab02_listdialog_item";
        tab02_listdialog_item* cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        //如果缓存池中没有,那么创建一个新的cell
        if (!cell) {
            //这里换成自己定义的cell,并调用类方法加载xib文件
            cell = [[[NSBundle mainBundle] loadNibNamed:@"tab02_listdialog_item" owner:nil options:nil] firstObject];
        }
        [cell.nameTV setText:self.setlist[indexPath.row].name];
        [cell.thumbnailIV setImage:[UIImage imageNamed:@"logo_audioset.png"]];
        [cell.numTV setText:self.setlist[indexPath.row].numInfor];
        return cell;

    }
    else{
        static NSString *reuseIdentifier = @"tab02_listdialog_item";
        tab02_listdialog_item* cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        //如果缓存池中没有,那么创建一个新的cell
        if (!cell) {
            //这里换成自己定义的cell,并调用类方法加载xib文件
            cell = [[[NSBundle mainBundle] loadNibNamed:@"tab02_listdialog_item" owner:nil options:nil] firstObject];
        }
        [cell.nameTV setText:self.setlist[indexPath.row].name];
        [cell.thumbnailIV setImage:[UIImage imageNamed:@"logo_imageset.png"]];
        [cell.numTV setText:self.setlist[indexPath.row].numInfor];
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if([MyUIApplication getselectedPCOnline]) {
        for (MediaItem* item in _currentFileList){
            NSMutableArray<MediaItem*>* files = [[NSMutableArray alloc] init];
            [files addObject:item];
            [MediafileHelper addFilesToSet:_setlist[indexPath.row].name List:files handler:self];
        }
        [MediafileHelper addFileToLocalSet:_setlist[indexPath.row].name List:_currentFileList];
        [self dismissViewControllerAnimated:YES completion:^(void){
            [Toast ShowToast:@"添加成功" Animated:YES time:1 context:_pushvc.view];
        }];
    } else {
        [self dismissViewControllerAnimated:YES completion:^(void){
            [Toast ShowToast:@"当前电脑不在线" Animated:YES time:1 context:_pushvc.view];
        }];
    }
        return ;
}
//tableview delegete end
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self.view];
    if((touchPoint.x > __containerView.frame.origin.x) && (touchPoint.x < __containerView.frame.origin.x+__containerView.frame.size.width) && (touchPoint.y > __containerView.frame.origin.y) && (touchPoint.y < __containerView.frame.origin.y+__containerView.frame.size.height)){
        
    }
    else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
- (void)onHandler:(NSDictionary *)message{
    
}
- (BOOL)isSetContained:(NSString*) name{
    for(int i = 0; i < _setlist.count; ++i)
        if([_setlist[i].name isEqualToString:name])
            return YES;
    return NO;
}
@end
