//
//  DetailTableViewController.m
//  ShippApp2
//
//  Created by codepro on 2014/11/17.
//  Copyright (c) 2014年 FutureUniversityHakodate. All rights reserved.
//

#import "DetailTableViewController.h"

@interface DetailTableViewController ()

@end

@implementation DetailTableViewController
@synthesize  sename = sename;
@synthesize  setime = setime;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *reuseIdentifire = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifire];
    if( cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifire];
    }
    switch (indexPath.row) {
        case (0): //mmsi
            //cell.textLabel.text = [@"MMSI: " stringByAppendingString:semmsi];
            cell.textLabel.text = [@"MMSI: " stringByAppendingString:@"431001193"];
            break;
            
        case (1): //imo
            //cell.textLabel.text = [@"IMO番号: " stringByAppendingString:seimo];
            cell.textLabel.text = [@"IMO番号: " stringByAppendingString:@"9468380"];
            break;
            
        case (2): //name
            cell.textLabel.text = [@"船名: " stringByAppendingString:sename];
            break;
            
        case (3): //callsign
            //cell.textLabel.text = [@"コールサイン: " stringByAppendingString:secallsign];
            cell.textLabel.text = [@"コールサイン: " stringByAppendingString:@"JD3024"];
            break;
            
        case (4): //latitude
            //cell.textLabel.text = [@"緯度: " stringByAppendingString:selat60];
            cell.textLabel.text = [@"緯度: " stringByAppendingString:@"34°00b026.6335N"];
            break;
            
        case (5): //longtude
            //cell.textLabel.text = [@"経度: " stringByAppendingString:selon60];
            cell.textLabel.text = [@"経度: " stringByAppendingString:@"135\u00b011.1325E"];
            break;
            
        case (6): //sepeed
            //cell.textLabel.text = [@"対地速力: " stringByAppendingString:sespeed];
            cell.textLabel.text = [@"対地速力: " stringByAppendingString:@"10.7"];
            break;
            
        case (7): //course
            //cell.textLabel.text = [@"対地針路: " stringByAppendingString:secourse];
            cell.textLabel.text = [@"対地針路: " stringByAppendingString:@"35"];
            break;
            
        case (8): //timestamp
            //cell.textLabel.text = [@"受信時刻: " stringByAppendingString:setime];
            cell.textLabel.text = [@"受信時刻: " stringByAppendingString:@"2014/11/22 20:46:40"];
            break;
            
    }
    
    
    //文字の色
    //cell.textLabel.textColor = [UIColor brownColor];
    //文字サイズ
    cell.textLabel.font = [UIFont systemFontOfSize:30];
    //チェックマーク
    //cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    return cell;
}


//前の画面へ戻る
//[self dismissViewControllerAnimated:YES completion:NULL];

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
