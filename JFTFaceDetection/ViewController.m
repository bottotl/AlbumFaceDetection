//
//  ViewController.m
//  JFTFaceDetection
//
//  Created by syfll on 2017/10/27.
//  Copyright © 2017年 syfll. All rights reserved.
//

#import "ViewController.h"
#import <Photos/Photos.h>

@interface ViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic, strong) CIContext *context;
@property (nonatomic, strong) UIImagePickerController *picker;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.picker = [[UIImagePickerController alloc] init];
    self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.picker.delegate = self;
    
    // Do any additional setup after loading the view, typically from a nib.
    self.context = [CIContext context];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
            NSLog(@"have people");
        } else {
            NSLog(@"no people");
        }
    }
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
