//
//  MyTableViewCell.h
//  MySamples
//
//  Created by 南部 祐耶 on 2014/05/29.
//  Copyright (c) 2014年 南部 祐耶. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTableViewCell : UITableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier url:(NSURL *)url func:(void (^)(UIImage *image, UITableViewCell *cell))func;



@end
