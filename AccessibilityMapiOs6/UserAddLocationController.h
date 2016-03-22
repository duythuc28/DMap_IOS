//
//  UserAddLocationController.h
//  MapGoogle
//
//  Created by Hackintosh on 10/22/14.
//  Copyright (c) 2014 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationType.h"
#import "LocationTemp.h"
#import "AJComboBox.h"
#import "SubAcViewController.h"
@interface UserAddLocationController : UIViewController<AJComboBoxDelegate>
@property (strong, nonatomic) IBOutlet UITextField *userphone;
@property (strong, nonatomic) IBOutlet UITextField *userpassword;

@property (strong, nonatomic) IBOutlet UITextField *_name;
@property (strong, nonatomic) IBOutlet UITextField *_address;
@property (strong, nonatomic) IBOutlet UITextField *_phone;
@property (nonatomic, retain) AJComboBox *comboBox;
- (IBAction)Save:(id)sender;
@property (strong, nonatomic) IBOutlet UIScrollView *_scrollView;
@property (strong) SubAcViewController * subacc;
- (IBAction)selectAccessType:(id)sender;
- (IBAction)getKeyboardAway:(id)sender;
- (IBAction)postLocation:(id)sender;
- (void) saveLocationType:(LocationType*)locationtype;
- (void) saveAccessType: (NSMutableArray*)settings;
- (void) loadSaveLocationType:(LocationTemp*) locationtemp;
@end
