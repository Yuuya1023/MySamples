//
//  Utilities.m
//  MySamples
//
//  Created by 南部 祐耶 on 2014/05/28.
//  Copyright (c) 2014年 南部 祐耶. All rights reserved.
//

#import "Utilities.h"

@implementation Utilities


+ (NSArray *)shuffleArray:(NSArray *)array
{
    
    NSMutableArray* temp = [NSMutableArray arrayWithArray:array];
    
    int count = [temp count];
    
    for (int i = 0; i < count; i++) {
        
        int index1 = i % [temp count];
        int index2 = arc4random() % [temp count];
        
        if (index1 != index2) {
            [temp exchangeObjectAtIndex:index1 withObjectAtIndex:index2];
        }
        
    }
    return temp;
}


+ (void)showDefaultAlertWithTitle:(NSString *)title message:(NSString *)message
{
    UIAlertView *alert =
    [[UIAlertView alloc] initWithTitle:title
                               message:message
                              delegate:self
                     cancelButtonTitle:nil
                     otherButtonTitles:@"OK", nil];
    [alert show];
}


+ (UIImage *)resizeimage:(UIImage *)image ratio:(double)ratio
{
    UIImage *resImage;
    
    CGSize sz = CGSizeMake(image.size.width * ratio,
                           image.size.height * ratio);
    UIGraphicsBeginImageContext(sz);
    [image drawInRect:CGRectMake(0, 0, sz.width, sz.height)];
    resImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resImage;
}


@end
