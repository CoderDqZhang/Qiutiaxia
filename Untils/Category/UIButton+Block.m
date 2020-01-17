//
//  UIButton+Block.m
//  Touqiu
//
//  Created by Zhang on 2019/5/10.
//  Copyright © 2019 com.touqiu.touqiu. All rights reserved.
//

#import "UIButton+Block.h"
#import <objc/runtime.h>

@implementation UIButton (Block)
static char ActionTag;
    
- (void)addAction:(ButtonBlock)block
    {
        objc_setAssociatedObject(self, &ActionTag, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
        [self addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
    }
    
- (void)addAction:(ButtonBlock)block forControlEvents:(UIControlEvents)controlEvents
    {
        objc_setAssociatedObject(self, &ActionTag, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
        [self addTarget:self action:@selector(action:) forControlEvents:controlEvents];
    }
    
- (void)action:(id)sender
    {
        ButtonBlock blockAction = (ButtonBlock)objc_getAssociatedObject(self, &ActionTag);
        if (blockAction)
        {
            blockAction(self);
        }
    }
@end

