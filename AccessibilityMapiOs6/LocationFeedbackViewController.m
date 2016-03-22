//
//  LocationFeedbackViewController.m
//  MapGoogle
//
//  Created by apple on 10/11/14.
//  Copyright (c) 2014 apple. All rights reserved.
//

#import "LocationFeedbackViewController.h"
#import "LocationFeedbackTableController.h"
#import "LocationTabBarController.h"
#import "Ulti.h"
#import "Reachability.h"
#import "LocalizeHelper.h"
#import "Utils.h"
@interface LocationFeedbackViewController ()<NSURLConnectionDataDelegate>
@end

@implementation LocationFeedbackViewController
LocationTabBarController * tabBar;
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
     tabBar = (LocationTabBarController*)self.tabBarController;
    tabBar.navigationItem.title = LocalizedString(@"Feedback");
    [tabBar toggleBarButton:YES];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"LocationFeedbackTableSegue"]){
        LocationFeedbackTableController * tableView = (LocationFeedbackTableController*)segue.destinationViewController;
        tableView.tabBar = self.tabBarController;
    }
}
@end
