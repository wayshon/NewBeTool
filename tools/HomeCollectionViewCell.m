//
//  HomeCollectionViewCell.m
//  tools
//
//  Created by jike1 on 2019/3/21.
//  Copyright © 2019 王旭. All rights reserved.
//

#import "HomeCollectionViewCell.h"

@interface HomeCollectionViewCell()

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, assign) BOOL isInited;

@end

@implementation HomeCollectionViewCell

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self initViews];
}

- (void) initViews {
    if (!_isInited) {
        _isInited = YES;
        
        self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        self.imgView.clipsToBounds = YES;
        
        self.label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        self.label.textColor = [UIColor colorWithRed:0 green:255 blue:255 alpha:1];
        self.label.font = [UIFont fontWithName:@"Arial" size:18.0f];
        self.label.textAlignment = 1;
        
        [self setBackgroundColor:[UIColor colorWithRed:182 green:238 blue:238 alpha:1]];
    }
}

- (void)setImgPath:(NSString *)imgPath {
    _imgPath = imgPath;
    
    [self updateViews];
    
    [self.imgView setImage:[UIImage imageNamed:imgPath]];
    [self addSubview:self.imgView];
    self.label.text = imgPath;
    [self addSubview:self.label];
}

- (void)updateViews {
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGFloat width = rect.size.width;
    CGFloat padding = 20.0, imgWidth = ((width - (padding * 4)) / 3) - 20, labelHeight = 20.0;
    
    [self.imgView setFrame:CGRectMake(0, 0, imgWidth, imgWidth)];
    self.imgView.layer.cornerRadius = imgWidth / 2;
    
    [self.label setFrame:CGRectMake(0, imgWidth, imgWidth, labelHeight)];
}

@end
