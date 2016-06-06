//
//  HJColorPickerController.h
//  GraffitiPhotos
//
//  Created by Kevin on 16/6/4.
//  Copyright © 2016年 zenghuajing. All rights reserved.
//

//代理协议
@protocol HJColorPickerViewControllerDelegate <NSObject>
- (void)colorSelected:(UIColor *)selectedColor andLineWidth:(CGFloat)lineWidth;
@end

@interface HJColorPickerViewController : UIViewController
//代理对象
@property (nonatomic, weak) id <HJColorPickerViewControllerDelegate>delegate;
//当前选择的颜色
@property (nonatomic, strong) UIColor *currentSelectedColor;
//线宽
@property (nonatomic, assign) CGFloat lineWidth;
@end
