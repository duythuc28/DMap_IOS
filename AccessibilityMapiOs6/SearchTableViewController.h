//
//  SearchTableViewController.h
//  MapGoogle
//
//  Created by apple on 9/22/14.
//  Copyright (c) 2014 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchTableViewController : UITableViewController

@property (strong) UIViewController*    container;

@property (strong) NSMutableArray*      data;

@property (strong, nonatomic) UISearchBar *searchBar;

@end
