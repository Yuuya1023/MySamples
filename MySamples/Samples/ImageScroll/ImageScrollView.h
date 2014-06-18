//
//  ImageScrollView.h
//  MySamples
//
//  Created by 南部 祐耶 on 2014/05/23.
//  Copyright (c) 2014年 南部 祐耶. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageScrollView : UIView<UIScrollViewDelegate>


- (id)initWithFrame:(CGRect)frame imageFiles:(NSArray *)imageFiles;
- (id)initWithFrame:(CGRect)frame imageFiles:(NSArray *)imageFiles enablePageControl:(BOOL)enablePageControl;

- (id)initWithFrame:(CGRect)frame views:(NSArray *)views;





/// 自動スクロールの有効/無効
@property(nonatomic, setter = setAutoScrollEnable:) BOOL isAutoScrollEnable;
/// 自動スクロールをする規定時間
@property(nonatomic) int autoScrollTimeCount;
/// 自動スクロール時のスクロール時間
@property(nonatomic) float autoScrollDuration;

/// ページのタッチ有効/無効
@property(nonatomic, setter = setPageTouchEnable:) BOOL isPageTouchEnable;






@end
