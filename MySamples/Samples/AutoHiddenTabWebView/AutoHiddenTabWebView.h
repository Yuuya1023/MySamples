//
//  AutoHiddenTabWebView.h
//  MySamples
//
//  Created by 南部 祐耶 on 2014/06/04.
//  Copyright (c) 2014年 南部 祐耶. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AutoHiddenTabWebView : UIView < UIScrollViewDelegate, UIWebViewDelegate >

- (void)loadRequest:(NSURLRequest *)request;

@end
