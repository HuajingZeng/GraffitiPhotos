//
//  HJDrawerView.h
//  GraffitiPhotos
//
//  Created by Kevin on 16/6/4.
//  Copyright © 2016年 zenghuajing. All rights reserved.
//

//绘画模式枚举类型
typedef NS_ENUM(NSInteger, DrawingMode){
    DrawingModePaint,
    DrawingModeErase,
};

@interface HJDrawingView : UIView
//绘画模式
@property (nonatomic, readwrite) DrawingMode drawingMode;
//颜色
@property (nonatomic, strong) UIColor *selectedColor;
//线宽
@property (nonatomic, assign) CGFloat lineWidth;
@end
