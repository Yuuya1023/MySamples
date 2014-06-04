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
    
    /// 初期化時のサイズ
    CGSize frame_;
    
    ///
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
        webview_.scrollView.delegate = self;
        [self addSubview:webview_];
        
        slideView_ = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height - TOOLBAR_H, frame.size.width, TOOLBAR_H)];
        [self addSubview:slideView_];
        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [slideView_ addSubview:toolbar];
        
    }
    return self;
}


#pragma mark -

- (void)loadRequest:(NSURLRequest *)request
{
    [webview_ loadRequest:request];
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
    
    NSLog(@"scrollViewWillBeginDragging");
    scrollStartOffsetY_ = scrollView.contentOffset.y;
    
    
}


#pragma mark -

- (void)showToolbar:(BOOL)isBottom
{
    if (slideView_.frame.origin.y == self.frame.size.height - TOOLBAR_H) return;
    
    NSLog(@"+++++++");
    [UIView animateWithDuration:SLIDE_ANIMATION_DURATION
                     animations:^(void) {
//                         CGRectMake(0, frame.size.height - TOOLBAR_H, frame.size.width, TOOLBAR_H)
                         [slideView_ setFrame:CGRectMake(0, self.frame.size.height - TOOLBAR_H, self.frame.size.width, self.frame.size.height)];
                         if (isBottom) {
                             // 最下部の時は同時に小さくする
                             [webview_ setFrame:CGRectMake(0, 0, frame_.width, frame_.height - TOOLBAR_H)];
                         }
                     }];
}


- (void)hideToolbar
{
    if (slideView_.frame.origin.y == self.frame.size.height) return;
    
    NSLog(@"-------");
    [UIView animateWithDuration:SLIDE_ANIMATION_DURATION
                     animations:^(void) {
                         [slideView_ setFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height)];
                         // 大きさを戻す
                         [webview_ setFrame:CGRectMake(0, 0, frame_.width, frame_.height)];
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
