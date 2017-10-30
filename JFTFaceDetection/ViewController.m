//
//  ViewController.m
//  JFTFaceDetection
//
//  Created by syfll on 2017/10/27.
//  Copyright © 2017年 syfll. All rights reserved.
//

#import "ViewController.h"
#import <Photos/Photos.h>
#import "JFTPhotosLoader.h"
#import "JFTPhotoPickerViewController.h"

@interface ViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic, strong) CIContext *context;
@property (nonatomic, strong) UIImagePickerController *picker;
@property (nonatomic, strong) JFTPhotosLoader *photoLoader;
@property (nonatomic, strong) NSArray <JFTPhotoModel *> *photoModels;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.photoLoader = [[JFTPhotosLoader alloc] init];
    
    self.picker = [[UIImagePickerController alloc] init];
    self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.picker.delegate = self;
    
    self.context = [CIContext context];
    
}

- (IBAction)fetchAllImages:(id)sender {
    self.photoModels = [self.photoLoader fetchModels];
    NSLog(@"%d", self.photoModels.count);
    JFTPhotoPickerViewController *photoList = [[JFTPhotoPickerViewController alloc] init];
    [self.navigationController pushViewController:photoList animated:YES];
}

//- (void)findA

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)showImagePicker:(id)sender {
    [self fetchPhotos];
}

- (void)fetchPhotos {
    [self presentViewController:self.picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    NSLog(@"didFinishPickingMediaWithInfo");
    UIImage *originimage = info[@"UIImagePickerControllerOriginalImage"];
    if (originimage) {
        if ([self faceInside:[CIImage imageWithCGImage:originimage.CGImage] imageOrientation:originimage.imageOrientation]) {
            [self log:@"have people"];
        } else {
            [self log:@"no people"];
        }
    }
}

- (void)log:(NSString *)log {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"log" message:log
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    });
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)faceInside:(CIImage *)image imageOrientation:(UIImageOrientation)imageOrientation {
    
    NSDictionary *opts = @{ CIDetectorAccuracy : CIDetectorAccuracyHigh };
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeFace
                                              context:self.context
                                              options:opts];
    
    opts = @{ CIDetectorImageOrientation : [self UIOrientationToCIOrientation:imageOrientation] };
    
    NSArray *features = [detector featuresInImage:image options:opts];
    if (features.count > 0) {
        return YES;
    }
    return NO;
}

/// see http://www.tanhao.me/pieces/1019.html/
- (NSNumber *)UIOrientationToCIOrientation:(UIImageOrientation)imageOrientation {
    switch (imageOrientation) {
        case UIImageOrientationUp:
            return @(1);
            break;
        case UIImageOrientationDown:
            return @(3);
            break;
        case UIImageOrientationLeft:
            return @(8);
            break;
        case UIImageOrientationRight:
            return @(6);
            break;
        case UIImageOrientationUpMirrored:
            return @(2);
            break;
        case UIImageOrientationDownMirrored:
            return @(4);
            break;
        case UIImageOrientationLeftMirrored:
            return @(5);
            break;
        case UIImageOrientationRightMirrored:
            return @(7);
            break;
    }
}

@end
