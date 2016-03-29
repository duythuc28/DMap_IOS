//
//  SplashViewController.m
//  DMap
//
//  Created by IOSDev on 3/28/16.
//  Copyright © 2016 apple. All rights reserved.
//

#import "SplashViewController.h"
#import "AppDelegate.h"
#import "MainViewController.h"
#import "DownloadData.h"

@implementation SplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [DownloadData downloadDataCompletion:^(BOOL finished) {
        if (finished) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self loadingFinish];
            });
        } else {
            NSLog(@"Error");
        }       
    }];
}

- (void)loadingFinish {
    AppDelegate * appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UINavigationController * mainViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainNavigationController"];
    [appDelegate.window setRootViewController:mainViewController];
}


@end
