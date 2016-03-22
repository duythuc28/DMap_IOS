//
//  AccessTypeTableViewController.h
//  MapGoogle
//
//  Created by Hackintosh on 10/19/14.
//  Copyright (c) 2014 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccessTypeTableViewController : UITableViewController

@property (strong) UIViewController*    container;
@property (strong) NSMutableArray * settings;
- (IBAction)_doneButton:(id)sender;
@end
