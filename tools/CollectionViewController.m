//
//  CollectionViewController.m
//  tools
//
//  Created by jike1 on 2019/3/21.
//  Copyright © 2019 王旭. All rights reserved.
//

#import "CollectionViewController.h"
#import "HomeCollectionViewCell.h"
#import "DetailViewController.h"
#import "WaterfallCollectionViewController.h"
#import "SVProgressHUD.h"
#import "DoudouCollectionViewController.h"

@interface CollectionViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) NSArray *imgs;
@end

@implementation CollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"NewBeTools"];
    
    [self initData];
    [self initView];
}

- (void)initData {
    self.imgs = @[@"剃须刀", @"电锯", @"警报器", @"SOS", @"危险", @"防空警报", @"蚊子", @"鸣笛", @"萌图"];
}

- (void)initView {
    CGFloat kLineSpacing = 20;
    int kLineNum = 2;
    CGSize size = [UIScreen mainScreen].bounds.size;
    CGFloat kScreenWidth = size.width;
    CGFloat kScreenHeight = size.height;
    /**
     创建layout
     */
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    /**
     设置item的行间距和列间距
     */
    layout.minimumInteritemSpacing = kLineSpacing;
    layout.minimumLineSpacing = kLineSpacing;
    /**
     设置item的大小
     */
    CGFloat itemW = (kScreenWidth-(kLineNum+1)*kLineSpacing)/kLineNum-0.001;
    layout.itemSize = CGSizeMake(itemW, itemW);
    /*
     设置每个分区的上左下右的内边距
     */
    layout.sectionInset = UIEdgeInsetsMake(kLineSpacing, kLineSpacing,kLineSpacing, kLineSpacing);
    /**
     设置分区的头视图和尾视图是否始终固定在屏幕上边和下边
     */
    layout.sectionFootersPinToVisibleBounds = YES;
    /**
     创建collectionView
     */
    UICollectionView* collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64) collectionViewLayout:layout];
    [collectionView setBackgroundColor:[UIColor colorWithRed:182 green:238 blue:238 alpha:1]];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [collectionView registerClass:[HomeCollectionViewCell class] forCellWithReuseIdentifier:@"HomeCollectionViewCell"];
    [self.view addSubview:collectionView];
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _imgs.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndentifer = @"HomeCollectionViewCell";
    HomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIndentifer forIndexPath:indexPath];
    cell.imgPath = _imgs[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *imgPath = _imgs[indexPath.item];
    if ([imgPath isEqualToString:@"萌图"]) {
        [self judge];
    } else {
        UIStoryboard *MainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        DetailViewController *vc = [MainStoryboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
        vc.imgPath = imgPath;
        [self.navigationController showViewController:vc sender: nil];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((collectionView.frame.size.width - (20 * 4)) / 3, (collectionView.frame.size.width - (20 * 4)) / 3);
}

- (void)judge {
    [self goFunnyArea: 1];
//    NSInteger permissionNumber = [[NSUserDefaults standardUserDefaults] integerForKey:@"permissionNumber"];
//    if (permissionNumber != 0) {
//        [self goFunnyArea: permissionNumber];
//    } else {
//        [self alert];
//    }
}

- (void)goFunnyArea: (NSInteger)number {
    [[NSUserDefaults standardUserDefaults] setInteger:number forKey:@"permissionNumber"];
    switch (number) {
        case 1:
        {
            DoudouCollectionViewController *vc = [DoudouCollectionViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:
        {
            WaterfallCollectionViewController *vc = [WaterfallCollectionViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:
            break;
    }
}

- (void)alert {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请输入授权码" message:@"萌图里面是个人圈的宠物分享图，需要邀请码才可以查看." preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = @"邀请码";
    }];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UITextField *codeField = alertController.textFields.firstObject;
        NSString *code = codeField.text;
        
        if(!code || [code isEqualToString:@""]) {
            [SVProgressHUD showErrorWithStatus:@"请输入内容"];
            [self presentViewController:alertController animated:YES completion:nil];
        } else if ([code isEqualToString:@"doudou"]){
            [self goFunnyArea: 1];
        } else {
            //        请求接口
            
//            mock
            if (true) {
                [SVProgressHUD showErrorWithStatus:@"邀请码不正确"];
                [self presentViewController:alertController animated:YES completion:nil];
            }
        }
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }];
    // 添加取消按钮才能点击空白隐藏
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}


@end
