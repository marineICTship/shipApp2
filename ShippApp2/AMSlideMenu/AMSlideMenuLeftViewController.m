//
//  AMSlideMenuLeftViewController.m
//  ShippApp2
//
//  Created by codepro on 2014/11/29.
//  Copyright (c) 2014年 FutureUniversityHakodate. All rights reserved.
//

#import "AMSlideMenuLeftViewController.h"
#import "AMSlideMenuMainViewController.h"
#import "AMSlideMenuContentSegue.h"

@interface AMSlideMenuLeftViewController ()
@property (strong, nonatomic) NSArray *searchbar;


@end

@implementation AMSlideMenuLeftViewController
@synthesize SearchBar,shipnamearray;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)openContentNavigationController:(UINavigationController *)nvc
{
#ifdef AMSlideMenuWithoutStoryboards
    AMSlideMenuContentSegue *contentSegue = [[AMSlideMenuContentSegue alloc] initWithIdentifier:@"contentSegue" source:self destination:nvc];
    [contentSegue perform];
#else
    NSLog(@"This methos is only for NON storyboard use! You must define AMSlideMenuWithoutStoryboards \n (e.g. #define AMSlideMenuWithoutStoryboards)");
#endif
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(tableView == self.searchDisplayController.searchResultsTableView){
        return 157;
    }else{
        return 157;
    }
    
    
    //return 157;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *reuseIdentifire = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifire];
    if( cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifire];
    }
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ship" ofType:@"txt"];
    NSData *shipjson = [NSData dataWithContentsOfFile:path];
    NSDictionary *shipjsonobj = [NSJSONSerialization JSONObjectWithData:shipjson options:0 error:nil];
    

   
    //cell.textLabel.text = @"表示する文字";
    
    shipnamearray = [NSMutableArray array];
    
    
    /*if(tableView == self.searchDisplayController.searchResultsTableView){
        NSLog(@"od:%@",self.searchbar[0]);
        //cell.textLabel.text = [self.searchbar objectAtIndex:indexPath.row];
        //cell.textLabel.text = [[NSString alloc] initWithFormat:@"%@",self.searchbar[0]];
        
    }else{
        for (int i = 0;i < 156;i++) {
            NSString *name = (NSString*)shipjsonobj[@"ships"][i][@"Ship"][@"name"];
            [shipnamearray addObject:name];
            
            if(indexPath.row == i){

                //shipnamearray[i] = name;
                //cell.textLabel.text = [[NSString alloc] initWithFormat:@"%@",shipjsonobj[@"ships"][i][@"Ship"][@"name"]];
                cell.textLabel.text = [[NSString alloc] initWithFormat:@"%@",shipnamearray[i]];
                //NSLog(@"%@",shipnamearray[i]);
            }
        }

    }*/
    //cell.textLabel.text = [[NSString alloc] initWithFormat:@"%@",self.searchbar[0]];
    for (int i = 0;i < 157;i++) {
        NSString *name = (NSString*)shipjsonobj[@"ships"][i][@"Ship"][@"name"];
        [shipnamearray addObject:name];
        
        if(indexPath.row == i){
            
            //shipnamearray[i] = name;
            //cell.textLabel.text = [[NSString alloc] initWithFormat:@"%@",shipjsonobj[@"ships"][i][@"Ship"][@"name"]];
            cell.textLabel.text = [[NSString alloc] initWithFormat:@"%@",shipnamearray[i]];
            //NSLog(@"%@",shipnamearray[i]);
        }
    }

    //NSLog(@"str:%@",self.searchbar);
    
    

    
    //文字の色
    //cell.textLabel.textColor = [UIColor brownColor];
    //文字サイズ
    cell.textLabel.font = [UIFont systemFontOfSize:30];
    //チェックマーク
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    return cell;
}

-(void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF beginswith[c] %@",searchText];
    
    
    self.searchbar = [shipnamearray filteredArrayUsingPredicate:predicate];
    NSLog(@"str:%@",self.searchbar);
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    
    [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles]objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    return YES;
}



@end
