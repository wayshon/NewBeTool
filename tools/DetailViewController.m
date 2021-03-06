//
//  DetailViewController.m
//  tools
//
//  Created by jike1 on 2019/3/21.
//  Copyright © 2019 王旭. All rights reserved.
//

#import "DetailViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "SVProgressHUD.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UIView *statusView;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property SystemSoundID sound;

@property (nonatomic, assign) BOOL deviceOpen;//开关
@property (nonatomic, assign) BOOL isNeedVibrate;//是否需要震动

@property AVAudioPlayer* player;

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
    
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    CGFloat currentVol = audioSession.outputVolume;
    
    if (currentVol <= 0) {
        [SVProgressHUD showInfoWithStatus:@"请调高手机音量"];
    }
    
//    NSArray *vibrates = @[@"剃须刀", @"电锯"];
//
//    [vibrates enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        if (obj == self.imgPath) {
//            self.isNeedVibrate = YES;
//            *stop = YES;
//        } else {
//            self.isNeedVibrate = NO;
//        }
//    }];
    
//    这里改成全部需要震动
    self.isNeedVibrate = YES;
    
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
//    NSString *path = [[NSBundle mainBundle] pathForResource:_imgPath ofType:@"mp3"];
//    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &_sound);
//    AudioServicesAddSystemSoundCompletion(_sound, NULL, NULL, soundCompleteCallback, NULL);
//    AudioServicesPlaySystemSound(_sound);
    
    NSString *path = [[NSBundle mainBundle] pathForResource:_imgPath ofType:@"mp3"];
    NSURL* url = [NSURL fileURLWithPath:path];
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    self.player.volume = 0.5;
    //设置循环次数，如果为负数，就是无限循环
    self.player.numberOfLoops =-1;
    //设置播放进度
    self.player.currentTime = 0;
    //准备播放
    [self.player prepareToPlay];
    [self.player play];
}

- (void)stopVoice {
//    AudioServicesDisposeSystemSoundID(_sound);
//    AudioServicesRemoveSystemSoundCompletion(_sound);
    [self.player stop];
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
