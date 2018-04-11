//
//  listBottomDialog_app.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/4/9.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "listBottomDialog_app.h"
#import "LocalSetListContainer.h"
#import "MediafileHelper.h"
#import "OrderConst.h"
#import "tab02_listdialog_item.h"
#import "Toast.h"
@interface listBottomDialog_app (){
    NSMutableDictionary<NSString*,NSMutableArray<FileItemForMedia*>*>* localMapList;
}

@end

@implementation listBottomDialog_app

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _fileSGV.delegate = self;
    _fileSGV.dataSource = self;
    _fileSGV.separatorStyle = NO;
    if([_MediaType isEqualToString:@"audio"]){
        [_typeNameTV setText:@"音频:"];
        localMapList = [LocalSetListContainer getlocalMapList_audio];
    }
    else{
        [_typeNameTV setText:@"图片:"];
        localMapList = [LocalSetListContainer getlocalMapList_image];
    }
    NSString* filenames = @"";
    for(FileItemForMedia* item in _currentFileList){
        filenames = [filenames stringByAppendingString:[NSString stringWithFormat:@"%@,",item.mFileName]];
    }
    [_nameTV setText:filenames];
    [self initDialog];
    _setlist = [LocalSetListContainer getLocalSetList:_MediaType];
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
                MediaSetBean* file = [[MediaSetBean alloc] init];
                file.name = tempName;
                file.numInfor =@"0首";
                [_setlist insertObject:file atIndex:0];
                [_fileSGV reloadData];
                [LocalSetListContainer addLocalSetList:_MediaType setName:tempName];
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
- (NSMutableArray<FileItemForMedia *> *)currentFileList{
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
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.setlist.count;
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
    NSString* key = self.setlist[indexPath.row].name;
    NSMutableArray<FileItemForMedia*>* savedList = [localMapList objectForKey:key];
    if (savedList!=nil){
        for (FileItemForMedia* f1 in _currentFileList){
            for (FileItemForMedia* f2 in savedList){
                if ([f1.mFilePath isEqualToString:f2.mFilePath])
                    [_currentFileList removeObject:f1];
            }
        }
    }else {
        savedList = [[NSMutableArray alloc] init];
    }
    if (_currentFileList.count > 0){
        [savedList addObjectsFromArray:_currentFileList];
        [localMapList setObject:savedList forKey:key];
        //Log.w("listBottomDialog_app",value);
        [[[PreferenceUtil alloc] init] writeKey:[NSString stringWithFormat:@"local_set_%@",_MediaType] Value:[localMapList yy_modelToJSONString]];
        [LocalSetListContainer SyncData];
    }
    [self dismissViewControllerAnimated:YES completion:^(void){
        [Toast ShowToast:@"添加成功" Animated:YES time:1 context:_pushvc.view];
    }];
    return ;
}
//tableview delegete end
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self.view];
    if((touchPoint.x > _containerView.frame.origin.x) && (touchPoint.x < _containerView.frame.origin.x+_containerView.frame.size.width) && (touchPoint.y > _containerView.frame.origin.y) && (touchPoint.y < _containerView.frame.origin.y+_containerView.frame.size.height)){
        
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
