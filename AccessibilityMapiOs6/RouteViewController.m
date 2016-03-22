//
//  RouteViewController.m
//  MapGoogle
//
//  Created by Hackintosh on 10/3/14.
//  Copyright (c) 2014 apple. All rights reserved.
//

#import "RouteViewController.h"
#import "MainViewController.h"
#import "Location.h"
#import "ViewController.h"
#import "TableViewCell.h"
#import "MDDirectionService.h"
#import "SubAcViewController.h"
#import "Reachability.h"
#import "CustomMarker.h"
#import "LocalizeHelper.h"
#import <QuartzCore/QuartzCore.h>
#import "Utils.h"
@interface RouteViewController ()
{
    NSMutableArray *searchResult;
    NSString *latLocation1;
    NSString *latLocation2;
    NSString *longLocation1;
    NSString *longLocation2;
}

@end

@implementation RouteViewController
{
NSMutableArray *waypoints_;
NSMutableArray *waypointStrings_;
bool isBus ;
bool isStartSearch;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [Utils checkInternetConnection];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.StartSearch.attributedPlaceholder = [[NSAttributedString alloc] initWithString:LocalizedString(@"From Place")];
    self.EndSearch.attributedPlaceholder = [[NSAttributedString alloc] initWithString:LocalizedString(@"To Place")];
    [self.findRouteButton setTitle:LocalizedString(@"Routes")];
    self.data       = [[Location getAllData] mutableCopy];
    searchResult    = self.data;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.StartSearch.delegate = self;
    self.EndSearch.delegate= self;
    self.StartSearch.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.EndSearch.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.StartSearch becomeFirstResponder];
    
    waypoints_ = [[NSMutableArray alloc]init];
    waypointStrings_ = [[NSMutableArray alloc]init];
    isBus = FALSE;
}

-(void)back
{
    //[redSC removeFromSuperview];
    [self.navigationController popToRootViewControllerAnimated:YES];
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
    return [searchResult count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* SimpleIdentifier = @"SimpleIdentifier";
    TableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:SimpleIdentifier];
    Location* bookmark = (Location*) [searchResult objectAtIndex:indexPath.row];
    
    if(cell == nil){
        cell = [[TableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SimpleIdentifier];
    }
    cell._title.text = bookmark.title;
    cell.address.text = bookmark.address;
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    Location* bookmark = (Location*) [searchResult objectAtIndex:indexPath.row];
    if (self.StartSearch.isFirstResponder || isStartSearch == false)
    {
        self.StartSearch.text = bookmark.title;
        latLocation1 = bookmark.latitude;
        longLocation1 = bookmark.longtitude;
        
    }
    else if (self.EndSearch.isFirstResponder || isStartSearch == true)
    {
        self.EndSearch.text = bookmark.title;
        latLocation2 = bookmark.latitude;
        longLocation2 = bookmark.longtitude;
    }
    
}

#pragma TextField Methods


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.StartSearch resignFirstResponder];
    [self.EndSearch resignFirstResponder];
    //[self.tableView becomeFirstResponder];
    return YES;
}


-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if( self.StartSearch.isFirstResponder && [self.StartSearch.text length] == 0)
    {
        isStartSearch = false;
    }
    else
    {
        isStartSearch = true;
    }
    [textField addTarget:self
                  action:@selector(textFieldDidChange)
        forControlEvents:UIControlEventEditingChanged];
    
}



-(void)textFieldDidChange
{
    
    if((self.StartSearch.isFirstResponder  && [self.StartSearch.text length] == 0))
    {
        //isStartSearch = false;
        searchResult = [[NSMutableArray alloc] initWithArray:self.data];
        [self.tableView reloadData ];
        
        return;
    }
    else if (self.EndSearch.isFirstResponder  && [self.EndSearch.text length] == 0)
    {
        //isStartSearch = true;
        searchResult = [[NSMutableArray alloc] initWithArray:self.data];
        [self.tableView reloadData ];
        return;
    }
    
    searchResult = [[NSMutableArray alloc]init];
    NSString * temp1  = [self.StartSearch.text  lowercaseString];
    NSString * temp2  = [self.EndSearch.text  lowercaseString];
    //self.StartSearch.text  = [self.StartSearch.text  lowercaseString];
    //self.EndSearch.text  = [self.EndSearch.text  lowercaseString];
    
    if (self.StartSearch.isFirstResponder)
    {
    
       searchResult = (NSMutableArray *)[Location getLocationByName: temp1];
    }
    else if (self.EndSearch.isFirstResponder)
    {
        searchResult = (NSMutableArray *)[Location getLocationByName: temp2];
    }
    
    
    [self.tableView reloadData];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
}


- (IBAction)switchLocation:(id)sender {
    NSString * temp1= self.StartSearch.text;
    NSString * temp2= self.EndSearch.text;
    self.StartSearch.text = temp2;
    self.EndSearch.text = temp1;
    
}

- (IBAction)TouchStartSearch:(id)sender {
    
}

-(IBAction)DrawRoutes:(id)sender
{
    if ([Utils checkInternetConnection] == YES)
    {
    MainViewController *mainController = (MainViewController *)self.container;
    ViewController *mapViewController = (ViewController *)mainController._mapViewController;
    if ([self.StartSearch.text isEqual:@""] || [self.EndSearch.text isEqual:@""])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            //GMSMapView* mapView =  mapViewController.mapview;
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:LocalizedString(@"Error")
                                                              message:LocalizedString(@"Error Fill Data")
                                         	                    delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
            [message show];
        });
    }
    
    else
    {
        if(mapViewController.mapview.myLocation)
            {
                    if (longLocation1 != nil && latLocation1 != nil && longLocation2 != nil && latLocation2 != nil)
                    {
                        [mapViewController DrawMap:latLocation1 andlongLocation1:longLocation1 andlatLocation2:latLocation2 andlongLocation2:longLocation2 andisBus:isBus];
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }
                else
                    {
                
                
                    UIAlertView *message = [[UIAlertView alloc] initWithTitle:LocalizedString(@"Error")
                                                                  message:LocalizedString(@"Error Fill Data")
                                                                 delegate:nil
                                                        cancelButtonTitle:LocalizedString(@"Ok")
                                                        otherButtonTitles:nil];
                    [message show];
                        
                    }
                //NSLog(@"Xe buýt");
                
                
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    //GMSMapView* mapView =  mapViewController.mapview;
                    UIAlertView *message = [[UIAlertView alloc] initWithTitle:LocalizedString(@"Error")
                                                                      message:LocalizedString(@"Error GPS")
                                                                     delegate:nil
                                                            cancelButtonTitle:LocalizedString(@"Ok")
                                                            otherButtonTitles:nil];
                    [message show];
                });
            }
        
        }
    }
    else
    {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:LocalizedString(@"Error")
                                                          message:LocalizedString(@"Error Internet Connection")
                                                         delegate:nil
                                                cancelButtonTitle:LocalizedString(@"Ok")
                                                otherButtonTitles:nil];
        [message show];
    }
}

- (IBAction)TouchEndSearch:(id)sender {
    
    if ([self.StartSearch.text length] == 0)
    {
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:LocalizedString(@"Information") message:LocalizedString(@"Fill Information") delegate:self cancelButtonTitle:LocalizedString(@"Ok") otherButtonTitles:nil];
        alertView.tag = 100;
        [alertView show];
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100) {
        if (buttonIndex == 0)
        {
            [self.EndSearch resignFirstResponder];
            [self.StartSearch becomeFirstResponder];
        }
    }
    
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    MainViewController *mainController = (MainViewController *)self.container;
    ViewController *mapViewController = (ViewController *)mainController._mapViewController;
    
    if([title isEqualToString:@"Đi xe buýt"])
    {
        isBus = TRUE;
        [mapViewController DrawMap:latLocation1 andlongLocation1:longLocation1 andlatLocation2:latLocation2 andlongLocation2:longLocation2 andisBus:isBus];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else if([title isEqualToString:@"Đi xe máy"])
    {
        isBus = FALSE;
        [mapViewController DrawMap:latLocation1
                  andlongLocation1:longLocation1
                   andlatLocation2:latLocation2
                  andlongLocation2:longLocation2
                          andisBus:isBus];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
}

- (IBAction)switchType:(id)sender {
    isBus = self.TransitType.selectedSegmentIndex == 0 ? false : true;
}
@end
