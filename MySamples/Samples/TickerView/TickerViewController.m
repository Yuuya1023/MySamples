//
//  TickerViewController.m
//  MySamples
//
//  Created by 南部 祐耶 on 2014/05/26.
//  Copyright (c) 2014年 南部 祐耶. All rights reserved.
//

#import "TickerViewController.h"

#import "Utilities.h"


@interface TickerViewController ()
{
    
    TickerView *ticker1_;
    TickerView *ticker2_;
    TickerView *ticker3_;
    TickerView *ticker4_;
}


@end

@implementation TickerViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor grayColor]];

    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame = CGRectMake(170, 30, 50, 100);
        [button addTarget:self action:NSSelectorFromString(@"pause:") forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"pause" forState:UIControlStateNormal];
        [self.view addSubview:button];
    }
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame = CGRectMake(230, 30, 70, 100);
        [button addTarget:self action:NSSelectorFromString(@"resume:") forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"resume" forState:UIControlStateNormal];
        [self.view addSubview:button];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSArray *arr = [NSArray arrayWithObjects:
                    @"アングル：タイ軍政にソーシャルメディアで抗戦、市民らデモ継続",
                    @"ユニチカが金融支援を要請、優先株発行で370億円調達 ",
                    @"タイ国王、プラユット陸軍司令官の指導者就任を正式に承認",
                    @"リバウンドの株高・円安継続、欧州懸念浮上で持続性には疑問も",
                    @"ドル101円後半、材料乏しくレンジ内で",
                    @"ハイテク企業、自前のプログラミング学校開設（ウォール・ストリート・ジャーナル）",
                    @"アップルの開発者会議、今年の目玉は？―6月2日開幕（ウォール・ストリート・ジャーナル）",
                    @"販売ツールとしての香りの利用 食べ物以外でも（ウォール・ストリート・ジャーナル）",
                    nil];
    arr = [Utilities shuffleArray:arr];
    
    {
        if (ticker1_) {
            [ticker1_ removeFromSuperview];
        }
        ticker1_ = [[TickerView alloc] initWithFrame:CGRectMake(0, 100, 320, 40) stringArray:arr];
        [ticker1_ setBackgroundColor:[UIColor whiteColor]];
        
        [self.view addSubview:ticker1_];
        
    }
    {
        if (ticker2_) {
            [ticker2_ removeFromSuperview];
        }
        ticker2_ = [[TickerView alloc] initWithFrame:CGRectMake(0, 150, 160, 40) stringArray:arr];
        [ticker2_ setBackgroundColor:[UIColor whiteColor]];
        
        [self.view addSubview:ticker2_];
    }
    
    NSArray *arr2 = [NSArray arrayWithObjects:
                     @"Squeeze",
                     @"PUNISHER",
                     @"Engraved Mark",
                     @"Stella Sinistra",
                     @"Last Dance",
                     nil];
    arr2 = [Utilities shuffleArray:arr2];
    
    {
        if (ticker3_) {
            [ticker3_ removeFromSuperview];
        }
        ticker3_ = [[TickerView alloc] initWithFrame:CGRectMake(0, 200, 320, 25)
                                         stringArray:arr2
                                                font:[UIFont fontWithName:@"GillSans" size:20]
                                           fontColor:kTickerFontColor
                                               speed:70.0f
                                          textMargin:30.0f
                                               delay:2.0f
                                          scrollType:TickerScrollTypeSingle];
        ticker3_.delegate = self;
        [ticker3_ setBackgroundColor:[UIColor whiteColor]];
        
        [self.view addSubview:ticker3_];
    }
    {
        if (ticker4_) {
            [ticker4_ removeFromSuperview];
        }
        ticker4_ = [[TickerView alloc] initWithFrame:CGRectMake(0, 235, 160, 25)
                                         stringArray:arr2
                                                font:[UIFont fontWithName:@"GillSans" size:10]
                                           fontColor:[UIColor redColor]
                                               speed:20.0f
                                          textMargin:10.0f
                                               delay:0.0f
                                          scrollType:TickerScrollTypeSingle];
        ticker4_.delegate = self;
        [ticker4_ setBackgroundColor:[UIColor whiteColor]];
        
        [self.view addSubview:ticker4_];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
}

- (void)pause:(UIButton *)b{
    
    [ticker1_ pauseAnimation];
    [ticker2_ pauseAnimation];
    [ticker3_ pauseAnimation];
    [ticker4_ pauseAnimation];
}

- (void)resume:(UIButton *)b{
    
    [ticker1_ resumeAnimation];
    [ticker2_ resumeAnimation];
    [ticker3_ resumeAnimation];
    [ticker4_ resumeAnimation];
}


#pragma mark - TickerView Delegate

- (void)tickerViewDidTouched:(TickerView *)tickerView pageIndex:(int)pageIndex
{
    NSLog(@"tickerViewDidTouched %d",pageIndex);
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
