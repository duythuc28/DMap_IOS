//
//  AddLocationViewController.h
//  MapGoogle
//
//  Created by Hackintosh on 10/18/14.
//  Copyright (c) 2014 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationType.h"
#import "LocationTemp.h"
#import "AJComboBox.h"
#import "SubAcViewController.h"
@interface AddLocationViewController : UIViewController <AJComboBoxDelegate>
@property (weak, nonatomic) IBOutlet UITextField *_nameLocation;
@property (weak, nonatomic) IBOutlet UITextField *_addressLocation;
@property (weak, nonatomic) IBOutlet UILabel *placeTypeLabel;
@property (weak, nonatomic) IBOutlet UITextField *_phoneLocation;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIView * comboboxView;
@property (weak, nonatomic) IBOutlet UIButton * postButton;
@property (weak, nonatomic) IBOutlet UILabel *measureTypeLabel;
@property (weak, nonatomic) IBOutlet UIButton * saveButton;
@property (weak, nonatomic) IBOutlet UIButton * selectAccessTypeButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *viewListButton;

@property (strong) SubAcViewController * subacc;
- (IBAction)Save:(id)sender;
- (IBAction)_doneButton:(id)sender;
@property (nonatomic) NSString *so;
@property (nonatomic, retain) AJComboBox *comboBox;
- (IBAction)postLocation:(id)sender;
- (IBAction)getKeyboardAway:(id)sender;
- (void) saveLocationType:(LocationType*)locationtype;
- (void) saveAccessType: (NSMutableArray*)settings andNumberOfArray:(int)number numberOfCell:(NSMutableArray*)listOfSelected;
- (void) loadSaveLocationType:(LocationTemp*) locationtemp;
@end
