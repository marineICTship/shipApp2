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
    CLLocationCoordinate2D linecoord;
    float lineWidth;
    UIColor *strokeColor;
    int number;
}

@property (nonatomic, readonly) CLLocationCoordinate2D linecoord;
@property (nonatomic)float lineWidth;;
@property (nonatomic)UIColor *strokeColor;
@property (nonatomic)int number;


- (id)initWithCoordinates:(CLLocationCoordinate2D)lc withstroke:(float)nlineWidth newstrokeColor:(UIColor *)sc newcount:(int) cn;

@end


