//
//  TickerView.m
//  MySamples
//
//  Created by 南部 祐耶 on 2014/05/26.
//  Copyright (c) 2014年 南部 祐耶. All rights reserved.
//

// TODO: スクロールの早さを厳密に調整出来るようにする


#import "TickerView.h"
#import <QuartzCore/QuartzCore.h>


#define MAX_TEXT_SIZE CGSizeMake(2048, 1024)

@interface TickerView () {
    
    UIScrollView *animationView_;
    
    /// 参照用
    UIScrollView *tempView_;
    
    /// 文字列配列
    NSArray *stringList_;
    
    /// スクロールのタイプ
    enum TickerScrollType scrollType_;
    
    /// アニメーション対象のViewの長さ
    float size_;
    
    /// アニメーションの動く早さ
    float animationSpeed_;
    
    /// アニメーション開始までの遅延時間
    float animationDelay_;
    
    /// 表示フォント
    UIFont *textFont_;
    
    /// フォントカラー
    UIColor *fontColor_;
    
    /// テキスト間の幅
    float textMargin_;
    
    /// アニメーションが開始されているか
    BOOL isStartedAnimation_;
    
    /// ポーズ状態かどうか
    BOOL isPaused_;
    
    
    // 一個づつスクロールするパターン
    /// 表示中のインデックス
    int displayIndex_;
    
    /// view格納用の配列
    NSMutableArray *viewList_;
    
    /// ボタン
    UIButton *button_;
    
    
}

@end
@implementation TickerView

#pragma mark - Init

- (id)initWithFrame:(CGRect)frame
        stringArray:(NSArray *)array
               font:(UIFont *)font
          fontColor:(UIColor *)fontColor
              speed:(float)speed
         textMargin:(float)margin
              delay:(float)delay
         scrollType:(enum TickerScrollType)type
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        scrollType_ = type;
        animationDelay_ = delay;
        animationSpeed_ = speed;
        textFont_ = font;
        fontColor_ = fontColor;
        textMargin_ = margin;
        
        isStartedAnimation_ = NO;
        isPaused_ = NO;
        displayIndex_ = 0;
        stringList_ = [[NSArray alloc] initWithArray:array];
        viewList_ = [[NSMutableArray alloc] init];
        
        
        [self createViewWithFrame:frame stringArray:array];
        
        // ホームに一旦戻ってしまうとanimationWithDurationが終わるので再開させる
        [NOTIF_CENTER addObserver:self
                         selector:NSSelectorFromString(@"restartAnimation")
                             name:NOTIF_NAME_APPLICATION_WILL_ENTER_FOREGROUND
                           object:nil];
        
        // 一個づつスクロールする場合はボタンを用意する
        if (scrollType_ == TickerScrollTypeSingle) {
            if (!button_) {
                button_ = [UIButton buttonWithType:UIButtonTypeCustom];
                button_.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
                [button_ addTarget:self action:NSSelectorFromString(@"tickerTouched:") forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:button_];
            }
        }
    }
    return self;
    
}


- (id)initWithFrame:(CGRect)frame stringArray:(NSArray *)array
{
    return [self initWithFrame:frame
                   stringArray:array
                          font:kTickerFont
                     fontColor:kTickerFontColor
                         speed:kTickerAnimationSpeed
                    textMargin:kTickerTextMargin
                         delay:kTickerAnimationDelay
                    scrollType:kTickerScrollType];
}



#pragma mark - UIView

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
//    NSLog(@"willMoveToSuperview");
    
    [self startAnimation];
    
}


- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
//    NSLog(@"didMoveToSuperview");
    
}


- (void)removeFromSuperview
{
    [super removeFromSuperview];
//    NSLog(@"removeFromSuperview");
    
    
}



#pragma mark -

- (void)createViewWithFrame:(CGRect)frame stringArray:(NSArray *)arr
{
    
    int arrayCount = [arr count];

    switch (scrollType_) {
        case TickerScrollTypeRange:
        {
            // テキストの配置
            size_ = frame.size.width;
            animationView_ = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
            for (int i = 0; i < arrayCount; i++) {
                // テキストの長さを取得
                NSString *text = [arr objectAtIndex:i];
                CGSize textSize = [self calcTextSize:text].size;
                //        NSLog(@"textSize %@",NSStringFromCGSize(textSize));
                
                // ラベルの作成
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(size_, frame.size.height / 2 - textSize.height / 2, textSize.width, textSize.height)];
                label.font = textFont_;
                label.text = text;
                label.textColor = fontColor_;
                [animationView_ addSubview:label];
                
                size_ += textSize.width + textMargin_;
                
            }
            
            animationView_.contentSize = CGSizeMake(size_, frame.size.height);
        }
            break;
            
        case TickerScrollTypeSingle:
        {
            for (int i = 0; i < arrayCount; i++) {
                // 文字列の大きさ取得
                NSString *text = [arr objectAtIndex:i];
                CGSize textSize = [self calcTextSize:text].size;
                
                // viewの生成
                UIScrollView *view = [[UIScrollView alloc] init];
                view.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
                view.contentSize = CGSizeMake(frame.size.width + textSize.width, frame.size.height);
                
                // ラベルの生成
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width, frame.size.height / 2 - textSize.height / 2, textSize.width, textSize.height)];
                label.font = textFont_;
                label.text = text;
                label.textColor = fontColor_;
                [view addSubview:label];
                
                [viewList_ addObject:view];
            }
        }
            break;
        default:
            break;
    }
}


- (void)startAutoScroll:(UIScrollView *)targetView
{
    
//    NSLog(@"startAutoScroll");
    
    float moveToX = 0.0f;
    float moveToY = 0.0f;
    float delay = animationDelay_;
    
    switch (scrollType_) {
        case TickerScrollTypeRange:
        {
            moveToX = size_;
        }
            break;
            
        case TickerScrollTypeSingle:
        {
            moveToX = targetView.contentSize.width;
            delay = 0.0f;   // 遅延を発生させない
        }
            break;
            
        default:
            break;
    }
    
    // 自動スクロール
    double d = moveToX / animationSpeed_;
    [UIView animateWithDuration:d
                          delay:delay
                        options:UIViewAnimationOptionCurveLinear
                     animations:^(void) {
                         targetView.contentOffset = CGPointMake(moveToX, moveToY);
                     } completion:^(BOOL finished) {
                         if (finished) {
                             [targetView removeFromSuperview];
                             [self nextView];
                         }
                     }];
    
}


- (void)nextView
{
//    NSLog(@"nextView");
    
    switch (scrollType_) {
        case TickerScrollTypeRange:
        {
            tempView_ = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:animationView_]];
            
            [self addSubview:tempView_];
            
            [UIView animateWithDuration:0.5f
                                  delay:0.0f
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^(void) {
                                 // 新規viewを初期位置までアニメーション
                                 tempView_.contentOffset = CGPointMake(self.frame.size.width, 0);
                             } completion:^(BOOL finished) {
                                 if (finished) {
                                     // 新規viewを自動スクロール
                                     [self startAutoScroll:tempView_];
                                 }
                             }];
        }
            break;
            
        case TickerScrollTypeSingle:
        {
            ++displayIndex_;
            if (displayIndex_ >= [viewList_ count]) displayIndex_ = 0;
            
            UIScrollView *sv = [viewList_ objectAtIndex:displayIndex_];
            tempView_ = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:sv]];
            
            [self addSubview:tempView_];
            [self bringSubviewToFront:button_];
            [self startAutoScroll:tempView_];
        }
            break;
            
        default:
            break;
    }
}


#pragma mark - Public Method

- (void)startAnimation
{
    
    if (!isStartedAnimation_) {
        isStartedAnimation_ = YES;
        
        switch (scrollType_) {
            case TickerScrollTypeRange:
            {
                tempView_ = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:animationView_]];
                [self addSubview:tempView_];
                tempView_.contentOffset = CGPointMake(self.frame.size.width, tempView_.contentOffset.y);
            }
                break;
                
            case TickerScrollTypeSingle:
            {
                UIScrollView *sv = [viewList_ objectAtIndex:0];
                tempView_ = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:sv]];
                [self addSubview:tempView_];
                [self bringSubviewToFront:button_];
            }
                break;
                
            default:
                break;
        }
        
        // スクロール開始
        [self startAutoScroll:tempView_];
    }
    
}


- (void)restartAnimation
{
    
    isStartedAnimation_ = NO;
    if (tempView_) {
        [tempView_ removeFromSuperview];
    }
    
    [self startAnimation];
    
}


- (void)pauseAnimation
{
    
    if (!isPaused_) {
        isPaused_ = YES;
        CFTimeInterval pausedTime = [tempView_.layer convertTime:CACurrentMediaTime() fromLayer:nil];
        tempView_.layer.speed = 0.0f;
        tempView_.layer.timeOffset = pausedTime;
    }
    
}


- (void)resumeAnimation
{
    
    if (isPaused_) {
        isPaused_ = NO;
        CFTimeInterval pausedTime = [tempView_.layer timeOffset];
        tempView_.layer.speed = 1.0;
        tempView_.layer.timeOffset = 0.0;
        tempView_.layer.beginTime = 0.0;
        CFTimeInterval timeSincePause = [tempView_.layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
        tempView_.layer.beginTime = timeSincePause;
    }
    
}



#pragma mark -

- (void)tickerTouched:(UIButton *)b
{
    
    NSLog(@"touched index->%d, text->%@",displayIndex_, [stringList_ objectAtIndex:displayIndex_]);
    
}



#pragma mark - 

- (CGRect)calcTextSize:(NSString *)text
{
    return [text boundingRectWithSize:MAX_TEXT_SIZE
                              options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                           attributes:@{NSFontAttributeName:textFont_}
                              context:nil];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
