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


@end
