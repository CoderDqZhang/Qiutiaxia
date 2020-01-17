//
//  FirstAppStartManager.m
//  Touqiu
//
//  Created by Zhang on 2019/7/30.
//  Copyright © 2019 com.touqiu.touqiu. All rights reserved.
//

#import "FirstAppStartManager.h"
#import "KSGuaidViewManager.h"
#import <UIKit/UIKit.h>

@implementation FirstAppStartManager


- (void)setUpStartApp{
    KSGuaidManager.images = @[[UIImage imageNamed:@"ic_score"],
                              [UIImage imageNamed:@"ic_follow"],
                              [UIImage imageNamed:@"ic_screen"],
                              [UIImage imageNamed:@"ic_circle"],
                              [UIImage imageNamed:@"ic_information"]];
    
    /*
     方式一:
     */
     CGSize size = [UIScreen mainScreen].bounds.size;
     KSGuaidManager.dismissButtonImage = [UIImage imageNamed:@"立即体验"];
     KSGuaidManager.dismissButtonCenter = CGPointMake(size.width / 2, size.height - 38);
    //方式二:
    
//    KSGuaidManager.shouldDismissWhenDragging = YES;
    
    [KSGuaidManager begin];
}
@end
