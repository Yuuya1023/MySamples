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

- (id)init
{
    
    self = [super init];
    if (self) {
    

        
    }
    
    return self;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    ImageScrollView *imageScroll = [[ImageScrollView alloc] initWithFrame:CGRectMake(0, 100, 320, 100)];
    [self.view addSubview:imageScroll];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
