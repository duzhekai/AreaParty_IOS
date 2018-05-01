//
//  sortFIleList.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/4/27.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "sortFIleList.h"
#import "fileObj.h"
#import "myList.h"
#import "tab06_fileitem.h"
#import "SendChatMsg.pbobjc.h"
#import "LoginViewController.h"
#import "ChatData.pbobjc.h"
@interface sortFIleList (){
    NSMutableArray<NSMutableDictionary<NSString*, NSObject*>*>* fileData;
    NSString* user_id;
    fileObj* agreeFileMsg;
    int fileStyle;
}

@end

@implementation sortFIleList

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getData];
    [self initView];
}
- (void) getData{
    myList* temp = (myList*)_intentBundle[@"fileData"];
    fileData = temp.list1;
    user_id = _intentBundle[@"userId"];
    fileStyle = [_intentBundle[@"fileStyle"] intValue];
}
- (void) initView{
    switch (fileStyle){
        case 0:
            [_sortFileListTitle setText:@"音频"];
            break;
        case 1:
            [_sortFileListTitle setText:@"视频"];
            break;
        case 2:
            [_sortFileListTitle setText:@"压缩包"];
            break;
        case 3:
            [_sortFileListTitle setText:@"图片"];
            break;
        case 4:
            [_sortFileListTitle setText:@"文档"];
            break;
        case 5:
            [_sortFileListTitle setText:@"其他"];
            break;
    }
    _fileListView.delegate = self;
    _fileListView.dataSource = self;
    _fileListView.separatorStyle = NO;
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

- (IBAction)Press_back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
//tableview delegete start
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return fileData.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseIdentifier = @"tab06_fileitem";
    
    tab06_fileitem* cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    //如果缓存池中没有,那么创建一个新的cell
    if (!cell) {
        //这里换成自己定义的cell,并调用类方法加载xib文件
        cell = [[[NSBundle mainBundle] loadNibNamed:@"tab06_fileitem" owner:nil options:nil] firstObject];
    }
    NSMutableDictionary<NSString*, NSObject*>* file = fileData[indexPath.row];
    
    NSString* fileName =  (NSString*) file[@"fileName"];
    long fileDate = [(NSString*)file[@"fileDate"] longLongValue];
    NSDateFormatter* sdf = [[NSDateFormatter alloc] init];
    [sdf setDateFormat:@"yyyy年MM月dd日 HH:mm:ss"];
    NSString* sDateTime = [sdf stringFromDate:[[NSDate alloc] initWithTimeIntervalSince1970:(fileDate/1000)]];
    
    NSString* fileSize = [self getSize:[(NSString*)file[@"fileSize"] intValue]];
    NSString* fileInfo = [NSString stringWithFormat:@"%@ %@",sDateTime,fileSize];
    [cell.fileImg setImage:[UIImage imageNamed:(NSString*)file[@"fileImg"]]];
    [cell.fileName setText:fileName];
    cell.i = indexPath;
    cell.holder = self;
    if([fileInfo isEqualToString:@""])
        [cell.fileInfo setText:@"该用户什么都没写"];
    else
        [cell.fileInfo setText:fileInfo];
    cell.file_download_btn.hidden = NO;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString* fileInfo = [NSString stringWithFormat:@"文件名： %@\n文件大小： %@\n文件描述： %@",fileData[indexPath.row][@"fileName"],[self getSize:[(NSString*)fileData[indexPath.row][@"fileSize"] intValue]],fileData[indexPath.row][@"fileInfo"]];
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"文件信息"
                                                                   message:fileInfo
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              //响应事件
                                                              NSLog(@"action = %@", action);
                                                          }];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}
//tableview delegete end
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

- (void) Press_DownLoad:(NSIndexPath*) i{
    tab06_fileitem* cell = [_fileListView cellForRowAtIndexPath:i];
    NSMutableDictionary<NSString*, NSObject*>* file = fileData[i.row];
    
    NSString* file_name =  (NSString*) file[@"fileName"];
    NSString* file_date =(NSString*)file[@"fileDate"];
    NSString* file_size = (NSString*)file[@"fileSize"];
    [NSThread detachNewThreadWithBlock:^{
        @try{
            SendChatReq* builder = [[SendChatReq alloc] init];
            ChatItem* chatItem = [[ChatItem alloc] init];
            chatItem.targetType = ChatItem_TargetType_Download;
            chatItem.sendUserId = Login_userId;
            chatItem.receiveUserId = user_id;
            chatItem.fileName = file_name;
            chatItem.fileDate = file_date;
            chatItem.fileSize = file_size;
            chatItem.chatType = ChatItem_ChatType_Text;
            chatItem.chatBody = @"";
            builder.chatData = chatItem;
            NSData* byteArray = [NetworkPacket packMessage:ENetworkMessage_SendChatReq packetBytes:[builder data]];
            [Login_base writeToServer:Login_base.outputStream arrayBytes:byteArray];
            dispatch_async(dispatch_get_main_queue(), ^{
                [Toast ShowToast:@"下载请求已发送，待对方同意" Animated:YES time:1 context:self.view];
            });
        }@catch (NSException* e){
            
        }@catch (NSException* e){
            
        }
    }];
    [cell.file_download_btn setTitle:@"已请求" forState:UIControlStateNormal];
    [cell.file_download_btn setUserInteractionEnabled:NO];
    [cell.file_download_btn setBackgroundColor:[UIColor colorWithRed:168/255.0 green:168/255.0 blue:168/255.0 alpha:1]];
}
@end
