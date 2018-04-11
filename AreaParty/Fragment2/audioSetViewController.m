//
//  audioSetViewController.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/3/29.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "audioSetViewController.h"
#import "AVLoadingIndicatorView.h"
@interface audioSetViewController (){
    NSMutableArray<MediaSetBean*>* setList;
    NSMutableArray<MediaSetBean*>* setList_app;
    UITapGestureRecognizer* pc_file_tap;
    UITapGestureRecognizer* app_file_tap;
    NSMutableArray<UIImage*>* thumbnails;
    NSString* newSetName;
    AVLoadingIndicatorView* loadingDialog;
    int setToDeleteId;
}

@end

@implementation audioSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    [self initView];
    if ( _isAppContent || !([MyUIApplication getselectedPCVerified] && [MyUIApplication getselectedPCOnline])){
        _isAppContent = YES;
        [_app_file_TV setTextColor:[UIColor colorWithRed:1 green:80/255.0 blue:80/255.0 alpha:1]];
        [_app_file setBackgroundColor:[UIColor colorWithRed:230/255.0 green:87/255.0  blue:87/255.0  alpha:0.17]];
        [_pc_file setBackgroundColor:[UIColor whiteColor]];
        [_pc_file_TV setTextColor:[UIColor colorWithRed:112/255.0 green:112/255.0 blue:112/255.0 alpha:1]];
        [_fileSGV reloadData];
    }
}
- (void) initData{
    setToDeleteId = -1;
    setList = [[NSMutableArray alloc] init];
    setList_app = [[NSMutableArray alloc] init];
    pc_file_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ontapped:)];
    app_file_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ontapped:)];
    thumbnails = [[NSMutableArray alloc] init];
    [thumbnails addObject:[UIImage imageNamed:@"music1.jpg"]];
    [thumbnails addObject:[UIImage imageNamed:@"music2.jpg"]];
    [thumbnails addObject:[UIImage imageNamed:@"music3.jpg"]];
    [thumbnails addObject:[UIImage imageNamed:@"music4.jpg"]];
    [thumbnails addObject:[UIImage imageNamed:@"music5.jpg"]];
    [thumbnails addObject:[UIImage imageNamed:@"music6.jpg"]];
    [thumbnails addObject:[UIImage imageNamed:@"music7.jpg"]];
    [thumbnails addObject:[UIImage imageNamed:@"music8.jpg"]];
    [thumbnails addObject:[UIImage imageNamed:@"music9.jpg"]];
    [thumbnails addObject:[UIImage imageNamed:@"music10.jpg"]];
    if([MediafileHelper getaudioSets].count <= 0)
        [MediafileHelper loadMediaSets:self] ;
    else {
        [[MediafileHelper getaudioSets] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            MediaSetBean* tempbean = [[MediaSetBean alloc] init];
            tempbean.name = (NSString*)key;
            NSArray * array =(NSArray*) obj;
            tempbean.thumbnailID = arc4random() % 10;
            tempbean.numInfor = [NSString stringWithFormat:@"%lu首",(unsigned long)array.count];
            [setList addObject:tempbean];
        }];
    }
    [setList_app addObjectsFromArray:[LocalSetListContainer getLocalSetList:@"audio"]];
}
- (void) initView{
    _shiftBar.layer.borderColor = [UIColor colorWithRed:230/255.0 green:87/255.0 blue:87/255.0 alpha:1].CGColor;
    _pc_file.layer.borderColor = [UIColor colorWithRed:230/255.0 green:87/255.0 blue:87/255.0 alpha:1].CGColor;
    _app_file.layer.borderColor = [UIColor colorWithRed:230/255.0 green:87/255.0 blue:87/255.0 alpha:1].CGColor;
    [_pc_file setBackgroundColor:[UIColor colorWithRed:230/255.0 green:87/255.0  blue:87/255.0  alpha:0.17]];
    [_app_file addGestureRecognizer:app_file_tap];
    [_pc_file addGestureRecognizer:pc_file_tap];
    _fileSGV.delegate = self;
    _fileSGV.dataSource = self;
    _fileSGV.separatorStyle = NO;
    loadingDialog = [[AVLoadingIndicatorView alloc] initWithFrame:self.view.frame];
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
            if (!_isAppContent){
                if([self isSetContained:tempName]) {
                    [Toast ShowToast:@"当前列表名称已存在" Animated:YES time:1 context:self.view];
                } else {
                    newSetName = tempName;
                    [loadingDialog showPromptViewOnView:self.view];
                    [MediafileHelper addAudioPlaySet:tempName Handler:self];
                }
            }else {
                if( [self isSetContained_app:tempName]) {
                    [Toast ShowToast:@"当前列表名称已存在" Animated:YES time:1 context:self.view];
                } else {
                    if( [self isSetContained_app:tempName]) {
                        [Toast ShowToast:@"当前列表名称已存在" Animated:YES time:1 context:self.view];
                    } else {
                        [LocalSetListContainer addLocalSetList:@"audio" setName:tempName];
                        [setList_app removeAllObjects];
                        [setList_app addObjectsFromArray:[LocalSetListContainer getLocalSetList:@"audio"]];
                        [_fileSGV reloadData];
                        [Toast ShowToast:@"添加新的音频列表成功" Animated:YES time:1 context:self.view];
                        
                    }
                }
            }
            }}
    ];
    [_addSetDialog addAction:action];
    [_addSetDialog addAction:action1];
    [_addSetDialog addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入新增列表名称";
    }];
}
- (void) ontapped:(UITapGestureRecognizer*) gesture{
    if(gesture.view == _app_file){
        _isAppContent = true;
        [_app_file_TV setTextColor:[UIColor colorWithRed:1 green:80/255.0 blue:80/255.0 alpha:1]];
        [_app_file setBackgroundColor:[UIColor colorWithRed:230/255.0 green:87/255.0  blue:87/255.0  alpha:0.17]];
        [_pc_file_TV setTextColor:[UIColor colorWithRed:112/255.0 green:112/255.0 blue:112/255.0 alpha:1]];
        [_pc_file setBackgroundColor:[UIColor whiteColor]];
        [_fileSGV reloadData];
    }
    else if(gesture.view == _pc_file){
        if (!([MyUIApplication getselectedPCVerified] && [MyUIApplication getselectedPCOnline])){
            [Toast ShowToast:@"当前电脑不在线" Animated:YES time:1 context:self.view];
        }else {
            _isAppContent = NO;
            [_pc_file_TV setTextColor:[UIColor colorWithRed:1 green:80/255.0 blue:80/255.0 alpha:1]];
            [_pc_file setBackgroundColor:[UIColor colorWithRed:230/255.0 green:87/255.0  blue:87/255.0  alpha:0.17]];
            [_app_file_TV setTextColor:[UIColor colorWithRed:112/255.0 green:112/255.0 blue:112/255.0 alpha:1]];
            [_app_file setBackgroundColor:[UIColor whiteColor]];
            [_fileSGV reloadData];
        }
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

- (IBAction)press_return:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (BOOL) isSetContained:(NSString*)name {
    for(int i = 0; i < setList.count; ++i)
        if([setList[i].name isEqualToString:name])
            return YES;
    return NO;
}
- (BOOL) isSetContained_app:(NSString*)name{
    for(int i = 0; i < setList_app.count; ++i)
        if([setList_app[i].name isEqualToString:name])
            return YES;
    return NO;
}
- (void)onHandler:(NSDictionary *)message{
    switch ([[message objectForKey:@"what"] intValue]) {
        case 0x209:{//OrderConst.getPCAudioSets_OK:
            [[MediafileHelper getaudioSets] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                MediaSetBean* tempbean = [[MediaSetBean alloc] init];
                tempbean.name = (NSString*)key;
                NSArray * array =(NSArray*) obj;
                tempbean.numInfor = [NSString stringWithFormat:@"%lu首",(unsigned long)array.count];
                [setList addObject:tempbean];
            }];
            [_fileSGV reloadData];
            break;
        }
        case 0x210:{//OrderConst.getPCAudioSets_Fail:
        }
            break;
        case 0x213:{//OrderConst.addPCSet_OK:
            if(![newSetName isEqualToString:@""]) {
                MediaSetBean* file = [[MediaSetBean alloc] init];
                file.name = newSetName;
                file.thumbnailID = arc4random() % 10;
                file.numInfor = @"0首";
                [setList insertObject:file atIndex:0];
                [[MediafileHelper getaudioSets] setObject:[[NSMutableArray alloc] init] forKey:newSetName];
            }
            [_fileSGV reloadData];
            [loadingDialog removeView];
            [Toast ShowToast:@"添加新的音频列表成功" Animated:YES time:1 context:self.view];
            break;
        }
        case 0x214:{//OrderConst.addPCSet_Fail:{
            newSetName = @"";
            [loadingDialog removeView];
            [Toast ShowToast:@"添加新的音频列表失败" Animated:YES time:1 context:self.view];
            break;
        }
        case 0x217:{    //OrderConst.deletePCSet_OK:
            if(setToDeleteId >= 0) {
                [[MediafileHelper getaudioSets] removeObjectForKey:setList[setToDeleteId].name];
                [setList removeObjectAtIndex:setToDeleteId];
                [_fileSGV deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:setToDeleteId inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            }
            [loadingDialog removeView];
            [Toast ShowToast:@"删除指定列表成功" Animated:YES time:1 context:self.view];
            break;
        }
        case 0x218:{//OrderConst.deletePCSet_Fail:
            [loadingDialog removeView];
            [Toast ShowToast:@"删除指定列表失败" Animated:YES time:1 context:self.view];
            break;
        }
    }
}
- (IBAction)press_add_set:(id)sender {
    if (!_isAppContent){
        if([MyUIApplication getselectedPCOnline]) {
            [self presentViewController:_addSetDialog animated:YES completion:nil];
        } else [Toast ShowToast:@"当前电脑不在线" Animated:YES time:1 context:self.view];
    }else {
        [self presentViewController:_addSetDialog animated:YES completion:nil];
    }
}
//tableview delegete start
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(!_isAppContent){
        return setList.count;
    }
    else{
        return setList_app.count;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseIdentifier = @"tab02_audioset_item";
    tab02_audioset_item* cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    //如果缓存池中没有,那么创建一个新的cell
    if (!cell) {
        //这里换成自己定义的cell,并调用类方法加载xib文件
        cell = [[[NSBundle mainBundle] loadNibNamed:@"tab02_audioset_item" owner:nil options:nil] firstObject];
    }
    if(!_isAppContent){
        [cell.nameTV setText:setList[indexPath.row].name];
        [cell.numTV setText: setList[indexPath.row].numInfor];
        [cell.thumbnailIV setImage:thumbnails[setList[indexPath.row].thumbnailID]];
        cell.perform_obj = self;
        cell.index = [NSNumber numberWithInteger:indexPath.row];
        return cell;
    }
    else{
        [cell.nameTV setText:setList_app[indexPath.row].name];
        [cell.numTV setText: setList_app[indexPath.row].numInfor];
        [cell.thumbnailIV setImage:thumbnails[setList_app[indexPath.row].thumbnailID]];
        cell.perform_obj = self;
        cell.index = [NSNumber numberWithInteger:indexPath.row];
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!_isAppContent){
        audioSetContentViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"audioSetContentViewController"];
        vc.isAppContent = NO;
        vc.setName = setList[indexPath.row].name;
        [self presentViewController:vc animated:YES completion:nil];
    }else {
        audioSetContentViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"audioSetContentViewController"];
        vc.isAppContent = YES;
        vc.setName = setList_app[indexPath.row].name;
        [self presentViewController:vc animated:YES completion:nil];
    }
}
//tableview delegete end

- (void) deleteItemOn:(NSNumber*) index{
    int i = [index intValue];
    if(!_isAppContent){
        [loadingDialog showPromptViewOnView:self.view];
        [MediafileHelper deleteAudioPlaySet:setList[i].name Handler:self];
        setToDeleteId = i;
    }else {
        [LocalSetListContainer deleteLocalSetList:@"audio" setName:setList_app[i].name];
        [setList_app removeAllObjects];
        [setList_app addObjectsFromArray:[LocalSetListContainer getLocalSetList:@"audio"]];
        [_fileSGV reloadData];
        [Toast ShowToast:@"删除指定列表成功" Animated:YES time:1 context:self.view];
    }
}
@end
