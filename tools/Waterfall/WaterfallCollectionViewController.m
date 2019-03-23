//
//  WaterfallCollectionViewController.m
//  UICollectionVIewDemo
//
//  Created by DaLei on 2017/6/8.
//  Copyright © 2017年 DaLei. All rights reserved.
//

#import "WaterfallCollectionViewController.h"
#import "WaterfallCollectionViewCell.h"
#import "WaterfallCollectionViewLayout.h"
#import "Fetch.h"
#import "WaterfallCollectionViewCell.h"
#import "ScanViewController.h"
#import "WaterfallModel.h"

#define RGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define RandomRGBColor RGBColor(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255))

@interface WaterfallCollectionViewController ()<WaterfallCollectionViewDelegate>

@property (nonatomic, strong) NSArray *productArray;

@end

@implementation WaterfallCollectionViewController

static NSString * const reuseIdentifier = @"WXCell";

-(instancetype)init{
    WaterfallCollectionViewLayout *layout = [WaterfallCollectionViewLayout new];
    layout.delegate = self;
    return [super initWithCollectionViewLayout:layout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"萌图";
    
    [self.collectionView registerClass:[WaterfallCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.backgroundColor = RGBColor(235, 235, 235);
    
    [Fetch sharedFetch].block = ^(NSArray *array){
        NSLog(@"block ==================  %@", array);
        NSArray *tempArray = [self.productArray arrayByAddingObjectsFromArray:array];
        self.productArray = [NSArray arrayWithArray:tempArray];
        dispatch_async(dispatch_get_main_queue(), ^() {
            [self.collectionView reloadData];
        });
    };
}

- (NSArray *)productArray {
    if (_productArray == nil) {
        if ([_number integerValue] == 1) {
            _productArray = @[@{@"title":@"豆豆", @"title":@"1", @"href":@""},@{@"title":@"豆豆", @"title":@"2", @"href":@""},@{@"title":@"豆豆", @"title":@"3", @"href":@""},@{@"title":@"豆豆", @"title":@"4", @"href":@""},@{@"title":@"豆豆", @"title":@"5", @"href":@""},@{@"title":@"豆豆", @"title":@"6", @"href":@""},@{@"title":@"豆豆", @"title":@"7", @"href":@""},@{@"title":@"豆豆", @"title":@"8", @"href":@""},@{@"title":@"豆豆", @"title":@"9", @"href":@""},@{@"title":@"豆豆", @"title":@"10", @"href":@""},@{@"title":@"豆豆", @"title":@"11", @"href":@""},@{@"title":@"豆豆", @"title":@"12", @"href":@""},@{@"title":@"豆豆", @"title":@"13", @"href":@""},@{@"title":@"豆豆", @"title":@"14", @"href":@""},@{@"title":@"豆豆", @"title":@"15", @"href":@""},@{@"title":@"豆豆", @"title":@"16", @"href":@""},@{@"title":@"豆豆", @"title":@"17", @"href":@""},@{@"title":@"豆豆", @"title":@"18", @"href":@""}];
        } else if ([_number integerValue] == 2) {
            _productArray = [NSArray arrayWithArray:[Fetch sharedFetch].list];
        }
    }
    return _productArray;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark <UICollectionViewDataSource>


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.productArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WaterfallCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    WaterfallModel *model = [[WaterfallModel alloc] init];
    NSDictionary *dic = [self.productArray objectAtIndex:indexPath.row];
    [model setValuesForKeysWithDictionary: dic];
    
    cell.model = model;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSObject *obj = [self.productArray objectAtIndex:indexPath.item];
    NSString *url = [obj valueForKey:@"href"];
    if (url && ![url isEqualToString:@""]) {
        ScanViewController *vc = [ScanViewController new];
        vc.path = url;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark <WaterfallCollectionViewDelegate>

- (CGFloat)waterflowLayout:(WaterfallCollectionViewLayout *)waterflowLayout heightForItemAtIndex:(NSUInteger)index itemWidth:(CGFloat)itemWidth{
    // 获取图片的宽高，根据图片的比例计算Item的高度。
//    UIImage *image = [UIImage imageNamed:[self.productArray objectAtIndex:index]];
//    CGFloat fixelW = CGImageGetWidth(image.CGImage);
//    CGFloat fixelH = CGImageGetHeight(image.CGImage);
//    CGFloat itemHeight = fixelH * itemWidth / fixelW;
//    return itemHeight + 50;
    return 300;
}

- (NSInteger)columnCountInWaterflowLayout:(WaterfallCollectionViewLayout *)waterflowLayout{
    return 2;
}

- (CGFloat)columnMarginInWaterflowLayout:(WaterfallCollectionViewLayout *)waterflowLayout{
    return 10;
}

- (CGFloat)rowMarginInWaterflowLayout:(WaterfallCollectionViewLayout *)waterflowLayout{
    return 10;
}

- (UIEdgeInsets)edgeInsetsInWaterflowLayout:(WaterfallCollectionViewLayout *)waterflowLayout{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}



@end
