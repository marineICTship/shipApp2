//
//  CustomOverlay.m
//  ShippApp2
//
//  Created by codepro on 2014/11/15.
//  Copyright (c) 2014年 FutureUniversityHakodate. All rights reserved.
//

#import "CustomOverlay.h"


@implementation CustomOverlay

@synthesize lineWidth,strokeColor;


- (id)initWithstroke:(float)nlineWidth newstrokeColor:(UIColor *)sc{
    self = [super self];
    
    if(self != nil){
        lineWidth = nlineWidth;
        strokeColor = sc;
        
    }
    
    return self;
    
}
@end
