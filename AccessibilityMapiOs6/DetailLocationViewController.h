//
//  DetailLocationViewController.h
//  MapGoogle
//
//  Created by apple on 10/11/14.
//  Copyright (c) 2014 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Location.h"
#import "CustomMarker.h"
#import "FromToRouteView.h"
#import "ViewController.h"
@interface DetailLocationViewController : UIViewController<GMSMapViewDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *labelTitle;

@property (strong, nonatomic) IBOutlet UILabel *labelAddress;

@property (strong, nonatomic) IBOutlet UILabel *labelPhone;

@property (strong) CustomMarker                *marker;

@property (strong) FromToRouteView * routeview;
@property (weak, nonatomic) IBOutlet UIButton *bikeButton;
@property (weak, nonatomic) IBOutlet UIButton *busButton;

@property bool isGo;

-(IBAction)findWay:(id)sender;

-(IBAction)findCarway:(id)sender;

-(IBAction)bookmarklocation:(id)sender;

-(void)showWay:(ViewController*)mapViewController;

@end
