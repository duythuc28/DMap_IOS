//
//  AddFeedBackViewController.h
//  MapGoogle
//
//  Created by Hackintosh on 11/22/14.
//  Copyright (c) 2014 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface AddFeedBackViewController : UIViewController

@property (strong) NSString * locationid;

@property (strong, nonatomic) IBOutlet UITextField *nameBox;

@property (strong, nonatomic) IBOutlet UITextView *commentBox;
- (IBAction)getKeyboardAway:(id)sender;
@end
