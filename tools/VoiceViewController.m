//
//  VoiceViewController.m
//  tools
//
//  Created by 王旭 on 2019/3/18.
//  Copyright © 2019 王旭. All rights reserved.
//

#import "VoiceViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface VoiceViewController ()
@property (nonatomic, retain) AVAudioPlayer *player;

@end

@implementation VoiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getButtonControl];
    [self getPlayer];
}

#pragma mark - 创建按钮和进度滑条方法
- (void)getButtonControl
{
    //创建播放按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setFrame:CGRectMake(0, 0, 100, 50)];
    
    button.center = CGPointMake(20, 200);
    
    [button setBackgroundColor:[UIColor redColor]];
    
    [button setTitle:@"播放" forState:UIControlStateNormal];
    
    [button setTitle:@"暂停" forState:UIControlStateSelected];
    
    [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
    
    /* 声音slider */
    //创建slider
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, 300, 20)];
    
    slider.center = CGPointMake(375 / 2, 450);
    
    /* 最大值 */
    [slider setMaximumValue:100.];
    
    /* 最小值 */
    [slider setMinimumValue:0.];
    
    /* 显示颜色 */
    [slider setMaximumTrackTintColor:[UIColor purpleColor]];
    
    /* 滑动后颜色 */
    [slider setMinimumTrackTintColor:[UIColor cyanColor]];
    
    /* 滑动就调用 */
    [slider setContinuous:YES];
    
    /* 滑动事件 */
    [slider addTarget:self action:@selector(slider:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:slider];
    
    /* 进度slider */
    UISlider *schSlider = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, 300, 20)];
    
    schSlider.center = CGPointMake(375 / 2, 500);
    
    [schSlider setMaximumValue:280.];
    
    [schSlider setMinimumValue:0.];
    
    [schSlider setContinuous:YES];
    
    [schSlider addTarget:self action:@selector(sliderClick:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:schSlider];
}
#pragma mark - 播放方法
- (void)getPlayer
{
    /* 获取本地文件 */
    NSBundle *bundle = [NSBundle mainBundle];
    
    NSString *urlString = [bundle pathForResource:@"car" ofType:@"mp3"];
    
    /* 初始化url */
    NSURL *url = [[NSURL alloc] initFileURLWithPath:urlString];
    
    /* 初始化音频文件 */
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    
    /* 加载缓冲 */
    [self.player prepareToPlay];
}
#pragma mark - button 点击方法
- (void)click:(UIButton *)button
{
    if (button.selected == NO) {
        [self.player play];
        button.selected = YES;
    }else{
        button.selected = NO;
        [self.player pause];
    }
}
#pragma mark - 声音滑动事件方法
- (void)slider:(UISlider *)slider
{
    self.player.volume = slider.value;
}
#pragma mark - 进度滑动事件
- (void)sliderClick:(UISlider *)slider
{
    self.player.currentTime = slider.value;
}
#pragma mark - player Dlegate
//结束时调用
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    NSLog(@"结束了");
}
//解析错误调用
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    
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
