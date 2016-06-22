//
//  ViewController.m
//  GraffitiPhotos
//
//  Created by Kevin on 16/6/4.
//  Copyright © 2016年 zenghuajing. All rights reserved.
//

#import "HJViewController.h"
#import "HJDrawingView.h"
#import "HJColorPickerViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface HJViewController ()<UIImagePickerControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, HJColorPickerViewControllerDelegate>

//用于绘画的视图
@property (strong, nonatomic) IBOutlet HJDrawingView *drawingView;
//存放选择的照片
@property (weak, nonatomic) IBOutlet UIImageView *drawingPhoto;
//工具栏按钮
@property (weak, nonatomic) IBOutlet UIButton *pickPhotoButton;
@property (weak, nonatomic) IBOutlet UIButton *pickColorButton;
@property (weak, nonatomic) IBOutlet UIButton *eraserAndBrushButton;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;

//按钮点击事件
- (IBAction)pickPhotoButtonClick:(id)sender;
- (IBAction)pickColorButtonClick:(id)sender;
- (IBAction)eraserAndBrushButtonClick:(id)sender;
- (IBAction)saveButtonClick:(id)sender;

@end

@implementation HJViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化颜色和线宽属性
    [self.drawingView setSelectedColor:[UIColor redColor]];
    [self.drawingView setLineWidth:10];
    
}

//调用选择照片提醒框
- (IBAction)pickPhotoButtonClick:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择", nil];
    [actionSheet showInView:self.view];
}

//选择调色器
- (IBAction)pickColorButtonClick:(id)sender {
    HJColorPickerViewController *colorPicker = [[HJColorPickerViewController alloc] initWithNibName:@"HJColorPickerViewController" bundle:nil];
    [colorPicker setDelegate:self];
    [colorPicker setCurrentSelectedColor:self.drawingView.selectedColor];
    [colorPicker setLineWidth:self.drawingView.lineWidth];
    [self.navigationController pushViewController:colorPicker animated:YES];
}

//切换橡皮擦和画笔
- (IBAction)eraserAndBrushButtonClick:(id)sender {
    if (self.drawingView.drawingMode == DrawingModePaint) {
        [self.eraserAndBrushButton setImage:[UIImage imageNamed:@"Brush"] forState:UIControlStateNormal];
        self.drawingView.drawingMode = DrawingModeErase;
    }else if (self.drawingView.drawingMode == DrawingModeErase) {
        [self.eraserAndBrushButton setImage:[UIImage imageNamed:@"Eraser"] forState:UIControlStateNormal];
        self.drawingView.drawingMode = DrawingModePaint;
    }
}

//保存图片到相册
- (IBAction)saveButtonClick:(id)sender {
    UIImage *photo = self.drawingPhoto.image;
    
    UIGraphicsBeginImageContext(self.drawingView.frame.size);
    CGRect frame = self.drawingView.frame;
    frame.origin =CGPointMake(0, 0);
    [photo drawInRect:frame];
    [self.drawingView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.drawingPhoto.image = nil;
    [self.drawingView clearLayer];
    UIImageWriteToSavedPhotosAlbum(resultImage, self, nil, NULL);
}

#pragma mark - UIActionSheetDelegate methods
//监听动作按钮点击事件
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    [actionSheet dismissWithClickedButtonIndex:1 animated:YES];
    if (buttonIndex == 0) {
        UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];
        mediaUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        mediaUI.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
        mediaUI.allowsEditing = NO;
        mediaUI.delegate = self;
        [self presentViewController:mediaUI animated:YES completion:nil];
    }
}

#pragma mark - UIImagePickerControllerDelegate methods
//选择相册照片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = nil;
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }else {
        NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
        if (CFStringCompare((CFStringRef)mediaType, kUTTypeImage, 0) == kCFCompareEqualTo) {
            image = (UIImage *)[info objectForKey:UIImagePickerControllerOriginalImage];
        }
    }
    
    self.drawingPhoto.image = image;
    [self.drawingView clearLayer];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//退出选择照片提醒框
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - HJColorPickerViewControllerDelegate methods
//设置绘画视图的颜色和线宽
- (void)colorSelected:(UIColor *)selectedColor andLineWidth:(CGFloat)lineWidth {
    self.drawingView.selectedColor = selectedColor;
    self.drawingView.lineWidth = lineWidth;
}

- (IBAction)clear:(id)sender {
    self.drawingPhoto.image = nil;
    [self.drawingView clearLayer];
}

- (IBAction)quit:(id)sender {
    exit(0);
}

@end
