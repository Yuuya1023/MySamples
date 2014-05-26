//
//  TickerView.m
//  MySamples
//
//  Created by 南部 祐耶 on 2014/05/26.
//  Copyright (c) 2014年 南部 祐耶. All rights reserved.
//

#import "TickerView.h"

@interface TickerView () {
    
    UIView *animationView_;
    
    ///
    double size_;
    
    ///
    double movePace_;
    
    ///
    double animationDelay_;
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
//                        @"ドル101円後半、材料乏しくレンジ内で",
//                        @"ハイテク企業、自前のプログラミング学校開設（ウォール・ストリート・ジャーナル）",
//                        @"アップルの開発者会議、今年の目玉は？―6月2日開幕（ウォール・ストリート・ジャーナル）",
//                        @"販売ツールとしての香りの利用 食べ物以外でも（ウォール・ストリート・ジャーナル）",
                        nil];
        
        animationDelay_ = 1.0f;
        movePace_ = 60.0f;
        
        // 簡易版
        {
            // 横に長いviewを作成
            [self createView:arr];
            
            UIView *copyView = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:animationView_]];
            [self addSubview:copyView];
            
            // スクロール開始
            [self startAutoScroll:copyView];

        }
        
//        float move = 50.0f;
//        
//
//        // 文字列の長さを取得
//        CGSize size;
//        {
//            size = [[arr objectAtIndex:0] sizeWithFont:font forWidth:bounds.width lineBreakMode:mode];
//            
//            // ラベル
//            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
//            label.text = (NSString *)[arr objectAtIndex:0];
//            
//            [self addSubview:label];
//            
//            NSLog(@"%@",[arr objectAtIndex:0]);
//            NSLog(@"%@",NSStringFromCGRect(label.frame));
//            
//            float d = size.width / move;
//            [UIView animateWithDuration:d
//                                  delay:0.0f
//                                options:UIViewAnimationOptionCurveLinear
//                             animations:^(void) {
//                                 label.frame = CGRectMake(- size.width, 0, size.width, size.height);
//                             } completion:^(BOOL finished) {
//                                 
//                             }];
//        }
//        
//        // 次に繋がるラベルを用意
//        CGSize size2;
//        {
//            size2 = [[arr objectAtIndex:1] sizeWithFont:font forWidth:bounds.width lineBreakMode:mode];
//            
//            // ラベル
//            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(size.width + 20, 0, size2.width, size2.height)];
//            label.text = (NSString *)[arr objectAtIndex:1];
//            
//            [self addSubview:label];
//            
//            NSLog(@"%@",[arr objectAtIndex:1]);
//            NSLog(@"%@",NSStringFromCGRect(label.frame));
//            
//            float d = (size2.width + size.width + 20) / move;
//            [UIView animateWithDuration:d
//                                  delay:0.0f
//                                options:UIViewAnimationOptionCurveLinear
//                             animations:^(void) {
//                                 label.frame = CGRectMake(-(size2.width + size.width + 20), 0, size2.width, size2.height);
//                             } completion:^(BOOL finished) {
//                                 
//                             }];
//        }
        
//        CGSize size3;
//        {
//            size3 = [[arr objectAtIndex:2] sizeWithFont:font forWidth:bounds.width lineBreakMode:mode];
//            
//            // ラベル
//            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(size.width + size2.width + 20, 0, size3.width, size3.height)];
//            label.text = (NSString *)[arr objectAtIndex:2];
//            
//            [self addSubview:label];
//            
//            
//            [UIView animateWithDuration:20
//                                  delay:0.0f
//                                options:UIViewAnimationOptionCurveLinear
//                             animations:^(void) {
//                                 label.frame = CGRectMake(label.frame.origin.x - 1024, 0, size3.width, size3.height);
//                             } completion:^(BOOL finished) {
//                                 
//                             }];
//        }
        
    }
    return self;
}


#pragma mark -

- (void)createView:(NSArray *)arr{
    
    // 文字列の長さ取得のための変数
    CGSize bounds = CGSizeMake(1024, 30);
    UIFont *font = [UIFont fontWithName:@"Helvetica-Bold"size:18];
    NSLineBreakMode mode = NSLineBreakByCharWrapping;
    
    size_ = 0.0f;
    animationView_ = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    for (int i = 0; i < [arr count]; i++) {
        NSString *text = [arr objectAtIndex:i];
        CGSize textSize = [text sizeWithFont:font forWidth:bounds.width lineBreakMode:mode];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(size_, 0, textSize.width, textSize.height)];
        label.text = text;
        [animationView_ addSubview:label];
        
        size_ += textSize.width;
        
    }
    
}



- (void)startAutoScroll:(UIView *)targetView
{
    
    // 新規viewを自動スクロール
    double moveToX = size_;
    double d = moveToX / movePace_;
    [UIView animateWithDuration:d
                          delay:animationDelay_
                        options:UIViewAnimationOptionCurveLinear
                     animations:^(void) {
                         targetView.frame = CGRectMake(-moveToX, 0, 0, 0);
                     } completion:^(BOOL finished) {
                         NSLog(@"scroll finish");
                         [targetView removeFromSuperview];
                         [self nextView];
                     }];
}


- (void)nextView
{
    
    UIView *copyView = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:animationView_]];
    copyView.frame = CGRectMake(self.bounds.size.width, 0, 0, 0);
    
    [self addSubview:copyView];
    
    [UIView animateWithDuration:0.5f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^(void) {
                         // 新規viewを初期位置までアニメーション
                         copyView.frame = CGRectMake(0, 0, 0, 0);
                     } completion:^(BOOL finished) {
                         // 新規viewを自動スクロール
                         [self startAutoScroll:copyView];
                     }];
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
