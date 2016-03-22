//
//  FilterController.h
//  MapGoogle
//
//  Created by apple on 9/30/14.
//  Copyright (c) 2014 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterController : UIViewController

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UILabel *checkallname;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
- (IBAction)check_all:(id)sender;
@property (strong, nonatomic) IBOutlet UISwitch *switch_all;
- (IBAction)save:(id)sender;
@end
