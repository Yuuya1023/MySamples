//
//  TickerView.m
//  MySamples
//
//  Created by 南部 祐耶 on 2014/05/26.
//  Copyright (c) 2014年 南部 祐耶. All rights reserved.
//

#import "TickerView.h"

@interface TickerView () {
    
    UIScrollView *animationView_;
    
    ///
    float frameX_;
    
    ///
    float size_;
    
    ///
    float movePace_;
    
    ///
    float animationDelay_;
    
    /// 表示フォント
    UIFont *textFont_;
    
    /// テキスト間の幅
    float textMargin_;
    
    /// アニメーションが開始されているか
    BOOL isStartedAnimation_;
    
}

@end
@implementation TickerView

#pragma mark - Init

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        NSArray *arr = [NSArray arrayWithObjects:
                        @"アングル：タイ軍政にソーシャルメディアで抗戦、市民らデモ継続",
                        @"ユニチカが金融支援を要請、優先株発行で370億円調達 ",
                        @"タイ国王、プラユット陸軍司令官の指導者就任を正式に承認",
                        @"リバウンドの株高・円安継続、欧州懸念浮上で持続性には疑問も",
                        @"ドル101円後半、材料乏しくレンジ内で",
                        @"ハイテク企業、自前のプログラミング学校開設（ウォール・ストリート・ジャーナル）",
                        @"アップルの開発者会議、今年の目玉は？―6月2日開幕（ウォール・ストリート・ジャーナル）",
                        @"販売ツールとしての香りの利用 食べ物以外でも（ウォール・ストリート・ジャーナル）",
                        nil];
        
        animationDelay_ = 1.0f;
        movePace_ = 60.0f;
        frameX_ = frame.size.width;
        textFont_ = [UIFont fontWithName:@"Helvetica-Bold"size:25];
        textMargin_ = 10.0f;
        isStartedAnimation_ = NO;
        
        
        // 横に長いviewを作成
        [self createViewWithFrame:frame stringArray:arr];
        
    }
    return self;
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
        NSLog(@"textSize %@",NSStringFromCGSize(textSize));
        
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
                         [targetView removeFromSuperview];
                         [self nextView];
                     }];
}


- (void)nextView
{
    
    UIScrollView *copyView = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:animationView_]];
    
    [self addSubview:copyView];
    
    [UIView animateWithDuration:0.5f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^(void) {
                         // 新規viewを初期位置までアニメーション
                         copyView.contentOffset = CGPointMake(frameX_, 0);
                     } completion:^(BOOL finished) {
                         // 新規viewを自動スクロール
                         [self startAutoScroll:copyView];
                     }];
}


#pragma mark - Public Method

- (void)startAnimation
{
    
    if (!isStartedAnimation_) {
        isStartedAnimation_ = YES;
        UIScrollView *copyView = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:animationView_]];
        copyView.contentOffset = CGPointMake(frameX_, copyView.contentOffset.y);
        [self addSubview:copyView];
        
        // スクロール開始
        [self startAutoScroll:copyView];
    }
    
}


- (void)stopAnimation
{
    
    
    
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
