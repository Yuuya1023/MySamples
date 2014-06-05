//
//  AutoHiddenTabWebView.m
//  MySamples
//
//  Created by 南部 祐耶 on 2014/06/04.
//  Copyright (c) 2014年 南部 祐耶. All rights reserved.
//

#import "AutoHiddenTabWebView.h"

#define OFFSET_MARGIN 30.0f
#define SLIDE_ANIMATION_DURATION 0.2f

@interface AutoHiddenTabWebView () {

    /// Webview
    UIWebView *webview_;
    /// タブスライド用の親view
    UIView *slideView_;
    /// 読み込み画面
    UIView *loadingView_;
    /// 進むボタン
    UIBarButtonItem *nextButton_;
    /// 戻るボタン
    UIBarButtonItem *backButton_;
    
    /// 初期化時のサイズ
    CGSize frame_;
    /// スクロール開始位置
    float scrollStartOffsetY_;
    
}
@end

@implementation AutoHiddenTabWebView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        frame_ = frame.size;
        webview_ = [[UIWebView alloc] initWithFrame:frame];
        webview_.delegate = self;
        webview_.scrollView.delegate = self;
        [self addSubview:webview_];
        
        // 読み込み画面
        {
            loadingView_ = [[UIView alloc] initWithFrame:frame];
            loadingView_.backgroundColor = [UIColor blackColor];
            loadingView_.alpha = 0.0;
            
            UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
            indicator.center = loadingView_.center;
            [indicator startAnimating];
            [loadingView_ addSubview:indicator];
            [self addSubview:loadingView_];
        }
        
        // ツールバー
        {
            slideView_ = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height - TOOLBAR_H, frame.size.width, TOOLBAR_H)];
            [self addSubview:slideView_];
            
            UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, TOOLBAR_H)];
//            toolbar.barStyle = UIBarStyleBlack;
            [slideView_ addSubview:toolbar];
        
            backButton_ = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"]
                                                           style:UIBarButtonItemStylePlain
                                                          target:self
                                                          action:NSSelectorFromString(@"back")];
            nextButton_ = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"next"]
                                                           style:UIBarButtonItemStylePlain
                                                          target:self
                                                          action:NSSelectorFromString(@"next")];
            UIBarButtonItem *spacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                       target:nil action:nil];
            UIBarButtonItem *updateButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"update"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:NSSelectorFromString(@"reload")];
            toolbar.items = @[backButton_, nextButton_, spacer, updateButton];
            
            backButton_.enabled = NO;
            nextButton_.enabled = NO;
        }
        
    }
    return self;
}


#pragma mark -

- (void)loadRequest:(NSURLRequest *)request
{
    [webview_ loadRequest:request];
}

- (void)back
{
    [webview_ goBack];
}

- (void)next
{
    [webview_ goForward];
}

- (void)reload
{
    [webview_ reload];
}


#pragma mark - UIWebview Delegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
//    NSLog(@"webViewDidStartLoad");
    loadingView_.alpha = 0.6f;
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
//    NSLog(@"webViewDidFinishLoad");
    loadingView_.alpha = 0.0f;
//    [self showToolbar:NO];
    
    backButton_.enabled = webview_.canGoBack;
    nextButton_.enabled = webview_.canGoForward;
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
//    NSLog(@"didFailLoadWithError");
    loadingView_.alpha = 0.0f;
    
    
}



#pragma mark - UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
//    NSLog(@"scrollViewDidScroll %f ,%f",scrollView.contentSize.height - self.frame.size.height,scrollView.contentOffset.y);
    
    float maxContentOffsetY = scrollView.contentSize.height - self.frame.size.height;
    float currentOffsetY = scrollView.contentOffset.y;
    
    // 最下部だった場合強制的にタブを出すのでwebviewを小さくする
    if (maxContentOffsetY - OFFSET_MARGIN <= currentOffsetY) {
        // タブ表示
        [self showToolbar:YES];
    }
    else{
        if (currentOffsetY == 0) {
            // 最上部なのでタブ表示
            [self showToolbar:NO];
        }
        else if (scrollStartOffsetY_ > currentOffsetY){
            // 上部へスクロールしているので表示
            [self showToolbar:NO];
        }
        else{
            // たぶん下にスクロールしている
            [self hideToolbar];
        }
    }
    
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
//    NSLog(@"scrollViewWillBeginDragging");
    scrollStartOffsetY_ = scrollView.contentOffset.y;
}



#pragma mark -

- (void)showToolbar:(BOOL)isBottom
{
    if (slideView_.frame.origin.y == self.frame.size.height - TOOLBAR_H || webview_.loading) return;
    
//    NSLog(@"+++++++");
    [UIView animateWithDuration:SLIDE_ANIMATION_DURATION
                     animations:^(void) {
                         [slideView_ setFrame:CGRectMake(0, self.frame.size.height - TOOLBAR_H, self.frame.size.width, self.frame.size.height)];
                         if (isBottom) {
                             // 最下部の時は同時に小さくする
                             [webview_ setFrame:CGRectMake(0, 0, frame_.width, frame_.height - TOOLBAR_H)];
                         }
                     }];
}


- (void)hideToolbar
{
    if (slideView_.frame.origin.y == self.frame.size.height || webview_.loading) return;
    
//    NSLog(@"-------");
    [UIView animateWithDuration:SLIDE_ANIMATION_DURATION
                     animations:^(void) {
                         [slideView_ setFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height)];
                         // 大きさを戻す
                         [webview_ setFrame:CGRectMake(0, 0, frame_.width, frame_.height)];
                     }];
}


@end
