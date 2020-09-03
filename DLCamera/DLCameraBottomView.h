//
//  DLCameraBottomView.h
//  DLCamera
//
//  Created by 百维科技 on 2020/9/1.
//  Copyright © 2020 百维科技. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DLCameraBottomViewDelegate <NSObject>

/// 点击取消按钮事件
-(void)cancelAction;

/// 点击拍照按钮事件
-(void)takePhotoAction;

@end

@interface DLCameraBottomView : UIView
@property(weak, nonatomic) id<DLCameraBottomViewDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
