//
//  AppDelegate.m
//  ShippApp2
//
//  Created by codepro on 2014/11/14.
//  Copyright (c) 2014年 FutureUniversityHakodate. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate


@synthesize AlphaJugde;

- (NSArray*)ColorArray {
    UIColor *c0,*c1,*c2,*c3,*c4,*c5,*c6,*c7,*c8,*c9,*c10,*c11,*c12,*c13,*c14,*c15,*c16,*c17,*c18,*c19,
    *c20,*c21,*c22,*c23,*c24,*c25,*c26,*c27,*c28;
    
    c0 = [UIColor colorWithRed:1.00 green:1.00 blue:0.00 alpha:*(AlphaJugde)];//ID0 海苔ヒビ 黄色(255,255,0)
    c1 = [UIColor colorWithRed:1.00 green:0.00 blue:0.00 alpha:1.0];//ID1 浮標 アイコン(赤(255,0,0)),01漁船
    c2 = [UIColor colorWithRed:0.00 green:1.00 blue:0.00 alpha:1.0];//02漁船
    c3 = [UIColor colorWithRed:0.20 green:0.60 blue:1.00 alpha:*(AlphaJugde)];//03漁船
    c4 = [UIColor colorWithRed:1.00 green:1.00 blue:0.00 alpha:1.0];//04漁船
    c5 = [UIColor colorWithRed:1.00 green:0.00 blue:1.00 alpha:1.0];//05漁船
    c6 = [UIColor colorWithRed:0.00 green:1.00 blue:1.00 alpha:1.0];//06漁船
    c7 = [UIColor colorWithRed:1.00 green:0.40 blue:0.00 alpha:1.0];//07漁船
    c8 = [UIColor colorWithRed:0.00 green:0.80 blue:0.20 alpha:1.0];//08漁船
    c9 = [UIColor colorWithRed:0.00 green:0.80 blue:1.00 alpha:1.0];//09漁船
    c10 = [UIColor colorWithRed:0.94 green:0.90 blue:0.55 alpha:1.0];//10漁船
    c11 = [UIColor colorWithRed:0.60 green:0.40 blue:1.00 alpha:1.0];//11漁船
    c12 = [UIColor colorWithRed:0.00 green:0.40 blue:0.60 alpha:1.0];//12漁船
    c13 = [UIColor colorWithRed:1.00 green:0.20 blue:0.40 alpha:1.0];//13漁船
    c14 = [UIColor colorWithRed:0.00 green:0.60 blue:0.20 alpha:1.0];//14漁船
    c15 = [UIColor colorWithRed:0.00 green:0.40 blue:0.80 alpha:1.0];//15漁船
    c16 = [UIColor colorWithRed:1.00 green:0.80 blue:0.00 alpha:1.0];//16漁船
    c17 = [UIColor colorWithRed:0.60 green:0.00 blue:1.00 alpha:1.0];//17漁船
    c18 = [UIColor colorWithRed:1.00 green:0.60 blue:0.80 alpha:1.0];//18漁船
    c19 = [UIColor colorWithRed:0.60 green:0.00 blue:0.00 alpha:1.0];//19漁船
    c20 = [UIColor colorWithRed:0.00 green:0.40 blue:0.40 alpha:1.0];//20漁船
    c21 = [UIColor colorWithRed:0.60 green:1.00 blue:0.80 alpha:1.0];//21漁船
    c22 = [UIColor colorWithRed:0.50 green:0.50 blue:0.00 alpha:1.0];//22漁船
    c23 = [UIColor colorWithRed:0.80 green:0.52 blue:0.25 alpha:1.0];//22漁船
    c24 = [UIColor colorWithRed:0.78 green:0.08 blue:0.52 alpha:1.0];//23漁船
    c25 = [UIColor colorWithRed:1.00 green:1.00 blue:1.00 alpha:1.0];//ID2 白(255,255,255)
    c26 = [UIColor colorWithRed:0.00 green:0.00 blue:0.00 alpha:1.0];//ID3 防波堤 黒(0,0,0)
    c27 = [UIColor colorWithRed:0.20 green:0.60 blue:1.00 alpha:1.0];//ID4 等深線 水色(51,158,255)
    c28 = [UIColor colorWithRed:0.20 green:0.80 blue:1.00 alpha:1.0];//ID5 メッシュチャート (51,204,255)
    
    NSArray *ColorArray = [NSArray arrayWithObjects:c0,c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,c15,c16,c17,c18,c19,c20,c21,c22,c23,c24,c25,c26,c27,c28,nil];
    //NSArray *ColorArray = [NSArray arrayWithObjects:c0,c1,c2,c3,nil];
    return ColorArray;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
