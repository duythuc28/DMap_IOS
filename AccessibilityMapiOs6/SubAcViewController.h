//
//  SubAcViewController.h
//  MapGoogle
//
//  Created by Hackintosh on 11/5/14.
//  Copyright (c) 2014 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubAcViewController : UIViewController
@property (strong) UIViewController*    container;
@property (strong) NSMutableArray * settings;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withparentcontroller:(UIViewController*)parentController;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withparentcontroller:(UIViewController*)parentController withSettings:(NSMutableArray*)settings;
@property (strong, nonatomic) IBOutlet UIView *subview;

- (IBAction)exit:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *cancel;
- (IBAction)cancel:(id)sender;
- (IBAction)cancelpress:(id)sender;

@end
