//
//  Guide.h
//  MapGoogle
//
//  Created by Hackintosh on 9/18/14.
//  Copyright (c) 2014 Hackintosh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Guide : UIViewController
@property (weak,nonatomic) IBOutlet UIGestureRecognizer * slidedown;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withPreviousController:(UIViewController*)passPrevController;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollview;

@end
