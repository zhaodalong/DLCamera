//
//  DLCameraTopView.m
//  DLCamera
//
//  Created by 百维科技 on 2020/9/1.
//  Copyright © 2020 百维科技. All rights reserved.
//

#import "DLCameraTopView.h"


@interface DLCameraTopView ()

@property(strong, nonatomic) UIButton *flashOn;
@property(strong, nonatomic) UIButton *changeCamera;

@end

@implementation DLCameraTopView

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
    //创建闪光设置按钮
    _flashOn = [UIButton buttonWithType:UIButtonTypeCustom];
    _flashOn.backgroundColor = [UIColor clearColor];
    [_flashOn addTarget:self action:@selector(flash) forControlEvents:UIControlEventTouchUpInside];
    [_flashOn setTitle:@"闪光灯关" forState:UIControlStateNormal];
    [self addSubview:_flashOn];
    [_flashOn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(25);
        make.bottom.equalTo(self.mas_bottom).offset(-20);
        make.size.mas_equalTo(CGSizeMake(100, 30));
    }];
    //创建切换摄像头按钮
    _changeCamera = [UIButton buttonWithType:UIButtonTypeCustom];
    _changeCamera.backgroundColor = [UIColor clearColor];
    [_changeCamera setTitle:@"切换" forState:UIControlStateNormal];
    [_changeCamera addTarget:self action:@selector(change) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_changeCamera];
    [_changeCamera mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-25);
        make.bottom.equalTo(self.mas_bottom).offset(-20);
        make.size.mas_equalTo(CGSizeMake(60, 30));
    }];
}

-(void)flash {
    if (_delegate != nil && [_delegate respondsToSelector:@selector(flashOnAction:)]) {
        [_delegate flashOnAction:_flashOn];
    }
}

-(void)change {
    if (_delegate != nil && [_delegate respondsToSelector:@selector(changeCameraAction)]) {
        [_delegate changeCameraAction];
    }
}

@end
