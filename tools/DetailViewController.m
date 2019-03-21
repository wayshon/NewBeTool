//
//  DetailViewController.m
//  tools
//
//  Created by jike1 on 2019/3/21.
//  Copyright © 2019 王旭. All rights reserved.
//

#import "DetailViewController.h"
#import <AudioToolbox/AudioToolbox.h>

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UIView *statusView;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property SystemSoundID sound;

@property (nonatomic, assign) BOOL deviceOpen;//开关
@property (nonatomic, assign) BOOL isNeedVibrate;//是否需要震动

@end

@implementation DetailViewController

void soundCompleteCallback(SystemSoundID sound,void * clientData) {
    AudioServicesPlaySystemSound(sound);  // 声音
}

void vibraCompleteCallback(SystemSoundID sound,void * clientData) {
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);  //震动
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *vibrates = @[@"剃须刀", @"电锯"];
    
    [vibrates enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj == self.imgPath) {
            self.isNeedVibrate = YES;
            *stop = YES;
        } else {
            self.isNeedVibrate = NO;
        }
    }];
    
    [self.navigationItem setTitle: _imgPath];
    
    [self.imgView setImage:[UIImage imageNamed: _imgPath]];
    self.imgView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.statusView.layer.cornerRadius = 20;
    [self.statusView setBackgroundColor:[UIColor redColor]];
    
    [self touch];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self stopVoice];
    [self stopVibrate];
}

- (IBAction)switch:(id)sender {
    [self touch];
}


- (void)touch {
    if (self.deviceOpen) {
        [self stopVoice];
        
        if (self.isNeedVibrate) {
            [self stopVibrate];
        }
        
        [self.statusView setBackgroundColor:[UIColor redColor]];
    } else {
        [self startVoice];
        
        if (self.isNeedVibrate) {
            [self startVibrate];
        }
        
        [self.statusView setBackgroundColor:[UIColor greenColor]];
    }
    self.deviceOpen = !self.deviceOpen;
}

- (void)startVoice {
    NSString *path = [[NSBundle mainBundle] pathForResource:_imgPath ofType:@"mp3"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &_sound);
    AudioServicesAddSystemSoundCompletion(_sound, NULL, NULL, soundCompleteCallback, NULL);
    AudioServicesPlaySystemSound(_sound);
}

- (void)stopVoice {
    AudioServicesDisposeSystemSoundID(_sound);
    AudioServicesRemoveSystemSoundCompletion(_sound);
}

- (void)startVibrate {
    AudioServicesAddSystemSoundCompletion(kSystemSoundID_Vibrate, NULL, NULL, vibraCompleteCallback, NULL);
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

- (void)stopVibrate {
    AudioServicesDisposeSystemSoundID(kSystemSoundID_Vibrate);
    AudioServicesRemoveSystemSoundCompletion(kSystemSoundID_Vibrate);
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
