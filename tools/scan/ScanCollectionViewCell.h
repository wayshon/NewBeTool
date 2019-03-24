//
//  ScanCollectionViewCell.h
//  tools
//
//  Created by 王旭 on 2019/3/25.
//  Copyright © 2019 王旭. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ScanCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) NSString *src;

- (instancetype)init;
- (instancetype)initWithFrame:(CGRect)frame;
- (void)setFrame:(CGRect)frame;

@end

NS_ASSUME_NONNULL_END
