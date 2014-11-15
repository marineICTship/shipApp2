//
//  CustomOverlay.h
//  ShippApp2
//
//  Created by codepro on 2014/11/15.
//  Copyright (c) 2014年 FutureUniversityHakodate. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


@interface CustomOverlay : NSObject <MKOverlay> {
    float lineWidth;
    UIColor *strokeColor;
}

@property (nonatomic)float lineWidth;;
@property (nonatomic)UIColor *strokeColor;


- (id)initWithstroke:(float)nlineWidth newstrokeColor:(UIColor *)sc;

@end


