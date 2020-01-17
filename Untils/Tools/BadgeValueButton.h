//
//  BadgeValueButton.h
//  Touqiu
//
//  Created by Zhang on 2019/7/30.
//  Copyright © 2019 com.touqiu.touqiu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ButtonMyBlock)(void);

@interface BadgeValueButton : UIButton

/** 大圆脱离小圆的最大距离 */
@property (nonatomic, assign) CGFloat        maxDistance;

/** 小圆 */
@property (nonatomic, strong) UIView         *samllCircleView;

/** 按钮消失的动画图片组 */
@property (nonatomic, strong) NSMutableArray *images;

@property (nonatomic, copy) ButtonMyBlock block;

@end

NS_ASSUME_NONNULL_END
