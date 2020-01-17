//
//  UIImage+PureColor.h
//  Kaoban
//
//  Created by Jane on 8/11/15.
//  Copyright (c) 2015 kaoban. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (PureColor)

+(UIImage *) getImageFromURL:(NSString *)fileURL;

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
+ (UIImage *) createImageWithColor: (UIColor *) color;

+ (UIImage *)coreBlurImage:(UIImage *)image withBlurNumber:(CGFloat)blur;
+ (UIImage *)boxblurImage:(UIImage *)image withBlurNumber:(CGFloat)blur;

+ (void)boxblurImage:(UIImage *)image;

+ (UIImage *)imageByApplyingAlpha:(CGFloat )alpha  image:(UIImage*)image;

+ (UIImage *)imageFromYData:(NSData *)data width:(uint)width height:(uint)height ;

@end
