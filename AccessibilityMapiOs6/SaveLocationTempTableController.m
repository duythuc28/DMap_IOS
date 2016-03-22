//
//  SaveLocationTempTableController.m
//  MapGoogle
//
//  Created by Hackintosh on 10/28/14.
//  Copyright (c) 2014 apple. All rights reserved.
//

#import "SaveLocationTempTableController.h"
#import "AddLocationViewController.h"
#import "SaveLocationTempTableViewCell.h"
#import "LocationTemp.h"
#import "UserAddLocationController.h"
#import "Reachability.h"
#import "CustomAlertViewController.h"
#import "LocalizeHelper.h"
#import "Utils.h"
@interface SaveLocationTempTableController ()<NSURLConnectionDataDelegate>
{
    NSArray *data;
    NSMutableArray * result;
    CustomAlertViewController * alertView;
}
@end

@implementation SaveLocationTempTableController
bool isConnect;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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
    
    UIBarButtonItem *flipButton = [[UIBarButtonItem alloc]
                                   initWithTitle:LocalizedString(@"Post All")
                                   style:UIBarButtonItemStyleBordered
                                   target:self
                                   action:@selector(flipView)];
    
    self.navigationItem.rightBarButtonItem = flipButton;
    
    if (self.usercode == [NSNumber numberWithInt:NO])
    {
        data = [LocationTemp getUserData:[NSNumber numberWithInt:NO]];
    }
    else
    {
        data = [LocationTemp getUserData:[NSNumber numberWithInt:YES]];
    }
    result = [[NSMutableArray alloc] init];
    result = [data mutableCopy];
}

-(void)postToServerByUser
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    for (LocationTemp*loctemp in result)
    {
        NSMutableArray *access = [[NSMutableArray alloc]init];
        for(NSInteger i = 0; i < loctemp.accesstype.length; ++i) {
            [access addObject:[NSString stringWithFormat:@"%c",[loctemp.accesstype characterAtIndex:i]]];}
        
        NSArray *keys = [NSArray arrayWithObjects:@"Location", nil];
        NSArray *array =[NSArray arrayWithObjects:loctemp.latitude, loctemp.longtitude, access,loctemp.locationtype,loctemp.title,loctemp.address,loctemp.phone,alertView.userNameText.text, nil];
        NSArray *objects = [NSArray arrayWithObjects:array, nil];
        NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:objects
                                                               forKeys:keys];
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:nil];
        // Create the request
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:POST_LOCATION_API]];
        [request setHTTPMethod:@"POST"];
        [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)jsonData.length] forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:jsonData];
        
        // Request Reply
        NSURLResponse *requestResponse;
        NSData *requestHandler = [NSURLConnection sendSynchronousRequest:request returningResponse:&requestResponse error:nil];
        
        NSString *requestReply = [[NSString alloc] initWithBytes:[requestHandler bytes] length:[requestHandler length] encoding:NSASCIIStringEncoding];
        NSLog(@"requestReply:%@", requestReply);
        if([requestReply isEqualToString:@"1"]){
            [LocationTemp removeSaveDataByName:loctemp.title];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }
        else
        {
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:LocalizedString(@"Error")
                                                              message:LocalizedString(@"Error Post")
                                                             delegate:nil
                                                    cancelButtonTitle:LocalizedString(@"Ok")
                                                    otherButtonTitles:nil];
            [message show];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            return;
        }
        
    }
}

-(void)postToServerByDRD
{
    //NSArray *arrauser =[[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    NSArray * arrayUser = [[NSArray alloc]initWithObjects:alertView.userNameText.text, alertView.passwordText.text, nil];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    for (LocationTemp*loctemp in result)
    {
        NSMutableArray *access = [[NSMutableArray alloc]init];
        for(NSInteger i = 0; i < loctemp.accesstype.length; ++i) {
            [access addObject:[NSString stringWithFormat:@"%c",[loctemp.accesstype characterAtIndex:i]]];}
        //NSLog(@"%c",[typeaccess characterAtIndex:i])
        NSArray *keys = [NSArray arrayWithObjects:@"Location",@"User",nil];
        NSArray *array =[NSArray arrayWithObjects:loctemp.latitude, loctemp.longtitude, access,loctemp.locationtype,loctemp.title,loctemp.address,loctemp.phone, nil];
        
        //NSArray *arrauser =[[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
        
        NSArray *objects = [NSArray arrayWithObjects:array,arrayUser, nil];
        NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:objects
                                                               forKeys:keys];
        //[data addObject:dictionary];
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:nil];
        // Create the request
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:POST_LOCATION_API]];
        [request setHTTPMethod:@"POST"];
        [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)jsonData.length] forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:jsonData];
        
        // Request Reply
        NSURLResponse *requestResponse;
        NSData *requestHandler = [NSURLConnection sendSynchronousRequest:request returningResponse:&requestResponse error:nil];
        
        NSString *requestReply = [[NSString alloc] initWithBytes:[requestHandler bytes] length:[requestHandler length] encoding:NSASCIIStringEncoding];
        NSLog(@"requestReply:%@", requestReply);
        
        if([requestReply isEqualToString:@"1"]){
            [LocationTemp removeSaveDataByName:loctemp.title];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }
        else
        {
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:LocalizedString(@"Error")
                                                              message:LocalizedString(@"Error Post")
                                                             delegate:nil
                                                    cancelButtonTitle:LocalizedString(@"Ok")
                                                    otherButtonTitles:nil];
            [message show];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }
    }

}


-(IBAction)flipView
{
    alertView = [[CustomAlertViewController alloc]initWithFrame:CGRectMake(10, self.view.frame.size.height - 390, self.view.frame.size.width-20, 235)];
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    [alertView.selectUser addTarget:self action:@selector(switchUser) forControlEvents:UIControlEventValueChanged];
    
    [alertView.okButton addTarget:self action:@selector(doPostDataToServer) forControlEvents:UIControlEventTouchUpInside];
    
    [alertView.cancelButton addTarget:self action:@selector(dismissAlertView) forControlEvents:UIControlEventTouchUpInside];
    
    [UIView transitionWithView:self.view
                      duration:0.5
                       options:UIViewAnimationOptionTransitionCrossDissolve //any animation
                    animations:^ { [self.view addSubview:alertView.view]; }
                    completion:nil];

    
}

-(void)switchUser
{
    if(alertView.selectUser.selectedSegmentIndex == 0)
    {
        alertView.passwordText.hidden = YES;
        alertView.labelPassword.hidden = YES;
        alertView.passwordText.text = @"";
    }
    else
    {
        alertView.passwordText.hidden = NO;
        alertView.labelPassword.hidden = NO;
    }
}

-(void)dismissAlertView
{
    [alertView.view removeFromSuperview];
    self.view.backgroundColor = [UIColor whiteColor];
}

-(void)doPostDataToServer
{
    if (alertView.selectUser.selectedSegmentIndex == 0)
    {
        [self postToServerByUser];
        [self dismissAlertView];
        [result removeAllObjects];
        [self.tableView reloadData];
    }
    else
    {
        [self postToServerByDRD];
        [self dismissAlertView];
        [result removeAllObjects];
        [self.tableView reloadData];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return result.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SaveLocationTempTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SaveLocationTempCell" forIndexPath:indexPath];
    LocationTemp * loctype = (LocationTemp*)[result objectAtIndex:indexPath.row];
    cell.name.text = loctype.title;
    cell.address.text = loctype.address;
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.usercode == [NSNumber numberWithInt:NO])
    {
    AddLocationViewController * addLocation= (AddLocationViewController *)self.container;
    
    [self.navigationController popToViewController:addLocation animated:YES];
    LocationTemp * temp= (LocationTemp *) [result objectAtIndex:indexPath.row];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [addLocation loadSaveLocationType:temp];
    });
    }
    else
    {
        UserAddLocationController * addLocation= (UserAddLocationController *)self.container;
        
        [self.navigationController popToViewController:addLocation animated:YES];
        LocationTemp * temp= (LocationTemp *) [result objectAtIndex:indexPath.row];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [addLocation loadSaveLocationType:temp];
        });

    }

}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    LocationTemp * locationtemp = (LocationTemp*) [result objectAtIndex:indexPath.row];
    [LocationTemp removeSaveDataByName:locationtemp.title];
    //NSLog(@"%@",locationtemp.address);
    //[LocationTemp removeAllData];
    [result removeObjectAtIndex:indexPath.row];
    [tableView reloadData];
    
}
@end
