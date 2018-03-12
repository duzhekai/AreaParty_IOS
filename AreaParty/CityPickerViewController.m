//
//  CityPickerViewController.m
//  AreaParty
//
//  Created by 杜哲凯 on 2017/12/7.
//  Copyright © 2017年 杜哲凯. All rights reserved.
//

#import "CityPickerViewController.h"

@interface CityPickerViewController (){
    NSString* selectCity;
    NSString* selectProvince;
}

@end

@implementation CityPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _citypickerview.delegate = self;
    _citypickerview.dataSource = self;
    
}

//懒加载
- (NSMutableDictionary *)provinceDic{
    if(!_provinceDic){
        _provinceDic = [[NSMutableDictionary alloc] init];
        [self parseXMLandFillDic];
    }
    return _provinceDic;
}

- (NSArray *)provincenames{
    if(!_provincenames){
        _provincenames = [self.provinceDic allKeys];
    }
    return _provincenames;
}

- (IBAction)press_btn_ok:(UIButton *)sender {
    NSString* address = [selectProvince stringByAppendingString:[NSString stringWithFormat:@"-%@",selectCity]];
    NSInteger index = [self.citypickerview selectedRowInComponent:2];
    NSString* selectDistrict = self.provinceDic[selectProvince][selectCity][index];
    NSString* final = [address stringByAppendingString:[NSString stringWithFormat:@"-%@",selectDistrict]];
    [self.fathervc onUIControllerResultWithCode:0 andData:[NSDictionary dictionaryWithObject:final forKey:@"address"]];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)Press_btn_cancel:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)parseXMLandFillDic{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"province_data" ofType:@"xml"];
    NSData *data = [[NSData alloc]initWithContentsOfFile:path];
    //对象初始化
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:data options:0 error:nil];
    //获取根节点
    GDataXMLElement *rootElement = [doc rootElement];
    //获取其他节点
    NSArray *provinces = [rootElement elementsForName:@"province"];
    for (GDataXMLElement *province in provinces) {
        NSMutableDictionary* one_province = [[NSMutableDictionary alloc] init];
        NSArray* citys = [province elementsForName:@"city"];
        for(GDataXMLElement *city in citys){
            NSMutableArray* temp_distri = [[NSMutableArray alloc] init];
            NSArray* districts = [city elementsForName:@"district"];
            for(GDataXMLElement *district in districts){
                [temp_distri addObject:(NSString*)[[district attributeForName:@"name"]stringValue]];
            }
            [one_province setValue:temp_distri forKey:(NSString*)[[city attributeForName:@"name"]stringValue]];
        }
        [_provinceDic setValue:one_province forKey:(NSString*)[[province attributeForName:@"name"]stringValue]];
    }
}
//代理方法
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if(component == 0){
        return self.provincenames.count;
    }
    else if(component == 1){
        [self updateSelect:pickerView];
        NSDictionary* temp = self.provinceDic[selectProvince];
        return [temp allKeys].count;
    }
    else{
        [self updateSelect:pickerView];
        NSArray* array = self.provinceDic[selectProvince][selectCity];
        return array.count;
    }
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if(component ==0){
        return self.provincenames[row];
    }
    else if(component ==1){
        NSArray* cityarray = [self.provinceDic[selectProvince] allKeys];
        return cityarray[row];
    }
    else{
        NSArray* districts = self.provinceDic[selectProvince][selectCity];
        return districts[row];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void) updateSelect:(UIPickerView*)pickerview{
    NSInteger first_Row = [pickerview selectedRowInComponent:0];
    selectProvince = self.provincenames[first_Row];
    NSInteger second_Row = [pickerview selectedRowInComponent:1];
    NSArray* cityarray = [self.provinceDic[selectProvince] allKeys];
    selectCity = cityarray[second_Row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if(component == 0){
        [pickerView selectRow:0 inComponent:1 animated:NO];
        [pickerView selectRow:0 inComponent:2 animated:NO];
        [pickerView reloadComponent:1];
        [pickerView reloadComponent:2];
    }
    else if(component == 1){
        [pickerView selectRow:0 inComponent:2 animated:NO];
        [pickerView reloadComponent:2];
    }
    return;
    
}
@end
