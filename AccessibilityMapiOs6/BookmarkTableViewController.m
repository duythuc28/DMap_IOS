//
//  TableViewController.m
//  MapGoogle
//
//  Created by apple on 9/23/14.
//  Copyright (c) 2014 apple. All rights reserved.
//

#import "BookmarkTableViewController.h"
#import "Location.h"
#import "ViewController.h"
#import "MainViewController.h"
#import "PlaceInfoCell.h"
@interface BookmarkTableViewController ()<UISearchBarDelegate , UIAlertViewDelegate>
{
    NSMutableArray *searchResult;
    bool isDelete;
}
@end

@implementation BookmarkTableViewController

- (void)viewDidLoad
{
    /* End of add the search Bar */
    searchResult = [[NSMutableArray alloc] init];
    [super viewDidLoad];
    self.data       = [[Location getBookmarkedData] mutableCopy];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    searchResult = [self.data mutableCopy];

    /* Add the search bar */
    [self callSearchBar];
}

-(void)callSearchBar{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(53, 0, screenWidth-53-53, 44)];
    self.searchBar.delegate = self;
    self.navigationItem.titleView = self.searchBar;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [searchResult count];
}

- (CGFloat)calculateHeightForConfiguredSizingCell:(UITableViewCell *)sizingCell {
    [sizingCell layoutIfNeeded];
    
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    static PlaceInfoCell *cell = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        cell = [self.tableView dequeueReusableCellWithIdentifier:@"PlaceInfoCell"];
    });
    if ([searchResult count]) {
        Location * location = [searchResult objectAtIndex:indexPath.row];
        [cell setUpCellWithPlace:location];
    }
    
    return [self calculateHeightForConfiguredSizingCell:cell];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"PlaceInfoCell";
    PlaceInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if ([searchResult count]) {
        Location * location = [searchResult objectAtIndex:indexPath.row];
        [cell setUpCellWithPlace:location];
    }
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];

    
    if([title isEqualToString:@"Có"])
    {

    }
    
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Thông báo"
//                                                      message:@"Bạn có muốn xoá dữ liệu ?"
//                                                     delegate:self
//                                            cancelButtonTitle:@"Thoát"
//                                            otherButtonTitles:@"Có", nil];
//    [message show];
    
    Location* bookmark = (Location*) [searchResult objectAtIndex:indexPath.row];
    [Location removeBookmarkTheMarker:bookmark];
    [searchResult removeObjectAtIndex:indexPath.row];
    
    [tableView reloadData];
}

/*
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    Location* bookmark = (Location*) [searchResult objectAtIndex:indexPath.row];
    MainViewController* mainView = (MainViewController*)self.container;
    ViewController*     mapView  = (ViewController*)mainView._mapViewController;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [mapView updateCamWithLocation:bookmark];
    });
}


// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if([searchText length] == 0){
        searchResult = [[NSMutableArray alloc] initWithArray:self.data];
        return;
    }
    
    searchText = [searchText lowercaseString];
    searchResult = (NSMutableArray *)[Location getLocationByName:searchText];
    [self.tableView reloadData ]; 
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.searchBar resignFirstResponder];
}


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
