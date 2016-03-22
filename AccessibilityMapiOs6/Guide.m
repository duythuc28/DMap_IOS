//
//  Guide.m
//  MapGoogle
//
//  Created by Hackintosh on 9/18/14.
//  Copyright (c) 2014 Hackintosh. All rights reserved.
//

#import "Guide.h"
#import "MainViewController.h"
@interface Guide ()

@end

@implementation Guide{
    UIViewController *prevController;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withPreviousController:(UIViewController*)passPrevController
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        prevController = passPrevController;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.scrollview setScrollEnabled:YES];
    [self.scrollview setContentSize:CGSizeMake(320, 568)];
    [self.navigationController setNavigationBarHidden:NO animated:NO];

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
