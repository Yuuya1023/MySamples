//
//  ImageScrollView.m
//  MySamples
//
//  Created by 南部 祐耶 on 2014/05/23.
//  Copyright (c) 2014年 南部 祐耶. All rights reserved.
//

#import "ImageScrollView.h"


@interface ImageScrollView () {
    
    UIScrollView *scrollView_;
    
    /// 総ページ数
    int pageCount_;
    /// 現在表示しているページ
    int currentPage_;
    /// 1ページのサイズ
    float pageSize_;
    
    /// 自動スクロールのためのタイマー
    NSTimer *autoScrollTimer_;
    /// 自動更新をする規定時間
    float autoScrollTimeCount_;
    /// タイマーカウントアップカウント
    float timerCount_;
    
    
}
@end

@implementation ImageScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        scrollView_ = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        scrollView_.delegate = self;
        scrollView_.showsHorizontalScrollIndicator = NO;
        scrollView_.showsVerticalScrollIndicator = NO;
        scrollView_.pagingEnabled = YES;
        [self addSubview:scrollView_];
        
        autoScrollTimeCount_ = 4.0f;
        currentPage_ = 1;
        
        
        
        {
            // テスト
            scrollView_.contentSize = CGSizeMake(1280, frame.size.height);
            
            pageCount_ = 4;
            autoScrollTimeCount_ = 4.0f;
            pageSize_ = 320.0f;
            [self setBackgroundColor:[UIColor blackColor]];
            
            for (int i = 0; i < pageCount_; i++) {
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(i * pageSize_, 0, pageSize_, frame.size.height)];
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 300, 20)];
                label.text = [NSString stringWithFormat:@"%dページ",i + 1];
                label.backgroundColor = [UIColor blueColor];
                [view addSubview:label];
                [scrollView_ addSubview:view];
            }
        }
        

        [self initTimer];
        
    }
    return self;
}

#pragma mark - Timer

/// タイマー生成
- (void)initTimer
{
    NSLog(@"initTimer");
    timerCount_ = 0.0f;
    autoScrollTimer_ = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                        target:self
                                                      selector:@selector(doTimer:)
                                                      userInfo:nil
                                                       repeats:YES];
    
}

/// 1秒毎に呼ばれtimeCount_をカウントアップする
- (void)doTimer:(NSTimer *)timer
{
    NSLog(@"doTimer %f",timerCount_);
    if (timerCount_ > autoScrollTimeCount_) {
        // カウントを初期化
        timerCount_ = 0.0f;
        
        // 自動スクロール
        float moveToX = scrollView_.contentOffset.x + pageSize_;
        if (moveToX >= pageSize_ * pageCount_) {
            moveToX = 0.0f;
        }
        [UIView animateWithDuration:0.5f animations:^(void) {
            scrollView_.contentOffset = CGPointMake(moveToX, 0);
        }];
    }
    else{
        ++timerCount_;
    }
}


#pragma mark - ScrollView Delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
    // タッチされたらカウントを初期化
    timerCount_ = 0.0f;
    [autoScrollTimer_ invalidate];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 横スクロールのみに制限
    [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, 0)];
    
    if (![autoScrollTimer_ isValid]) {
        // タイマー再開
        [self initTimer];
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
