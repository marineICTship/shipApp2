//
//  ViewController.h
//  ShippApp2
//
//  Created by codepro on 2014/11/15.
//  Copyright (c) 2014年 FutureUniversityHakodate. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface ViewController : UIViewController{
    int colorjugde;
    double widthjugde;
    double aj;
    NSArray *shipinfo2;
    NSArray *shipinfo3;
    NSArray *EmptyArray;

}
extern NSString* const EmptyLetter;

@property (strong, nonatomic) IBOutlet MKMapView *myMapView;
@property (nonatomic)int colorjugde;
@property (nonatomic)double widthjugde;
@property (nonatomic)double aj;
@property (nonatomic)NSArray *shipinfo2;
@property (nonatomic)NSArray *shipinfo3;
@property (nonatomic)NSArray *EmptyArray;

@end
