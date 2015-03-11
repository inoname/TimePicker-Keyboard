//
//  ViewController.m
//  04-datePicker
//
//  Created by kouliang on 14/12/19.
//  Copyright (c) 2014年 kouliang. All rights reserved.
//

//设置label键盘的方法
//label.inputView=picker
//label.inputAccessoryView=tool

//添加自己的工具类NSObject+arrqy.h




#import "ViewController.h"
#import "Province.h"
#import "NSObject+arrqy.h"

@interface ViewController ()<UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *birthdayField;
@property (weak, nonatomic) IBOutlet UITextField *cityField;

#warning 不能用weak
@property(nonatomic,strong)UIDatePicker *datePicker;
@property(nonatomic,strong)UIPickerView *pickerView;
@property(nonatomic,strong)UIToolbar *toolBar;

@property(nonatomic,weak)UIBarButtonItem *previousItem;
@property(nonatomic,weak)UIBarButtonItem *nextItem;

//存放模型数据
@property(nonatomic,strong)NSArray *provinces;
//记录第一列展示城市所对应的省份序列号
@property(nonatomic,assign) NSInteger selProvinceIndex;
//记录cityField是否已经被编辑过
@property(nonatomic,assign,getter=isCityFieldEdited)BOOL cityFieldEdited;
@end




@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置输入框的代理
    _birthdayField.delegate=self;
    _cityField.delegate=self;
    
    _birthdayField.inputView=self.datePicker;
    _birthdayField.inputAccessoryView=self.toolBar;
    
    _cityField.inputView=self.pickerView;
    _cityField.inputAccessoryView=self.toolBar;
}

#pragma mark - provinces的懒加载方法
-(NSArray *)provinces{
    if (_provinces==nil) {
        NSString *path=[[NSBundle mainBundle]pathForResource:@"cities.plist" ofType:nil];
        NSArray *dictArray=[NSArray arrayWithContentsOfFile:path];
        _provinces=[Province objectArrayWithDictArray:dictArray];
    }
    return _provinces;
}

#pragma mark - 键盘的懒加载方法
#pragma mark datePicker
-(UIDatePicker *)datePicker{
    if (_datePicker==nil) {
        //自定义文本框的键盘
        UIDatePicker *picker=[[UIDatePicker alloc]init];
        //只显示日期
        picker.datePickerMode=UIDatePickerModeDate;
        //设置区域
        picker.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"];
        //监听UIDatePicker的滚动
        [picker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
        _datePicker=picker;
    }
    return _datePicker;
}
#pragma mark pickerView
-(UIPickerView *)pickerView{
    if (_pickerView==nil) {
        //创建pickerView
        UIPickerView *pickerView=[[UIPickerView alloc]init];
        //设置数据源和代理
        pickerView.dataSource=self;
        pickerView.delegate=self;
        _pickerView=pickerView;
    }
    return _pickerView;
}
#pragma mark toolBar
-(UIToolbar *)toolBar{
    if (_toolBar==nil) {
        //自定义文本框键盘上面显示的工具控件
        UIToolbar *tool=[[UIToolbar alloc]init];
        tool.frame=CGRectMake(0, 0, 0, 40);
        tool.barTintColor=[UIColor greenColor];
        
        UIBarButtonItem *item1=[[UIBarButtonItem alloc]initWithTitle:@"上一个" style:UIBarButtonItemStylePlain target:self action:@selector(previousClick)];
        item1.enabled=YES;
        UIBarButtonItem *item2=[[UIBarButtonItem alloc]initWithTitle:@"下一个" style:UIBarButtonItemStylePlain target:self action:@selector(nextClick)];
        UIBarButtonItem *item3=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *item4=[[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(doneClick)];
        self.previousItem=item1;
        self.nextItem=item2;
        tool.items=@[item1,item2,item3,item4];
        _toolBar=tool;
    }
    return _toolBar;
}

#pragma mark - UITextField的代理方法
#pragma mark 不允许给文本框输入文字
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    // return NO to not change text
    return NO;
}
#pragma mark 第一次唤出键盘时，输入框自动赋值
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.birthdayField) { // 判断是否生日文本框
        [self dateChange:self.datePicker];
        self.previousItem.enabled=NO;
        self.nextItem.enabled=YES;
    }else{ // 城市
        self.nextItem.enabled=NO;
        self.previousItem.enabled=YES;
        if (!self.isCityFieldEdited) {
            [self pickerView:_pickerView didSelectRow:0 inComponent:0];
            self.cityFieldEdited=YES;
        }
    }
}

#pragma mark - datePicker的监听事件
-(void)dateChange:(UIDatePicker *)datePicker{
#pragma mark 给生日文本框赋值
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    _birthdayField.text = [fmt stringFromDate:datePicker.date];
}

#pragma mark - pickerView数据源方法
#pragma mark 有多少列
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}
#pragma mark 每一列有多少行
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if (component==0) {
        return self.provinces.count;
    }else{
        //获取第0列选中的行
        NSInteger selectedIndex=[self.pickerView selectedRowInComponent:0];
        //获取对应的省份
        Province *province=self.provinces[selectedIndex];
        return province.cities.count;
    }
}
#pragma mark - pickerView代理方法
#pragma mark 每一行显示什么
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component==0) {
        return [self.provinces[row] name];
    }else{
#warning 二级联动问题
        //        //获取第0列选中的行
        //        NSInteger selectedIndex=[self.pickerView selectedRowInComponent:0];
        //        //获取对应的省份
        //        Province *province=self.provinces[selectedIndex];
        Province *province=self.provinces[_selProvinceIndex];
        return province.cities[row];
    }
}
#pragma mark 监听pickerView选中了哪一行
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component==0) {
        
        //记录第一列展示城市所对应的省份序列号
        _selProvinceIndex=row;
        //刷新第一列
        [self.pickerView reloadComponent:1];
        //让第一列滚动到第0行
        [self.pickerView selectRow:0 inComponent:1 animated:YES];
    }
    
#pragma mark 给城市文本框赋值
    // 获取省份模型
    Province *p = _provinces[_selProvinceIndex];
    // 获取城市的名称
    NSInteger cityIndex = [pickerView selectedRowInComponent:1];
    NSString *cityName = p.cities[cityIndex];
    
    _cityField.text = [NSString stringWithFormat:@"%@ %@",p.name,cityName];
}



#pragma mark - UIToolBar按钮的监听事件
-(void)previousClick{
    [self.birthdayField becomeFirstResponder];
}
-(void)nextClick{
    [self.cityField becomeFirstResponder];
}
-(void)doneClick{
    [self.view endEditing:YES];
}
@end
