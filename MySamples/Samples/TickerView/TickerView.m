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

@interface TickerView () {
    
    UIScrollView *animationView_;
    
    /// 参照用
    UIScrollView *tempView_;
    
    /// アニメーション対象のViewの長さ
    float size_;
    
    /// アニメーションの動く早さ
    float movePace_;
    
    /// アニメーション開始までの遅延時間
    float animationDelay_;
    
    /// 表示フォント
    UIFont *textFont_;
    
    /// テキスト間の幅
    float textMargin_;
    
    /// アニメーションが開始されているか
    BOOL isStartedAnimation_;
    
    /// ポーズ状態かどうか
    BOOL isPaused_;
    
}

@end
@implementation TickerView
//@synthesize isStartedAnimation = isStartedAnimation_;

#pragma mark - Init

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        animationDelay_ = 1.0f;
        movePace_ = 60.0f;
        textFont_ = [UIFont fontWithName:@"Helvetica-Bold"size:18];
        textMargin_ = 10.0f;
        isStartedAnimation_ = NO;
        isPaused_ = NO;
        
        // ホームに一旦戻ってしまうとanimationWithDurationが終わるので再開させる
        [NOTIF_CENTER addObserver:self
                         selector:NSSelectorFromString(@"restartAnimation")
                             name:NOTIF_NAME_APPLICATION_WILL_ENTER_FOREGROUND
                           object:nil];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame stringArray:(NSArray *)array
{
    self = [self initWithFrame:frame];
    if (self) {
        
        [self createViewWithFrame:frame stringArray:array];
        
    }
    return self;
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
    
    // 文字列の長さ取得のための変数
    CGSize bounds = CGSizeMake(2048, 1024);
//    NSLineBreakMode mode = NSLineBreakByWordWrapping;
    
    // テキストの配置
    size_ = frame.size.width;
    animationView_ = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    for (int i = 0; i < [arr count]; i++) {
        // テキストの長さを取得
        NSString *text = [arr objectAtIndex:i];
//        CGSize textSize = [text sizeWithFont:textFont_ forWidth:bounds.width lineBreakMode:mode];
        CGRect textRect = [text boundingRectWithSize:bounds
                                                 options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                              attributes:@{NSFontAttributeName:textFont_}
                                                 context:nil];
        CGSize textSize = textRect.size;
//        NSLog(@"textSize %@",NSStringFromCGSize(textSize));
        
        // ラベルの作成
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(size_, frame.size.height / 2 - textSize.height / 2, textSize.width, textSize.height)];
        label.font = textFont_;
        label.text = text;
        label.textColor = RGB(arc4random() % 255, arc4random() % 255, arc4random() % 255); // ランダム
        [animationView_ addSubview:label];
        
        size_ += textSize.width + textMargin_;
        
    }
    
    animationView_.contentSize = CGSizeMake(size_, frame.size.height);
//    animationView_.contentOffset = CGPointMake(0, 0);
}



- (void)startAutoScroll:(UIScrollView *)targetView
{
    
//    NSLog(@"startAutoScroll");
    // 新規viewを自動スクロール
    float moveToX = size_;
    float moveToY = 0;//targetView.contentOffset.y;
    double d = moveToX / movePace_;
    [UIView animateWithDuration:d
                          delay:animationDelay_
                        options:UIViewAnimationOptionCurveLinear
                     animations:^(void) {
                         targetView.contentOffset = CGPointMake(moveToX, moveToY);
                     } completion:^(BOOL finished) {
//                         NSLog(@"%@",NSStringFromCGPoint(targetView.contentOffset));
                         if (finished) {
//                             NSLog(@"scroll finish.");
                             [targetView removeFromSuperview];
                             [self nextView];
                         }
                     }];
}


- (void)nextView
{
    NSLog(@"nextView");
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


#pragma mark - Public Method

- (void)startAnimation
{
    
    if (!isStartedAnimation_) {
        isStartedAnimation_ = YES;
        tempView_ = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:animationView_]];
        [self addSubview:tempView_];
        tempView_.contentOffset = CGPointMake(self.frame.size.width, tempView_.contentOffset.y);
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


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
