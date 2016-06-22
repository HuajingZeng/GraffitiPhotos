//
//  HJDrawerView.m
//  GraffitiPhotos
//
//  Created by Kevin on 16/6/4.
//  Copyright © 2016年 zenghuajing. All rights reserved.
//

#import "HJDrawingView.h"

@interface HJDrawingView () {
    CGPoint _previousPoint;
    CGPoint _currentPoint;
}

@property (nonatomic, strong) UIImage *image;

@end

@implementation HJDrawingView

- (void)awakeFromNib {
    [self initialize];
}

- (void)drawRect:(CGRect)rect {
    [self.image drawInRect:self.bounds];
}

#pragma mark - Private methods
//初始化实例变量和属性
- (void)initialize {
    _currentPoint = CGPointMake(0, 0);
    _previousPoint = _currentPoint;
    
    _drawingMode = DrawingModePaint;
    _selectedColor = [UIColor blackColor];
}

//擦除线条
- (void)eraseLine {
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.image drawInRect:self.bounds];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetBlendMode(context, kCGBlendModeClear);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, _lineWidth);
    CGContextBeginPath(context);
    CGContextSetBlendMode(context, kCGBlendModeClear);
    CGContextMoveToPoint(context, _previousPoint.x, _previousPoint.y);
    CGContextAddLineToPoint(context, _currentPoint.x, _currentPoint.y);
    
    CGContextStrokePath(context);
    self.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    _previousPoint = _currentPoint;
    
    [self setNeedsDisplay];
}

//绘制线条
- (void)drawLine {
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.image drawInRect:self.bounds];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetStrokeColorWithColor(context, _selectedColor.CGColor);
    CGContextSetLineWidth(context, _lineWidth);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, _previousPoint.x, _previousPoint.y);
    CGContextAddLineToPoint(context, _currentPoint.x, _currentPoint.y);
    
    CGContextStrokePath(context);
    self.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    _previousPoint = _currentPoint;
    
    [self setNeedsDisplay];
}

//手指触摸
- (void)handleTouches {
    if (self.drawingMode == DrawingModePaint) {
        [self drawLine];
    }else if (self.drawingMode == DrawingModeErase) {
        [self eraseLine];
    }
}

#pragma mark - Touches Methods
//开始触摸时获取起始坐标
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    _previousPoint = [[touches anyObject] locationInView:self];
}

//触摸移动时获取移动后坐标
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    _currentPoint = [[touches anyObject] locationInView:self];
    [self handleTouches];
}

//触摸结束时获取结束坐标
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    _currentPoint = [[touches anyObject] locationInView:self];
    [self handleTouches];
}

// 清除图层内容
- (void)clearLayer {
    self.image = nil;
    
    [self setNeedsDisplay];
}

@end
