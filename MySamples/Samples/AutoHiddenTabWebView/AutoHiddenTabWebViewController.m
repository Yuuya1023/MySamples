//
//  AutoHiddenTabWebViewController.m
//  MySamples
//
//  Created by 南部 祐耶 on 2014/06/04.
//  Copyright (c) 2014年 南部 祐耶. All rights reserved.
//

#import "AutoHiddenTabWebViewController.h"

#import "AutoHiddenTabWebView.h"


@interface AutoHiddenTabWebViewController ()

@end

@implementation AutoHiddenTabWebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    AutoHiddenTabWebView *view = [[AutoHiddenTabWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:view];
    
    NSURL *url = [[NSURL alloc] initWithString:@"http://eightfor.tumblr.com"];
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:url];
    [view loadRequest:req];
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
