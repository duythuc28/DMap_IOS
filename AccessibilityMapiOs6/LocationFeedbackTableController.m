//
//  LocationFeedbackTableController.m
//  MapGoogle
//
//  Created by apple on 10/11/14.
//  Copyright (c) 2014 apple. All rights reserved.
//

#import "LocationFeedbackTableController.h"
#import "LocationTabBarController.h"
#import "LocationFeedbackCellController.h"
#import "DownloadData.h"
#import "Comment.h"
#import "Reachability.h"
#import "LocalizeHelper.h"
#import "Utils.h"
@interface LocationFeedbackTableController ()<NSURLConnectionDataDelegate>
@end
@implementation LocationFeedbackTableController{
    NSArray * data;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    LocationTabBarController * cusTabBar = (LocationTabBarController*)self.tabBar;
    Location * location = cusTabBar.locationInfo;
    if ([Utils checkInternetConnection] == YES)
    {
        if ([DownloadData downloadCommentFromLocationID:[location.locationID stringValue]] != NULL)
        {
            data = [DownloadData downloadCommentFromLocationID:[location.locationID stringValue]];
            [self.tableView reloadData];
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
    return data.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* CellIdentifier = @"FeedbackCellIdentifier";
    LocationFeedbackCellController *cell=[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    Comment * comment = (Comment*) [data objectAtIndex:indexPath.row];
    
    cell.labelName.text = comment.name;
    cell.textViewContent.text = comment.content;
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    return cell;
    
}
@end
