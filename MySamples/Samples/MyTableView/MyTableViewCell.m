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

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
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
