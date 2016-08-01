//
//  FromToRouteView.m
//  MapGoogle
//
//  Created by Hackintosh on 11/25/14.
//  Copyright (c) 2014 apple. All rights reserved.
//

#import "FromToRouteView.h"
#import "DetailLocationViewController.h"
#import "MainViewController.h"
#import "ViewController.h"
#import "LocalizeHelper.h"
@interface FromToRouteView ()

@end

@implementation FromToRouteView
{
    UIViewController* _parentController;
    //NSString * selectedLanguage;
}

-(void)localizeView {
    self.Title.text = LocalizedString(@"Select Routes");
    self.labelFrom.text = LocalizedString(@"From:");
    self.labelTo.text = LocalizedString(@"To:");
    [self.findway setTitle:LocalizedString(@"Find routes") forState:UIControlStateNormal];
    [self.exit setTitle:LocalizedString(@"Cancel") forState:UIControlStateNormal];
}

- (IBAction)findway:(id)sender {
//    DetailLocationViewController * detailview = (DetailLocationViewController*)_parentController;
//    LocationTabBarController * tabBar = (LocationTabBarController*)_parentController.tabBarController;
//    MainViewController *mainController = (MainViewController *)tabBar.rootViewController;
//    ViewController *mapViewController = (ViewController *)mainController._mapViewController;
//    //LocalizationSetLanguage(selectedLanguage);
//    if ([self._from.text isEqualToString:LocalizedString(@"Current Location")])
//    {
//        detailview.isGo = TRUE ;
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
//            [detailview showWay:mapViewController];
//        });
//
//        
//        [self.view removeFromSuperview];
//        [detailview.navigationController popToRootViewControllerAnimated:YES];
//    }
//    else
//    {
//        detailview.isGo = FALSE;
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
//            [detailview showWay:mapViewController];
//        });
//
//        
//        [self.view removeFromSuperview];
//        [detailview.navigationController popToRootViewControllerAnimated:YES];
//    }
}

- (IBAction)swtichplace:(id)sender {
    NSString * temp = self._from.text;
    self._from.text = self._to.text;
    self._to.text = temp;
}

- (IBAction)exitpress:(id)sender {
    [ self.exit setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
}

- (IBAction)findwaypress:(id)sender {
    [ self.findway setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
}

- (IBAction)findwayrelease:(id)sender {
    //[self.findway setBackgroundColor:[UIColor whiteColor]];
}

- (IBAction)exit:(id)sender {
    [self.view removeFromSuperview];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withparentcontroller:(UIViewController*)parentController
{
    if(self){
        _parentController = parentController;
    }
    return self;
}

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
    [self localizeView];
    CALayer *layer = self.subview.layer;
    layer.masksToBounds = YES;
    layer.cornerRadius = 5.0f;
    layer.borderWidth = 1.5f;
    [layer setBorderColor:[UIColor grayColor].CGColor];
    self._from.text = self._myLocationtitle;
    self._to.text = self._destinationtitle;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
