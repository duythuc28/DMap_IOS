//
//  FromToRouteView.h
//  MapGoogle
//
//  Created by Hackintosh on 11/25/14.
//  Copyright (c) 2014 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FromToRouteView : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *Title;
@property (weak, nonatomic) IBOutlet UILabel *labelFrom;
@property (weak, nonatomic) IBOutlet UILabel *labelTo;
@property (strong, nonatomic) IBOutlet UILabel *_from;
@property (strong, nonatomic) IBOutlet UILabel *_to;
- (IBAction)findway:(id)sender;


@property (strong, nonatomic) IBOutlet UIView *subview;
@property bool isGo;
@property NSString * _myLocationtitle;
@property (strong, nonatomic) IBOutlet UIButton *findway;
@property (strong, nonatomic) IBOutlet UIButton *exit;
@property (strong, nonatomic) IBOutlet UIButton *switchplace;
@property NSString * _destinationtitle;
- (IBAction)swtichplace:(id)sender;
- (IBAction)exitpress:(id)sender;

- (IBAction)findwaypress:(id)sender;
- (IBAction)findwayrelease:(id)sender;

- (IBAction)exit:(id)sender;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withparentcontroller:(UIViewController*)parentController;
@end
