//
//  DoudouCollectionViewController.m
//  tools
//
//  Created by 王旭 on 2019/3/25.
//  Copyright © 2019 王旭. All rights reserved.
//

#import "DoudouCollectionViewController.h"
#import "WaterfallCollectionViewCell.h"
#import "WaterfallCollectionViewLayout.h"
#import "WaterfallModel.h"
#import "YBImageBrowser.h"

@interface DoudouCollectionViewController ()<WaterfallCollectionViewDelegate, YBImageBrowserDataSource>
@property (nonatomic, strong) NSArray *productArray;
@end

@implementation DoudouCollectionViewController


static NSString * const reuseIdentifier = @"DoudouCell";

-(instancetype)init{
    WaterfallCollectionViewLayout *layout = [WaterfallCollectionViewLayout new];
    layout.delegate = self;
    return [super initWithCollectionViewLayout:layout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"萌图";
    
    [self initView];
}

- (NSArray *)productArray {
    if (!_productArray) {
        NSArray *array = @[@{@"title":@"豆豆", @"src":@"1", @"href":@""},@{@"title":@"豆豆", @"src":@"2", @"href":@""},@{@"title":@"豆豆", @"src":@"3", @"href":@""},@{@"title":@"豆豆", @"src":@"4", @"href":@""},@{@"title":@"豆豆", @"src":@"5", @"href":@""},@{@"title":@"豆豆", @"src":@"6", @"href":@""},@{@"title":@"豆豆", @"src":@"7", @"href":@""},@{@"title":@"豆豆", @"src":@"8", @"href":@""},@{@"title":@"豆豆", @"src":@"9", @"href":@""},@{@"title":@"豆豆", @"src":@"10", @"href":@""},@{@"title":@"豆豆", @"src":@"11", @"href":@""},@{@"title":@"豆豆", @"src":@"12", @"href":@""},@{@"title":@"豆豆", @"src":@"13", @"href":@""},@{@"title":@"豆豆", @"src":@"14", @"href":@""},@{@"title":@"豆豆", @"src":@"15", @"href":@""},@{@"title":@"豆豆", @"src":@"16", @"href":@""},@{@"title":@"豆豆", @"src":@"17", @"href":@""},@{@"title":@"豆豆", @"src":@"18", @"href":@""}];
        _productArray = [NSArray arrayWithArray:array];
    }
    return _productArray;
}

- (void)initView {
    [self.collectionView registerClass:[WaterfallCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.backgroundColor = RGBColor(235, 235, 235);
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
    YBImageBrowser *browser = [YBImageBrowser new];
    browser.dataSource = self;
    browser.currentIndex = indexPath.item;
    [browser show];
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


#pragma mark 实现 <YBImageBrowserDataSource> 协议方法配置数据源
- (NSUInteger)yb_numberOfCellForImageBrowserView:(YBImageBrowserView *)imageBrowserView {
    return [self.productArray count];
}
- (id<YBImageBrowserCellDataProtocol>)yb_imageBrowserView:(YBImageBrowserView *)imageBrowserView dataForCellAtIndex:(NSUInteger)index {
    YBImageBrowseCellData *data = [YBImageBrowseCellData new];
    data.imageBlock = ^__kindof UIImage * _Nullable{
        return [YBImage imageNamed:[self.productArray[index] valueForKey:@"src"]];
    };
    return data;
}

@end
