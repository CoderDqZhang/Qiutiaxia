//
//  NSStringAdditions.h
//  Touqiu
//
//  Created by Zhang on 2019/5/9.
//  Copyright © 2019 com.touqiu.touqiu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NSStringAdditions)
    
+ (NSString *) base64StringFromData:(NSData *)data length:(int)length;
    
@end
