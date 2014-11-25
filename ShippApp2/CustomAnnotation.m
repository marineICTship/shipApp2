//
//  CustomAnnotation.m
//  ShippApp2
//
//  Created by codepro on 2014/11/15.
//  Copyright (c) 2014年 FutureUniversityHakodate. All rights reserved.
//

#import "CustomAnnotation.h"

@implementation CustomAnnotation

@synthesize coordinate, title,subtitle,pinColor,img,shipinfo;

- (id)initWithCoordinates:(CLLocationCoordinate2D)co newTitle:(NSString *)t newSubTitle:(NSString *)st newimg:(UIImage *)nimg shipinfo:(NSArray *)si{
    self = [super self];
    
    if(self != nil)
    {
        coordinate = co;
        title = t;
        subtitle = st;
        //pinColor = *PC;
        img = nimg;
        shipinfo = si;
    }
    
    return self;
    
}

@end

