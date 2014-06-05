//
//  WaterFlowViewController.m
//  MySamples
//
//  Created by 南部 祐耶 on 2014/06/02.
//  Copyright (c) 2014年 南部 祐耶. All rights reserved.
//

#import "WaterFlowViewController.h"

#import "Utilities.h"
#import "TMPhotoQuiltViewCell.h"



@interface WaterFlowViewController ()
{
    
    TMQuiltView *quiltView_;
    NSMutableArray *imageList_;
    
    
}

@end

@implementation WaterFlowViewController

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
    
    // quiltview
    quiltView_ = [[TMQuiltView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    quiltView_.dataSource = self;
    quiltView_.delegate = self;
    
    [self.view addSubview:quiltView_];
    
    [self setImageList];
    [quiltView_ reloadData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -

- (void)setImageList
{
    if (!imageList_) {
        imageList_ = [[NSMutableArray alloc] init];
    }
    
    for (int i = 0; i < 30; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",i % 10 + 1]];
        double d = 155.5 / image.size.width;
        image = [Utilities resizeimage:image ratio:d];
        [imageList_ addObject:image];
    }
    
    imageList_ = [[Utilities shuffleArray:imageList_] mutableCopy];
    
}





#pragma mark - TMQuiltView DataSource

- (NSInteger)quiltViewNumberOfCells:(TMQuiltView *)TMQuiltView
{
    
    return [imageList_ count];
    
}


- (TMQuiltViewCell *)quiltView:(TMQuiltView *)quiltView cellAtIndexPath:(NSIndexPath*)indexPath
{
    
    TMPhotoQuiltViewCell *cell = (TMPhotoQuiltViewCell *)[quiltView dequeueReusableCellWithReuseIdentifier:@"PhotoCell"];
    if (!cell) {
        cell = [[TMPhotoQuiltViewCell alloc] initWithReuseIdentifier:@"PhotoCell"];
    }
    
    
    // 画像の大きさを自動調整
    cell.photoView.image = [imageList_ objectAtIndex:indexPath.row];
    cell.titleLabel.text = [NSString stringWithFormat:@"%d",indexPath.row + 1];
    
    return cell;
    
}



#pragma mark - TMQuiltView Delegate

- (void)quiltView:(TMQuiltView *)quiltView didSelectCellAtIndexPath:(NSIndexPath *)indexPath
{
    
	NSLog(@"index:%d",indexPath.row);
    
}

// Must return a number of column greater than 0. Otherwise a default value is used.
- (NSInteger)quiltViewNumberOfColumns:(TMQuiltView *)quiltView
{
    return 2;
}

// Must return margins for all the possible values of TMQuiltViewMarginType. Otherwise a default value is used.
- (CGFloat)quiltViewMargin:(TMQuiltView *)quilView marginType:(TMQuiltViewMarginType)marginType
{
    
    return 3.0f;
    
}

// Must return the height of the requested cell
- (CGFloat)quiltView:(TMQuiltView *)quiltView heightForCellAtIndexPath:(NSIndexPath *)indexPath
{
    UIImage *image = [imageList_ objectAtIndex:indexPath.row];
    return image.size.height;
    
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
