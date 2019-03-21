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

#define RGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define RandomRGBColor RGBColor(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255))

@interface WaterfallCollectionViewController ()<WaterfallCollectionViewDelegate>

@property(nonatomic,strong)NSArray *productArray;

@end

@implementation WaterfallCollectionViewController

static NSString * const reuseIdentifier = @"WaterfallCollectionViewCell";

-(instancetype)init{
    WaterfallCollectionViewLayout *layout = [WaterfallCollectionViewLayout new];
    layout.delegate = self;
    return [super initWithCollectionViewLayout:layout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"萌图";
    [self initData];
    // Register cell classes
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([WaterfallCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.backgroundColor = RGBColor(235, 235, 235);
}

- (void)initData {
    if ([_number integerValue] == 1) {
        self.productArray = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18"];
    } else if ([_number integerValue] == 2) {
        self.productArray = [NSArray arrayWithArray:[Fetch sharedFetch].list];
    }
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
    cell.backgroundColor = RandomRGBColor;
    NSString *src = [self.productArray objectAtIndex:indexPath.item];
    UIImage *image;
    if ([_number integerValue] == 2) {
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:src]];
        image = [UIImage imageWithData:data];
    } else {
        image = [UIImage imageNamed:src];
    }
    [cell.image setImage:image];
    return cell;
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
