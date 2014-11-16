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
}

@property (strong, nonatomic) IBOutlet MKMapView *myMapView;
@property (nonatomic)int colorjugde;

@end
