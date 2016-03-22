//
//  TableViewController.h
//  MapGoogle
//
//  Created by apple on 9/23/14.
//  Copyright (c) 2014 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookmarkTableViewController : UITableViewController

@property (strong) UIViewController*    container;

@property (strong) NSMutableArray*      data;

@property (strong) NSString * longtitude;
@property (strong) NSString * latitude;


@property (strong, nonatomic) UISearchBar *searchBar;
@end
