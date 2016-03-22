//
//  CustomAlertViewController.h
//  AccessibilityMap
//
//  Created by MC976 on 3/14/15.
//  Copyright (c) 2015 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomAlertViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *alertTitle;
@property (weak , nonatomic) IBOutlet UIButton           * okButton;
@property (weak, nonatomic ) IBOutlet UIButton           * cancelButton;
@property (weak , nonatomic) IBOutlet UITextField        * userNameText;
@property (weak , nonatomic) IBOutlet UITextField        * passwordText;
@property (weak, nonatomic ) IBOutlet UILabel            *labelPassword;
@property (weak, nonatomic) IBOutlet UILabel *labelUserPhone;
@property (weak , nonatomic) IBOutlet UISegmentedControl * selectUser;
-(id)initWithFrame:(CGRect)frame;
@end
