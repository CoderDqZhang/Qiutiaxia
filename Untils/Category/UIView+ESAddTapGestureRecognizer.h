//
//  UIView+ESAddTapGestureRecognizer.h
//  Touqiu
//
//  Created by Zhang on 2019/5/17.
//  Copyright © 2019 com.touqiu.touqiu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (ESAddTapGestureRecognizer)
    
@property (nonatomic,assign) void(^block)(NSInteger tag);
    
- (void)addTapGestureRecognizerWithDelegate:(id)tapGestureDelegate Block:(void(^)(NSInteger tag))block;

@end

NS_ASSUME_NONNULL_END
