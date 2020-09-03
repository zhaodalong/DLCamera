//
//  DLShowImageView.h
//  DLCamera
//
//  Created by 百维科技 on 2020/9/2.
//  Copyright © 2020 百维科技. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DLShowImageViewDelegate <NSObject>

-(void)sureAction;
-(void)cancelBtnAction;

@end

@interface DLShowImageView : UIView

@property(weak, nonatomic) id<DLShowImageViewDelegate>delegate;

-(void)setImageToImageView:(UIImage *)image isFront:(BOOL)isFrontVideo;

@end

NS_ASSUME_NONNULL_END
