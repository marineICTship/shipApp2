//
//  CustomOverlay.m
//  ShippApp2
//
//  Created by codepro on 2014/11/15.
//  Copyright (c) 2014年 FutureUniversityHakodate. All rights reserved.
//

#import "CustomOverlay.h"


@implementation CustomOverlay

@synthesize linecoord,lineWidth,strokeColor,number;


- (id)initWithCoordinates:(CLLocationCoordinate2D)lc initWithstroke:(float)nlineWidth newstrokeColor:(UIColor *)sc newcount:(int) cn{
    self = [super self];
    
    if(self != nil){
        linecoord = lc;
        lineWidth = nlineWidth;
        strokeColor = sc;
        number = cn;
    }
    
    return self;
    
}
@end
