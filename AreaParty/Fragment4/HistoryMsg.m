//
//  HistoryMsg.m
//  AreaParty
//
//  Created by 杜哲凯 on 2018/4/28.
//  Copyright © 2018年 杜哲凯. All rights reserved.
//

#import "HistoryMsg.h"
#import "ChatDBManager.h"
@interface HistoryMsg (){
    NSString* user_id;
    NSString* user_name;
    NSString* user_head;
    NSString* myUserHead;
    NSMutableArray<NSMutableDictionary<NSString*,NSObject*>*>* chatData;
    UIDatePicker *datePicker;
    UIButton* setDateBtn;
    ChatDBManager* chatDB;
    NSDateFormatter *dateFormatter;
}

@end
static int FRIEND=1;
static int ME=0;
@implementation HistoryMsg

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getData];
    [self initView];
}
- (void)getData{
    user_id = (NSString*)_intentBundle[@"userId"];
    user_name = (NSString*)_intentBundle[@"userName"];
    user_head = (NSString*)_intentBundle[@"userHead"];
    myUserHead = (NSString*)_intentBundle[@"myUserHead"];
    chatData = [[NSMutableArray alloc] init];
    dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"YYYY-MM-dd HH:mm";
    chatDB = [MainTabbarController getChatDBManager];
}
- (void) initView{
    int s_width = [UIScreen mainScreen].bounds.size.width;
    int s_height = [UIScreen mainScreen].bounds.size.height;
    [_historyMsgTitle setText:[NSString stringWithFormat:@"与%@的聊天记录",user_id]];
    [_historyMsg_tip setText:@"请先选择要查询的日期"];
    _historyMsgList.delegate = self;
    _historyMsgList.dataSource = self;
    _historyMsgList.separatorStyle = NO;
    [_historyMsgList registerClass:[MKJChatTableViewCell_History class] forCellReuseIdentifier:@"MKJChatTableViewCell_History"];
    datePicker = [ [ UIDatePicker alloc] initWithFrame:CGRectMake(0,0,320,216)];
    datePicker.center = CGPointMake(s_width/2, s_height/2);
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh_CN"];
    setDateBtn = [[UIButton alloc] initWithFrame:CGRectMake(datePicker.frame.origin.x, datePicker.frame.origin.y+216, 320, 25)];
    [setDateBtn setTitleColor:[UIColor colorWithRed:52/255.0 green:175/255.0 blue:250/255.0 alpha:1] forState:UIControlStateNormal];
    setDateBtn.backgroundColor = [UIColor whiteColor];
    [setDateBtn setTitle:@"完成" forState:UIControlStateNormal];
    [setDateBtn addTarget:self action:@selector(dateSet) forControlEvents:UIControlEventTouchUpInside];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dateSet{
    NSDate *theDate = datePicker.date;
    NSLog(@"%@",[theDate descriptionWithLocale:[NSLocale currentLocale]]);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"YYYY-MM-dd HH-mm-ss";
    NSLog(@"%@",[dateFormatter stringFromDate:theDate]);
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];//设置成中国阳历
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:theDate];
    comps.hour = 0;
    comps.minute = 0;
    comps.second = 0;
    long startDate = [[calendar dateFromComponents:comps] timeIntervalSince1970]*1000;
    NSLog(@"%@",[dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:startDate/1000]]);
    comps.hour = 23;
    comps.minute = 59;
    comps.second = 59;
    long endDate = [[calendar dateFromComponents:comps] timeIntervalSince1970]*1000;
    NSLog(@"%@",[dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:endDate/1000]]);
    [chatData removeAllObjects];
    NSMutableArray<ChatObj*>* chats = [chatDB selectMyChatSQL:Login_userId MyId:Login_userId PeerId:user_id Start:startDate End:endDate];
    for(ChatObj* chat in chats){
        if([chat.sender_id isEqualToString:Login_userId] && [chat.receiver_id isEqualToString:user_id]){
            [self addTextToList:chat Who:ME];
        }else {
            [self addTextToList:chat Who:FRIEND];
        }
    }
    [_historyMsg_tip setText:@"没有找到当日的聊天记录"];
    [datePicker removeFromSuperview];
    [setDateBtn removeFromSuperview];
    [_historyMsgList reloadData];
}
- (void) addTextToList:(ChatObj*) chat Who:(int) who{
    NSString* text = chat.msg;
    long time = chat.date;
    NSMutableDictionary<NSString*,NSObject*>* map= [[NSMutableDictionary alloc] init];
    map[@"person"] = [NSNumber numberWithInt:who];
    map[@"userHead"] =  (who == ME? myUserHead:user_head);
    map[@"text"] =  text;
    map[@"msgTime"] =  [NSNumber numberWithLong:time];
    [chatData addObject:map];
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
- (IBAction)Press_selectDate:(id)sender {
    [self.view addSubview:datePicker];
    [self.view addSubview:setDateBtn];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(chatData.count == 0)
        _historyMsg_tip.hidden = NO;
    else
        _historyMsg_tip.hidden =YES;
    
    return chatData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MKJChatTableViewCell_History *cell = [tableView dequeueReusableCellWithIdentifier:@"MKJChatTableViewCell_History"];
    MKJChatModel * model = [[MKJChatModel alloc] init];
    model.msg = (NSString*)chatData[indexPath.row][@"text"];
    NSNumber* b = (NSNumber*)chatData[indexPath.row][@"person"];
    model.isRight = [b intValue]==ME?YES:NO;
    [cell refreshCell:model];
    [cell.headImageView setImage:[UIImage imageNamed:(NSString*)chatData[indexPath.row][@"userHead"]]];
    [cell.timeLabel setText:[dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[(NSString*)chatData[indexPath.row][@"msgTime"] longLongValue]/1000]]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* msg= (NSString*)chatData[indexPath.row][@"text"];
    CGRect rec =  [msg boundingRectWithSize:CGSizeMake(200, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17]} context:nil];
    return rec.size.height + 45 +25;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_historyMsgList deselectRowAtIndexPath:indexPath animated:YES];
}
@end
