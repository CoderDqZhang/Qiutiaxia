//
//  YYTextBindManager.h
//  Touqiu
//
//  Created by Zhang on 2019/10/11.
//  Copyright © 2019 com.touqiu.touqiu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYText.h"

NS_ASSUME_NONNULL_BEGIN

@interface YYTextBindManager : NSObject<YYTextParser>

@property (nonatomic, strong) NSRegularExpression *regex;

@end

NS_ASSUME_NONNULL_END
