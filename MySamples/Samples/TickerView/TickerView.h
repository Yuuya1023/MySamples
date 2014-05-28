//
//  TickerView.h
//  MySamples
//
//  Created by 南部 祐耶 on 2014/05/26.
//  Copyright (c) 2014年 南部 祐耶. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kTickerFont [UIFont fontWithName:@"Helvetica-Bold"size:12]
#define kTickerAnimationSpeed 40.0f
#define kTickerAnimationDelay 1.0f
#define kTickerTextMargin 10.0f

@interface TickerView : UIView

/// デフォルト値で初期化
- (id)initWithFrame:(CGRect)frame stringArray:(NSArray *)array;
/// プロパティを指定して初期化
- (id)initWithFrame:(CGRect)frame stringArray:(NSArray *)array font:(UIFont *)font speed:(float)speed textMargin:(float)margin delay:(float)delay;

/// アニメーションやりなおし
- (void)restartAnimation;
/// アニメーション一時停止
- (void)pauseAnimation;
/// アニメーション再開
- (void)resumeAnimation;




@end
