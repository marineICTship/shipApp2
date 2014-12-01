//
//  AMSlideMenuLeftViewController.h
//  ShippApp2
//
//  Created by codepro on 2014/11/29.
//  Copyright (c) 2014年 FutureUniversityHakodate. All rights reserved.
//

#import "ViewController.h"
#import <UIKit/UIKit.h>

@class AMSlideMenuMainViewController;

@interface AMSlideMenuLeftViewController : ViewController<UISearchDisplayDelegate>

@property (weak, nonatomic) AMSlideMenuMainViewController *mainVC;
@property (nonatomic)NSMutableArray *shipnamearray;

// Only afor non storyboard use
- (void)openContentNavigationController:(UINavigationController *)nvc;

@property (strong, nonatomic) IBOutlet UISearchBar *SearchBar;

@end
