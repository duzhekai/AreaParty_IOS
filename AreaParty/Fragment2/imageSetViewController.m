//
//  imageSetViewController.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/3/31.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "imageSetViewController.h"
#import "MyUIApplication.h"
#import "MediafileHelper.h"
#import "MediaSetBean.h"
#import "AVLoadingIndicatorView.h"
#import "imageSetContentViewController.h"
#import "Toast.h"
@interface imageSetViewController (){
    NSMutableArray<MediaSetBean*>* setList;
    NSMutableArray<MediaSetBean*>* setList_app;
    UITapGestureRecognizer* pc_file_tap;
    UITapGestureRecognizer* app_file_tap;
    NSString* newSetName;
    AVLoadingIndicatorView* loadingDialog;
    int setToDeleteId;
}

@end

@implementation imageSetViewController

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
    if([MediafileHelper getaudioSets].count <= 0)
        [MediafileHelper loadMediaSets:self] ;
    else {
        [[MediafileHelper getimageSets] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            MediaSetBean* tempbean = [[MediaSetBean alloc] init];
            tempbean.name = (NSString*)key;
            NSMutableArray<MediaItem*> * array =(NSMutableArray<MediaItem*>*) obj;
            if(array.count > 0)
                tempbean.thumbnailURL = [array objectAtIndex:0].thumbnailurl;
            tempbean.numInfor = [NSString stringWithFormat:@"%lu张",(unsigned long)array.count];
            [setList addObject:tempbean];
        }];
    }
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
    _addSetDialog = [UIAlertController alertControllerWithTitle:@"新建图片列表" message:@"" preferredStyle:UIAlertControllerStyleAlert];
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
                    [MediafileHelper addImagePlaySet:tempName Handler:self];
                }
            }else {
                if( [self isSetContained_app:tempName]) {
                    [Toast ShowToast:@"当前列表名称已存在" Animated:YES time:1 context:self.view];
                } else {
                    //                    LocalSetListContainer.addLocalSetList("audio",tempName);
                    //                    setList_app.clear();
                    //                    setList_app.addAll(LocalSetListContainer.getLocalSetList("audio"));
                    //                    fileAdapter.notifyDataSetChanged();
                    //                    dialog.dismiss();
                    //                    Toasty.success(audioSetActivity.this, "添加新的音频列表成功", Toast.LENGTH_SHORT, true).show();
                    
                }
            }
        }}
                              ];
    [_addSetDialog addAction:action];
    [_addSetDialog addAction:action1];
    [_addSetDialog addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入图片列表名称";
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
- (IBAction)press_return_btn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
- (void)onHandler:(NSDictionary *)message{
    switch ([[message objectForKey:@"what"] intValue]) {
        case 0x211:{//OrderConst.getPCImageSets_OK
            [[MediafileHelper getimageSets] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                MediaSetBean* tempbean = [[MediaSetBean alloc] init];
                tempbean.name = (NSString*)key;
                NSMutableArray<MediaItem*> * array =(NSMutableArray<MediaItem*>*) obj;
                if(array.count>0)
                    tempbean.thumbnailURL = array[0].thumbnailurl;
                tempbean.numInfor = [NSString stringWithFormat:@"%lu张",(unsigned long)array.count];
                [setList addObject:tempbean];
            }];
            [_fileSGV reloadData];
            break;
        }
        case 0x212:{//OrderConst.getPCImageSets_Fail:
        }
            break;
        case 0x213:{//OrderConst.addPCSet_OK:
            if(![newSetName isEqualToString:@""]) {
                MediaSetBean* file = [[MediaSetBean alloc] init];
                file.name = newSetName;
                file.numInfor = @"0张";
                [setList insertObject:file atIndex:0];
                [[MediafileHelper getimageSets] setObject:[[NSMutableArray alloc] init] forKey:newSetName];
            }
            [_fileSGV reloadData];
            [loadingDialog removeView];
            [Toast ShowToast:@"添加新的图片列表成功" Animated:YES time:1 context:self.view];
            break;
        }
        case 0x214:{//OrderConst.addPCSet_Fail:{
            newSetName = @"";
            [loadingDialog removeView];
            [Toast ShowToast:@"添加新的图片列表失败" Animated:YES time:1 context:self.view];
            break;
        }
        case 0x217:{    //OrderConst.deletePCSet_OK:
            if(setToDeleteId >= 0) {
                [[MediafileHelper getimageSets] removeObjectForKey:setList[setToDeleteId].name];
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
    return 80;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(!_isAppContent){
        static NSString *reuseIdentifier = @"tab02_imageset_item";
        tab02_imageset_item* cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        //如果缓存池中没有,那么创建一个新的cell
        if (!cell) {
            //这里换成自己定义的cell,并调用类方法加载xib文件
            cell = [[[NSBundle mainBundle] loadNibNamed:@"tab02_imageset_item" owner:nil options:nil] firstObject];
        }
        [cell.nameTV setText:setList[indexPath.row].name];
        [cell.numTV setText: setList[indexPath.row].numInfor];
        [cell.thumbnailIV sd_setImageWithURL:[NSURL URLWithString:setList[indexPath.row].thumbnailURL] placeholderImage:[UIImage imageNamed:@"logo_empty.png"]];
        cell.perform_obj = self;
        cell.index = [NSNumber numberWithInteger:indexPath.row];
        return cell;
    }
    else
        return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!_isAppContent){
        imageSetContentViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"imageSetContentViewController"];
        vc.isAppContent = NO;
        vc.setName = setList[indexPath.row].name;
        [self presentViewController:vc animated:YES completion:nil];
    }else {
        //        Intent intent = new Intent(audioSetActivity.this, audioSetContentActivity.class);
        //        intent.putExtra("isAppContent",true);
        //        intent.putExtra("setName", setList_app.get(i).name);
        //        startActivity(intent);
    }
}
//tableview delegete end

- (void) deleteItemOn:(NSNumber*) index{
    int i = [index intValue];
    if(!_isAppContent){
        [loadingDialog showPromptViewOnView:self.view];
        [MediafileHelper deleteImagePlaySet:setList[i].name Handler:self];
        setToDeleteId = i;
    }else {
        //        LocalSetListContainer.deleteLocalSetList("audio",setList_app.get(i).name);
        //        setList_app.clear();
        //        setList_app.addAll(LocalSetListContainer.getLocalSetList("audio"));
        //        fileAdapter.notifyDataSetChanged();
        //        Toasty.success(audioSetActivity.this, "删除指定列表成功", Toast.LENGTH_SHORT, true).show();
    }
}
@end
