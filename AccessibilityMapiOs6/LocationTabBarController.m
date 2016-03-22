//
//  LocationTabBarController.m
//  MapGoogle
//
//  Created by apple on 10/11/14.
//  Copyright (c) 2014 apple. All rights reserved.
//

#import "LocationTabBarController.h"
#import "AddFeedBackViewController.h"
@interface LocationTabBarController ()

@end

@implementation LocationTabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
}

- (void) flipView
{
    AddFeedBackViewController * addfeedback= (AddFeedBackViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"AddFeedBack"];
    addfeedback.locationid = [self.locationInfo.locationID stringValue];
    [self.navigationController pushViewController:addfeedback animated:(YES)];
}

-(void)toggleBarButton:(bool)show
{
    if (show) {
        self.flipButton = [[UIBarButtonItem alloc]
                           initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                           target:self
                           action:@selector(flipView)];
    self.navigationItem.rightBarButtonItem = self.flipButton;
    }
        else {
            self.navigationItem.rightBarButtonItem = nil;
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
