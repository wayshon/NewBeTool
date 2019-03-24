//
//  ScanViewController.m
//  tools
//
//  Created by 王旭 on 2019/3/23.
//  Copyright © 2019 王旭. All rights reserved.
//

#import "ScanViewController.h"
#import "FetchDetail.h"
#import "SVProgressHUD.h"
#import "ScanCollectionViewCell.h"
#import "WaterfallCollectionViewLayout.h"

@interface ScanViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, WaterfallCollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *imgs;
@end

@implementation ScanViewController

static NSString * const reuseIdentifier = @"WXDetailCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    if (_desc) {
        self.title = _desc;
    }
    
    [self initData];
    [self initView];
    
}

- (void)initData {
    if (_path) {
        [SVProgressHUD showWithStatus:@"加载中.."];
        [FetchDetail fetchData:_path Block:^(NSArray *result) {
            NSLog(@"*****  result  == %@", result);
            self.imgs = [NSArray arrayWithArray:result];
//            NSMutableArray *tempArray = [NSMutableArray new];
//            [result enumerateObjectsUsingBlock:^(NSString *src, NSUInteger idx, BOOL * _Nonnull stop) {
//                [tempArray addObject:@{@""}]
//
//            }];
            
            dispatch_async(dispatch_get_main_queue(), ^() {
                [SVProgressHUD dismiss];
                [self.collectionView reloadData];
            });
        }];
    }
}

- (NSArray *)imgs {
    if (!_imgs) {
        _imgs = [NSArray new];
    }
    return _imgs;
}

- (void)initView {
    CGSize size = [UIScreen mainScreen].bounds.size;
    CGFloat kScreenWidth = size.width;
    CGFloat kScreenHeight = size.height;
    
    WaterfallCollectionViewLayout *layout = [WaterfallCollectionViewLayout new];
    layout.delegate = self;
    /**
     创建collectionView
     */
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64) collectionViewLayout:layout];
    [self.collectionView setBackgroundColor:[UIColor colorWithRed:182 green:238 blue:238 alpha:1]];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[ScanCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self.view addSubview:self.collectionView];
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_imgs count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ScanCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.src = _imgs[indexPath.row];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    NSInteger index = indexPath.item;
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
