//
//  DetailTableViewController.h
//  ShippApp2
//
//  Created by codepro on 2014/11/17.
//  Copyright (c) 2014年 FutureUniversityHakodate. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailTableViewController : UITableViewController{
    NSString *semmsi;
    NSString *seimo;
    NSString *sename;
    NSString *secallsign;
    NSString *selat60;
    NSString *selon60;
    NSString *sespeed;
    NSString *secourse;
    //NSString *slength;
    //NSString *swidth;
    //NSString *sflag;
    NSString *setime;
}

@property (nonatomic)NSString *semmsi;
@property (nonatomic)NSString *seimo;
@property (nonatomic)NSString *sename;
@property (nonatomic)NSString *secallsign;
@property (nonatomic)NSString *selat60;
@property (nonatomic)NSString *selon60;
@property (nonatomic)NSString *sespeed;
@property (nonatomic)NSString *secourse;
@property (nonatomic)NSString *setime;


@end
