//
//  VibrationViewController.m
//  tools
//
//  Created by 王旭 on 2019/3/18.
//  Copyright © 2019 王旭. All rights reserved.
//

#import "VibrationViewController.h"
#import <AudioToolbox/AudioToolbox.h>

@interface VibrationViewController ()
@property SystemSoundID sound;;
@end

@implementation VibrationViewController
{
    BOOL device_open;//判断照明状态
}

void soundCompleteCallback(SystemSoundID sound,void * clientData) {
    AudioServicesPlaySystemSound(sound);  // 声音
}

void vibraCompleteCallback(SystemSoundID sound,void * clientData) {
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);  //震动
}

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (IBAction)switch:(id)sender {
    
    if (device_open) {
        AudioServicesDisposeSystemSoundID(kSystemSoundID_Vibrate);
        AudioServicesDisposeSystemSoundID(_sound);
        AudioServicesRemoveSystemSoundCompletion(kSystemSoundID_Vibrate);
        AudioServicesRemoveSystemSoundCompletion(_sound);
        
        [sender setTitle:@"开始震动" forState:UIControlStateNormal];
    } else {
//        声音
        NSString *path = [[NSBundle mainBundle] pathForResource:@"razor" ofType:@"mp3"];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &_sound);
        AudioServicesAddSystemSoundCompletion(_sound, NULL, NULL, soundCompleteCallback, NULL);
        AudioServicesPlaySystemSound(_sound);
//        震动
        AudioServicesAddSystemSoundCompletion(kSystemSoundID_Vibrate, NULL, NULL, vibraCompleteCallback, NULL);
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        
        [sender setTitle:@"关闭震动" forState:UIControlStateNormal];
    }
    device_open = !device_open;
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
