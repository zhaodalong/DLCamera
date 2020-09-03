//
//  DLCameraTopView.h
//  DLCamera
//
//  Created by 百维科技 on 2020/9/1.
//  Copyright © 2020 百维科技. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol DLCameraTopViewDelegate <NSObject>
///点击闪光按钮事件
-(void)flashOnAction:(UIButton *)sender;
///点击切换摄像头按钮事件
-(void)changeCameraAction;

@end

@interface DLCameraTopView : UIView

@property(weak, nonatomic) id<DLCameraTopViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
