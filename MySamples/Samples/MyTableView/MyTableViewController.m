//
//  MyTableViewController.m
//  MySamples
//
//  Created by 南部 祐耶 on 2014/05/29.
//  Copyright (c) 2014年 南部 祐耶. All rights reserved.
//

#import "MyTableViewController.h"
#import "MyTableViewCell.h"

#import <SDWebImage/UIImageView+WebCache.h>

@interface MyTableViewController () {
    
    UITableView *tableView_;
    
    NSArray *urls_;
    NSMutableDictionary *images_;
}

@end

@implementation MyTableViewController

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
    
    float margin = NAVBAR_H + STATUSBAR_H;
    tableView_ = [[UITableView alloc] initWithFrame:CGRectMake(0, margin, self.view.frame.size.width, self.view.frame.size.height - margin)];
    tableView_.dataSource = self;
    tableView_.delegate = self;
//    [self.view addSubview:tableView_];
    
    
    // url
    urls_ = [[NSArray alloc] initWithObjects:
             [NSURL URLWithString:@"http://37.media.tumblr.com/a7cc332c124941ba23ff982fa80b7c1e/tumblr_n68n8wvyET1tuhj3jo1_500.png"],
             [NSURL URLWithString:@"http://24.media.tumblr.com/04d80d60d01c498f29e2982a9ed986bc/tumblr_n68n8ilgJh1tuhj3jo1_500.png"],
             [NSURL URLWithString:@"http://24.media.tumblr.com/3aba3faafa99b144c409e744facfd977/tumblr_n66r5s62R51tuhj3jo1_500.jpg"],
             [NSURL URLWithString:@"http://31.media.tumblr.com/530d036e4a086ec642019aa4f6f445a4/tumblr_n5ydcmoNaZ1sk0lj0o1_500.jpg"],
             [NSURL URLWithString:@"http://37.media.tumblr.com/d236b14fa1beb1ff5109261bba3b5393/tumblr_n5x4dtfLD31qb2kz6o1_500.jpg"],
             [NSURL URLWithString:@"http://37.media.tumblr.com/c5a43161502e9c2c2da6a557da7a3826/tumblr_n61875tdsC1tuhj3jo1_500.jpg"],
             [NSURL URLWithString:@"http://24.media.tumblr.com/6c3c7663cbf9781df488563b7bf545e0/tumblr_n617xfXdqV1tuhj3jo1_500.jpg"],
             [NSURL URLWithString:@"http://37.media.tumblr.com/24f26527da3ea81663099ae782cac9c5/tumblr_n617t4CEdy1tuhj3jo1_500.jpg"],
             [NSURL URLWithString:@"http://37.media.tumblr.com/d09e8901f03a5ed94e79493bf6ab477b/tumblr_n617kvQIFR1tuhj3jo1_500.jpg"],
             [NSURL URLWithString:@"http://37.media.tumblr.com/28703a1df99c63a3d9c552449c45877d/tumblr_n5zg3ndr3P1tuhj3jo1_500.png"],
             nil];
 
    images_ = [[NSMutableDictionary alloc] init];
    
    // SDWebImageで画像をダウンロードしておく
    __block int temp = 0;
    for (int i = 0; i < [urls_ count]; i++) {
        UIImageView *imageV = [[UIImageView alloc] init];
        [self.view addSubview:imageV];
        [imageV setImageWithURL:[urls_ objectAtIndex:i]
                      completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                          if (!error) {
                              NSURL *url =[urls_ objectAtIndex:i];
                              [images_ setObject:image forKey:[NSString stringWithFormat:@"%@",[url absoluteString]]];
                              
                              if (temp == [urls_ count] - 1) {
                                  [self.view addSubview:tableView_];
                              }
                              
                              temp++;
                          }
                      }];
    }
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [urls_ count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSURL *url = [urls_ objectAtIndex:indexPath.row];
    NSString *CellIdentifier = [url absoluteString];
    MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier
                                                  url:[urls_ objectAtIndex:indexPath.row]
                                                 func:^(UIImage *image, UITableViewCell *cell) {
        }];
    }

    return cell;
}



#pragma mark -

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSURL *url = [urls_ objectAtIndex:indexPath.row];
    if (!url) return 0;
    
    UIImage *image = [images_ objectForKey:[url absoluteString]];
    double d = self.view.frame.size.width / image.size.width;
    
    return image.size.height * d;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}



@end
