//
//  CustomAlertViewController.m
//  AccessibilityMap
//
//  Created by MC976 on 3/14/15.
//  Copyright (c) 2015 apple. All rights reserved.
//

#import "CustomAlertViewController.h"
#import "LocalizeHelper.h"
#define IPHONE_4S_HEIGHT 480
#define IPHONE_5_HEIGHT 568
@interface CustomAlertViewController ()
@property  (nonatomic) CGRect viewFrame;
@end

@implementation CustomAlertViewController

-(void)localizeView {
    self.alertTitle.text = LocalizedString(@"Authentication");
    self.labelUserPhone.text = LocalizedString(@"User Phone");
    self.labelPassword.text = LocalizedString(@"Password");
    [self.okButton setTitle:LocalizedString(@"Ok") forState:UIControlStateNormal];
    [self.cancelButton setTitle:LocalizedString(@"Cancel") forState:UIControlStateNormal];
    [self.selectUser setTitle:LocalizedString(@"Contributor") forSegmentAtIndex:0];
    [self.selectUser setTitle:LocalizedString(@"Admin") forSegmentAtIndex:1];
    
}

-(id)initWithFrame:(CGRect)frame
{
    CustomAlertViewController * alertView = [[CustomAlertViewController alloc]initWithNibName:@"CustomAlertViewController" bundle:nil];
    self.viewFrame = frame;
    alertView.view.frame = frame;
    CALayer *layer = alertView.view.layer;
    layer.masksToBounds = YES;
    layer.cornerRadius = 6.0f;
    layer.borderWidth = 1.0f;
    [layer setBorderColor:[UIColor darkGrayColor].CGColor];
    
    CALayer * buttonOKlayer = alertView.okButton.layer;
    buttonOKlayer.borderWidth = 1.0f;
    [buttonOKlayer setBorderColor:[UIColor darkGrayColor].CGColor];
    
    CALayer * cancelButtonLayer = alertView.cancelButton.layer;
    cancelButtonLayer.borderWidth = 1.0f;
    [cancelButtonLayer setBorderColor:[UIColor darkGrayColor].CGColor];
    return  alertView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.labelPassword.hidden = YES;
    self.passwordText.hidden = YES;
    self.passwordText.delegate = self;
    self.userNameText.delegate = self;
    [self registerForKeyboardNotifications];
    [self localizeView];
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    //CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    if (screenHeight == IPHONE_4S_HEIGHT)
    {
        CGRect theFrame = self.viewFrame;
        float y = theFrame.origin.y + 250;
        y -= (y/1.7);
        [self scrollToY:-y];
    }
    else
    {
        CGRect theFrame = self.viewFrame;
        float y = theFrame.origin.y + 160;
        y -= (y/1.7);
        [self scrollToY:-y];
    }
}

-(void)scrollToY:(float)y
{
    
    [UIView beginAnimations:@"registerScroll" context:NULL];
    
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];
    self.view.transform = CGAffineTransformMakeTranslation(0, y);
    [UIView commitAnimations];
    
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    CGRect theFrame = self.viewFrame;
    float y = theFrame.origin.y ;
    y -= (y/1.7);
    [self scrollToY:-y];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self removeObserverFromKeyboard];
}

-(void)removeObserverFromKeyboard
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
