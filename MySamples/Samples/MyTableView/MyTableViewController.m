//
//  MyTableViewController.m
//  MySamples
//
//  Created by 南部 祐耶 on 2014/05/29.
//  Copyright (c) 2014年 南部 祐耶. All rights reserved.
//

#import "MyTableViewController.h"
#import "MyTableViewCell.h"


@interface MyTableViewController () {
    
    UITableView *tableView_;
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
    
    // テーブル
    tableView_ = [[UITableView alloc] initWithFrame:self.view.bounds];
    tableView_.dataSource = self;
    tableView_.delegate = self;
    [self.view addSubview:tableView_];
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
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = @"cell";
    return cell;
}



#pragma mark -




@end
