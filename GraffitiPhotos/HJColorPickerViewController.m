//
//  HJColorPickerController.m
//  GraffitiPhotos
//
//  Created by Kevin on 16/6/4.
//  Copyright © 2016年 zenghuajing. All rights reserved.
//

#import "HJColorPickerViewController.h"

@interface HJColorPickerViewController ()

//控制按钮
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *acceptButton;

//滑动条
@property (weak, nonatomic) IBOutlet UISlider *redColorSlider;
@property (weak, nonatomic) IBOutlet UISlider *greenColorSlider;
@property (weak, nonatomic) IBOutlet UISlider *blueColorSlider;
@property (weak, nonatomic) IBOutlet UISlider *lineWidthSlider;

//用于显示滑动条数值的文本
@property (weak, nonatomic) IBOutlet UILabel *redColorValue;
@property (weak, nonatomic) IBOutlet UILabel *greenColorValue;
@property (weak, nonatomic) IBOutlet UILabel *blueColorValue;
@property (weak, nonatomic) IBOutlet UILabel *lineWidthValue;

//显示调整好的颜色
@property (weak, nonatomic) IBOutlet UIView *resultColorImageView;

//按钮点击事件
- (IBAction)backButtonClicked:(id)sender;
- (IBAction)acceptButtonClicked:(id)sender;

//滑动条值改变事件
- (IBAction)redSliderChanged:(id)sender;
- (IBAction)greenSliderChanged:(id)sender;
- (IBAction)blueSliderChanged:(id)sender;
- (IBAction)lineWidthSliderChanged:(id)sender;

@end

@implementation HJColorPickerViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // do something
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //获取当前选择颜色的参数
    const CGFloat *_components = CGColorGetComponents(self.currentSelectedColor.CGColor);
    CGFloat red = _components[0];
    CGFloat green = _components[1];
    CGFloat blue = _components[2];
    
    //设置滑动条的当前值
    self.redColorSlider.value = red;
    self.greenColorSlider.value = green;
    self.blueColorSlider.value = blue;
    self.lineWidthSlider.value = self.lineWidth;
    
    //设置滑动条文本的显示数值
    [self.redColorValue setText:[NSString stringWithFormat:@"%.2f", red]];
    [self.greenColorValue setText:[NSString stringWithFormat:@"%.2f", green]];
    [self.blueColorValue setText:[NSString stringWithFormat:@"%.2f", blue]];
    [self.lineWidthValue setText:[NSString stringWithFormat:@"%ld", (NSInteger)self.lineWidth]];
    
    //设置显示调整好的颜色
    [self.resultColorImageView setBackgroundColor:self.currentSelectedColor];
}

#pragma mark - Private methods
//更新显示调整好的颜色
- (void)setResultColor {
    CGFloat red = self.redColorSlider.value;
    CGFloat green = self.greenColorSlider.value;
    CGFloat blue = self.blueColorSlider.value;
    
    [self.resultColorImageView setBackgroundColor:[UIColor colorWithRed:red green:green blue:blue alpha:1]];
    
    [self.redColorValue setText:[NSString stringWithFormat:@"%.2f", red]];
    [self.greenColorValue setText:[NSString stringWithFormat:@"%.2f", green]];
    [self.blueColorValue setText:[NSString stringWithFormat:@"%.2f", blue]];
}

#pragma mark - Button action methods
//点击返回按钮
- (IBAction)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//点击确认按钮
- (IBAction)acceptButtonClicked:(id)sender {
    self.currentSelectedColor = self.resultColorImageView.backgroundColor;
    self.lineWidth = self.lineWidthSlider.value;
    [self.delegate colorSelected:self.currentSelectedColor andLineWidth:self.lineWidth];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)redSliderChanged:(id)sender {
    [self setResultColor];
}

- (IBAction)greenSliderChanged:(id)sender {
    [self setResultColor];
}

- (IBAction)blueSliderChanged:(id)sender {
    [self setResultColor];
}

- (IBAction)lineWidthSliderChanged:(id)sender {
    [self.lineWidthValue setText:[NSString stringWithFormat:@"%ld", (NSInteger)self.lineWidthSlider.value]];
}

@end
