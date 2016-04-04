//
//  MainViewController.h
//  AccessibilityMapiOs6
//
//  Created by apple on 10/2/14.
//  Copyright (c) 2014 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXXRoundMenuButton.h"

@interface MainViewController : UIViewController

@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) UIViewController *_mapViewController;
@property (strong, nonatomic) IBOutlet UIView *_mainView;
@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;
@property (strong, nonatomic) IBOutlet UIButton  *fakeButtonSearchBarClicked;
@property (weak, nonatomic) IBOutlet XXXRoundMenuButton *roundButton;
@end
