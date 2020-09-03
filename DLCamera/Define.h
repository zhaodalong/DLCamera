//
//  Define.h
//  DLCamera
//
//  Created by 百维科技 on 2020/9/1.
//  Copyright © 2020 百维科技. All rights reserved.
//

#ifndef Define_h
#define Define_h

//当前屏幕size
#define M_S [UIScreen mainScreen].bounds.size

//以效果图为iphone6的尺寸布局
#define AutoWith(x) (x/375.0*[UIScreen mainScreen].bounds.size.width)
#define AutoHeight(x) (x/667.0*[UIScreen mainScreen].bounds.size.height)

#endif /* Define_h */
