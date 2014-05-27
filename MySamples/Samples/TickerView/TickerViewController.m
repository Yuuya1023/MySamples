//
//  TickerViewController.m
//  MySamples
//
//  Created by 南部 祐耶 on 2014/05/26.
//  Copyright (c) 2014年 南部 祐耶. All rights reserved.
//

#import "TickerViewController.h"
#import "TickerView.h"



@interface TickerViewController ()
{
    
    TickerView *ticker1_;
    TickerView *ticker2_;
}


@end

@implementation TickerViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor grayColor]];

    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    {
        if (!ticker1_) {
            ticker1_ = [[TickerView alloc] initWithFrame:CGRectMake(0, 100, 320, 40)];
            [ticker1_ setBackgroundColor:[UIColor whiteColor]];
            
            [self.view addSubview:ticker1_];
        }
    }
    {
        if (!ticker2_) {
            ticker2_ = [[TickerView alloc] initWithFrame:CGRectMake(0, 200, 160, 40)];
            [ticker2_ setBackgroundColor:[UIColor whiteColor]];
            
            [self.view addSubview:ticker2_];
        }
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    {
        [ticker1_ startAnimation];
        [ticker2_ startAnimation];
    }
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
