//
//  Utilities.h
//  MySamples
//
//  Created by 南部 祐耶 on 2014/05/28.
//  Copyright (c) 2014年 南部 祐耶. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utilities : NSObject

/// 配列をシャッフル
+ (NSArray *)shuffleArray:(NSArray *)array;

/// 標準のアラート表示
+ (void)showDefaultAlertWithTitle:(NSString *)title message:(NSString *)message;



@end
