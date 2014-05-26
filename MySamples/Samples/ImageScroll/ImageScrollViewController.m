//
//  ImageScrollViewController.m
//  MySamples
//
//  Created by 南部 祐耶 on 2014/05/23.
//  Copyright (c) 2014年 南部 祐耶. All rights reserved.
//

#import "ImageScrollViewController.h"

#import "ImageScrollView.h"



@interface ImageScrollViewController ()

@end

@implementation ImageScrollViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    
    // 画像ファイル名を渡す
    {
        NSArray *arr = [[NSArray alloc] initWithObjects:
                        @"banner1.jpg",
                        @"banner2.jpg",
                        @"banner3.jpg",
                        @"banner4.jpg",
                        @"banner5.jpg",
                        nil];
        
        ImageScrollView *imageScroll = [[ImageScrollView alloc] initWithFrame:CGRectMake(0, 100, 320, 100)
                                                                   imageFiles:arr];
        [self.view addSubview:imageScroll];
    }
    
    
    // Viewを渡す
    {
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        {
            for (int i = 0; i < 4; i++) {
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 300, 20)];
                label.text = [NSString stringWithFormat:@"%dページ",i + 1];
                label.backgroundColor = [UIColor blueColor];
                [view addSubview:label];
                
                [arr addObject:view];
            }
        }

        ImageScrollView *imageScroll = [[ImageScrollView alloc] initWithFrame:CGRectMake(0, 250, 320, 100)
                                                                        views:arr];
        [imageScroll setBackgroundColor:[UIColor blackColor]];
        [imageScroll setAutoScrollTimeCount:1];
        [imageScroll setAutoScrollDuration:1.0f];
//        [imageScroll setPageTouchEnable:NO];
        [self.view addSubview:imageScroll];
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
