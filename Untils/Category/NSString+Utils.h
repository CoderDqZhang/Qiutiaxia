//
//  NSString+Utils.h
//  WeChatContacts-demo
//
//  Created by shen_gh on 16/3/12.
//  Copyright © 2016年 com.joinup(Beijing). All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Utils)

/**
 *  汉字的拼音
 *
 *  @return 拼音
 */
- (NSString *)pinyin;

+ (NSString*)DataTOjsonString:(id)object;

+ (id)DataToNSDiction:(id)object;
    
- (NSString *)urlEncode:(NSString *)url;

@end