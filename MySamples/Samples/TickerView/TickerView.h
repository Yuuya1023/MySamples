//
//  TickerView.h
//  MySamples
//
//  Created by 南部 祐耶 on 2014/05/26.
//  Copyright (c) 2014年 南部 祐耶. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TickerView : UIView


//@property(nonatomic,readonly) BOOL isStartedAnimation;




- (id)initWithFrame:(CGRect)frame stringArray:(NSArray *)array;


//- (void)startAnimation;

- (void)pauseAnimation;
- (void)resumeAnimation;




@end
