//
//  DLCameraBottomView.m
//  DLCamera
//
//  Created by 百维科技 on 2020/9/1.
//  Copyright © 2020 百维科技. All rights reserved.
//

#import "DLCameraBottomView.h"

@interface DLCameraBottomView ()

@property(strong, nonatomic) UIButton *cancel;
@property(strong, nonatomic) UIButton *takePhoto;

@end

@implementation DLCameraBottomView


- (void)awakeFromNib {
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

-(void)initSubViews{
    self.backgroundColor = [UIColor blackColor];
    //创建取消按钮
    _cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancel.backgroundColor = [UIColor clearColor];
    [_cancel setTitle:@"取消" forState:UIControlStateNormal];
    [_cancel addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_cancel];
    [_cancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(25);
        make.bottom.equalTo(self.mas_bottom).offset(-35);
        make.size.mas_equalTo(CGSizeMake(60, 30));
    }];
    //创建拍照按钮
    _takePhoto = [UIButton buttonWithType:UIButtonTypeCustom];
    _takePhoto.backgroundColor = [UIColor clearColor];
    [_takePhoto setImage:[UIImage imageNamed:@"photograph"] forState:UIControlStateNormal];
    [_takePhoto setImage:[UIImage imageNamed:@"photograph_Select"] forState:UIControlStateHighlighted];
    [_takePhoto addTarget:self action:@selector(takePhotoClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_takePhoto];
    [_takePhoto mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(M_S.width/2-30);
        make.bottom.equalTo(self.mas_bottom).offset(-20);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
}

-(void)cancelClick {
    if (_delegate != nil && [_delegate respondsToSelector:@selector(cancelAction)]) {
        [_delegate cancelAction];
    }
}

-(void)takePhotoClick {
    if (_delegate != nil && [_delegate respondsToSelector:@selector(takePhotoAction)]) {
        [_delegate takePhotoAction];
    }
}

@end
