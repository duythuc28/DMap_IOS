//
//  RouteViewController.h
//  MapGoogle
//
//  Created by Hackintosh on 10/3/14.
//  Copyright (c) 2014 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface RouteViewController : UIViewController <UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
@property (strong) UIViewController*    container;
@property (strong) NSMutableArray*      data;

@property (strong, nonatomic) IBOutlet UITextField *StartSearch;
@property (strong, nonatomic) IBOutlet UITextField *EndSearch;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)switchLocation:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *findRouteButton;
@property (weak, nonatomic) IBOutlet UITextField *fromTextView;

- (IBAction)TouchStartSearch:(id)sender;
-(IBAction)DrawRoutes:(id)sender;
- (IBAction)TouchEndSearch:(id)sender;
@property (strong, nonatomic) IBOutlet UISegmentedControl *TransitType;
- (IBAction)switchType:(id)sender;


@end
