//
//  SearchTableViewController.m
//  MapGoogle
//
//  Created by apple on 9/22/14.
//  Copyright (c) 2014 apple. All rights reserved.
//

#import "SearchTableViewController.h"
#import "MainViewController.h"
#import "Location.h"
#import "ViewController.h"
#import "PlaceInfoCell.h"
@interface SearchTableViewController ()<UISearchBarDelegate>
{
    NSMutableArray *searchResult;
}

@end

@implementation SearchTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.data       = [[Location getAllData] mutableCopy];
    searchResult    = self.data;
    //[self performSelector:@selector(callSearchBar) withObject:nil afterDelay:0.01];
    [self callSearchBar];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

-(void)callSearchBar{
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(53, 0, SCREEN_WIDTH-53-53, 44)];
    self.searchBar.delegate = self;
    self.navigationItem.titleView = self.searchBar;
    [self.searchBar becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    //return self.data.count;
    return [searchResult count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"PlaceInfoCell";
    PlaceInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    [self setUpCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)setUpCell:(PlaceInfoCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Location * searchPlace = (Location *) [searchResult objectAtIndex:indexPath.row];
    cell.placeTitle.text  =  searchPlace.title;
    cell.placeDescription.text = searchPlace.address;
    cell.imageView.image = [LocationType getImageByLocationTypeId:[searchPlace.location_LocationType.locationTypeID intValue]];
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
    
    [self setUpCell:cell atIndexPath:indexPath];
    
    return [self calculateHeightForConfiguredSizingCell:cell];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    Location* bookmark = (Location*) [searchResult objectAtIndex:indexPath.row];
    MainViewController* mainView = (MainViewController*)self.container;
    ViewController*     mapView  = (ViewController*)mainView._mapViewController;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [mapView updateCamWithSearch: bookmark];
    });
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if([searchText length] == 0){
        searchResult = [[NSMutableArray alloc] initWithArray:self.data];
        [self.tableView reloadData ];
        return;
    }
    
    
    searchText = [searchText lowercaseString];
    searchResult = (NSMutableArray *)[Location getLocationByName:searchText];

    [self.tableView reloadData ];
}

@end
