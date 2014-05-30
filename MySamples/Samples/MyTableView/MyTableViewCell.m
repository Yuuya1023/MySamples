//
//  MyTableViewCell.m
//  MySamples
//
//  Created by 南部 祐耶 on 2014/05/29.
//  Copyright (c) 2014年 南部 祐耶. All rights reserved.
//

#import "MyTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>


@implementation MyTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier url:(NSURL *)url func:(void (^)(UIImage *image, UITableViewCell *cell))func
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [self addSubview:imageView];
        
        __block UIImageView *temp = imageView;
        [imageView setImageWithURL:url
                         completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                             if (!error) {
                                 // 画像のサイズ取得
                                 double d = self.frame.size.width / image.size.width;
                                 temp.frame = CGRectMake(0, 0, image.size.width * d, image.size.height * d);
                                 self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, image.size.width * d, image.size.height * d);
                                 func(image, self);
                             }
                             else{
                                 NSLog(@"error");
                             }
                         }];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
