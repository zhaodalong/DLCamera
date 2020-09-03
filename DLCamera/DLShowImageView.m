//
//  DLShowImageView.m
//  DLCamera
//  
//  Created by 百维科技 on 2020/9/2.
//  Copyright © 2020 百维科技. All rights reserved.
//

#import "DLShowImageView.h"

@interface DLShowImageView ()

@property(strong, nonatomic) UIImageView *imageView;
@property(strong, nonatomic) UIButton *sure;
@property(strong, nonatomic) UIButton *cancel;

@end
@implementation DLShowImageView

- (void)awakeFromNib{
    [super awakeFromNib];
    [self initSubViews];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}

-(void)initSubViews {
    
    self.backgroundColor = [UIColor blackColor];
    //创建确定按钮
    _sure = [UIButton buttonWithType:UIButtonTypeCustom];
    _sure.backgroundColor = [UIColor clearColor];
    [_sure setTitle:@"确定" forState:UIControlStateNormal];
    [_sure addTarget:self action:@selector(sureClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_sure];
    [_sure mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-25);
        make.top.equalTo(self.mas_top).offset(40);
        make.size.mas_equalTo(CGSizeMake(60, 30));
    }];
    //创建取消按钮
    _cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancel.backgroundColor = [UIColor clearColor];
    [_cancel setTitle:@"取消" forState:UIControlStateNormal];
    [_cancel addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_cancel];
    [_cancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(25);
        make.top.equalTo(self.mas_top).offset(40);
        make.size.mas_equalTo(CGSizeMake(60, 30));
    }];
    //创建imageView
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 100, self.bounds.size.width, self.bounds.size.height-200)];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.clipsToBounds = YES;
    [self addSubview:_imageView];
    
}

-(void)sureClick{
    if (_delegate != nil && [_delegate respondsToSelector:@selector(sureAction)]) {
        [_delegate sureAction];
    }
}

-(void)cancelClick{
    if (_delegate != nil && [_delegate respondsToSelector:@selector(cancelBtnAction)]) {
        [_delegate cancelBtnAction];
    }
}

- (void)setImageToImageView:(UIImage *)image isFront:(BOOL)isFrontVideo {
    _imageView.image = image;
    if(isFrontVideo) _imageView.transform = CGAffineTransformMakeScale(-1, 1);
}

@end
