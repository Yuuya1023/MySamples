//
//  ImageScrollView.m
//  MySamples
//
//  Created by 南部 祐耶 on 2014/05/23.
//  Copyright (c) 2014年 南部 祐耶. All rights reserved.
//

#import "ImageScrollView.h"
#import "UIScrollView+TouchEvent.h"

#define PAGE_CONTROL_HEIGHT 15.0f

@interface ImageScrollView () {
    
    UIScrollView *scrollView_;
    UIPageControl *pageControl_;
    
    /// 総ページ数
    NSUInteger pageCount_;
    /// 現在表示しているページ
    NSUInteger currentPage_;
    /// 1ページのサイズ
    float pageSize_;
    
    /// 自動スクロールの有効/無効
    BOOL isAutoScrollEnable_;
    /// 自動スクロールのためのタイマー
    NSTimer *autoScrollTimer_;
    /// 自動スクロールをする規定時間
    int autoScrollTimeCount_;
    /// タイマーカウントアップカウント
    float timerCount_;
    /// 自動スクロール時のスクロール時間
    float autoScrollDuration_;
    
    /// タッチ後に動いたかどうか
    BOOL isTouchesMoved_;
    
    /// ページごとのviewを格納する
    NSMutableArray *pageContainerArray_;
    
    /// ページのタッチ有効/無効
    BOOL isPageTouchEnable_;
    
}
@end



@implementation ImageScrollView
@synthesize isAutoScrollEnable = isAutoScrollEnable_;
@synthesize autoScrollDuration = autoScrollDuration_;
@synthesize autoScrollTimeCount = autoScrollTimeCount_;
@synthesize isPageTouchEnable = isPageTouchEnable_;


#pragma mark - Init

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.userInteractionEnabled = YES;
        
        scrollView_ = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        scrollView_.delegate = self;
        scrollView_.showsHorizontalScrollIndicator = NO;
        scrollView_.showsVerticalScrollIndicator = NO;
        scrollView_.pagingEnabled = YES;
//        scrollView_.userInteractionEnabled = YES;
//        scrollView_.exclusiveTouch = YES;
//        scrollView_.canCancelContentTouches = YES;
//        scrollView_.delaysContentTouches = YES;
        [self addSubview:scrollView_];
        
        // デフォルト値
        {
            isAutoScrollEnable_ = YES;
            autoScrollTimeCount_ = 4.0f;
            currentPage_ = 1;
            autoScrollDuration_ = 0.5f;
            
            isPageTouchEnable_ = YES;
        }
        
        pageContainerArray_ = [[NSMutableArray alloc] init];
        
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame imageFiles:(NSArray *)imageFiles
{
    self = [self initWithFrame:frame]; //[super initWithFrame:frame];
    if (self) {
        // ページ生成
        pageCount_ = [imageFiles count];
        pageSize_ = frame.size.width;
        scrollView_.contentSize = CGSizeMake(frame.size.width * pageCount_, frame.size.height);
        
        for (int i = 0; i < pageCount_; i++) {
            UIImage *image = [UIImage imageNamed:[imageFiles objectAtIndex:i]];

            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
            imageView.frame = CGRectMake(i * pageSize_, 0, pageSize_, frame.size.height - PAGE_CONTROL_HEIGHT);
            
            [pageContainerArray_ addObject:imageView];
            [scrollView_ addSubview:imageView];
        }
        
        [self createPageControl];
        
        if (isAutoScrollEnable_ && !pageCount_ != 1) {
            [self initTimer];
        }
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame imageFiles:(NSArray *)imageFiles enablePageControl:(BOOL)enablePageControl
{
    
    self = [self initWithFrame:frame]; //[super initWithFrame:frame];
    if (self) {
        // ページ生成
        pageCount_ = [imageFiles count];
        pageSize_ = frame.size.width;
        scrollView_.contentSize = CGSizeMake(frame.size.width * pageCount_, frame.size.height);
        
        float pageControllHeight = 0.0f;
        if (enablePageControl) {
            pageControllHeight = PAGE_CONTROL_HEIGHT;
        }
        
        for (int i = 0; i < pageCount_; i++) {
            UIImage *image = [UIImage imageNamed:[imageFiles objectAtIndex:i]];
            
            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
            imageView.frame = CGRectMake(i * pageSize_, 0, pageSize_, frame.size.height - pageControllHeight);
            
            [pageContainerArray_ addObject:imageView];
            [scrollView_ addSubview:imageView];
        }
        
        if (enablePageControl) {
            [self createPageControl];
        }
        
        if (isAutoScrollEnable_ && !pageCount_ != 1) {
            [self initTimer];
        }
        
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame views:(NSArray *)views
{
    self = [self initWithFrame:frame]; //[super initWithFrame:frame];
    if (self) {
        // ページ生成
        pageCount_ = [views count];
        pageSize_ = frame.size.width;
        scrollView_.contentSize = CGSizeMake(frame.size.width * pageCount_, frame.size.height);
        
        for (int i = 0; i < pageCount_; i++) {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(i * pageSize_, 0, pageSize_, frame.size.height - PAGE_CONTROL_HEIGHT)];
            [view addSubview:[views objectAtIndex:i]];
            
            [pageContainerArray_ addObject:view];
            [scrollView_ addSubview:view];
        }
        
        [self createPageControl];
        
        if (isAutoScrollEnable_ && !pageCount_ != 1) {
            [self initTimer];
        }
        
    }
    return self;
}


#pragma mark - Setter

- (void)setAutoScrollEnable:(BOOL)b
{
    
    isAutoScrollEnable_ = b;
    if (isAutoScrollEnable_) {
        [self initTimer];
    }
    else{
        if (autoScrollTimer_) {
            [autoScrollTimer_ invalidate];
        }
    }
    
}

#pragma mark - 

- (void)createPageControl
{
    
    if (!pageControl_) {
        pageControl_ = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height - PAGE_CONTROL_HEIGHT, pageSize_, PAGE_CONTROL_HEIGHT)];
        [self addSubview:pageControl_];
    }
    
    pageControl_.numberOfPages = pageCount_;
    
}




#pragma mark - Timer

/// タイマー生成
- (void)initTimer
{
//    NSLog(@"initTimer");
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
//    NSLog(@"doTimer %f",timerCount_);
    if (++timerCount_ > autoScrollTimeCount_) {
        // カウントを初期化
        timerCount_ = 0.0f;
        
        // 自動スクロール
        float moveToX = scrollView_.contentOffset.x + pageSize_;
        ++currentPage_;
        if (moveToX >= pageSize_ * pageCount_) {
            moveToX = 0.0f;
            currentPage_ = 1;
        }
        [pageControl_ setCurrentPage:currentPage_ - 1];
        
//        NSLog(@"currentPage -> %d",currentPage_);
        
        // 早さ指定できない
//        [scrollView_ setContentOffset:CGPointMake(moveToX, 0) animated:YES];
        // できる
        [UIView animateWithDuration:autoScrollDuration_
                         animations:^(void) {
            scrollView_.contentOffset = CGPointMake(moveToX, 0);
        }];
    }
}


#pragma mark - ScrollView Delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
    if (isAutoScrollEnable_) {
        // タッチされたらカウントを初期化
        timerCount_ = 0.0f;
        [autoScrollTimer_ invalidate];
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    NSLog(@"scrollViewDidScroll");
    // 横スクロールのみに制限
    [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, 0)];
    
    if (isAutoScrollEnable_) {
        if (![autoScrollTimer_ isValid]) {
            // タイマー再開
            [self initTimer];
        }
    }

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
//    NSLog(@"scrollViewDidEndDecelerating");
    currentPage_ = (NSUInteger)(scrollView.contentOffset.x / scrollView.bounds.size.width) + 1;
    [pageControl_ setCurrentPage:currentPage_ - 1];
//    NSLog(@"currentPage -> %d",currentPage_);
}





#pragma mark - Touches

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
//    NSLog(@"touchesBegan");
    
    if (!isPageTouchEnable_) return;
    
    isTouchesMoved_ = NO;
    if (isAutoScrollEnable_) {
        [autoScrollTimer_ invalidate];
    }
    
    // viewを選択されている状態に
    [self viewSelected];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
//    NSLog(@"touchesMoved");
    
    if (!isPageTouchEnable_) return;
    
    isTouchesMoved_ = YES;
    
    // viewが選択されていない状態に
    [self viewDeselected];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
//    NSLog(@"touchesEnded");
    
    if (!isPageTouchEnable_) return;
    
    if (isAutoScrollEnable_) {
        [self initTimer];
    }
    
    // viewが選択されていない状態に
    [self viewDeselected];
    
    // タッチが動いていなければタップ時の処理を行う
    if (!isTouchesMoved_) {
        NSLog(@"do something.");
        
    }
    
    
}


#pragma mark - Effect

- (void)viewSelected
{
    UIView *view = [pageContainerArray_ objectAtIndex:currentPage_ - 1];
    if (view) {
        view.alpha = 0.4f;
    }
}

- (void)viewDeselected
{
    UIView *view = [pageContainerArray_ objectAtIndex:currentPage_ - 1];
    if (view) {
        view.alpha = 1.0f;
    }
}


#pragma mark -

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
