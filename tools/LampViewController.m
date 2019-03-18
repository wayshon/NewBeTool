//
//  LampViewController.m
//  tools
//
//  Created by 王旭 on 2019/3/18.
//  Copyright © 2019 王旭. All rights reserved.
//

#import "LampViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface LampViewController ()
@property (nonatomic, strong) AVCaptureDevice *device;//捕获设备

@end

@implementation LampViewController
{
    BOOL device_open;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
}
- (IBAction)switch:(id)sender {
    //改变状态
    device_open = !device_open;
    
    //判断设备是否有闪关灯
    if (![self.device hasTorch]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                       message:@"当前设备没有闪关灯，无法开启照明功能"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确认"
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * _Nonnull action) {
                                                           }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction * _Nonnull action) {
                                                             }];
        [alert addAction:sureAction];
        [alert addAction:cancelAction];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    [self.device lockForConfiguration:nil];
    
    //根据状态，打开或关闭照明
    if (device_open) {
        [self.device setTorchMode:AVCaptureTorchModeOn];
        [sender setTitle:@"关闭照明" forState:UIControlStateNormal];
    }
    else {
        [self.device setTorchMode:AVCaptureTorchModeOff];
        [sender setTitle:@"打开照明" forState:UIControlStateNormal];
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

@end
