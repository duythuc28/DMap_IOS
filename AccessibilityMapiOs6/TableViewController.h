//
//  TableViewController.h
//  MapGoogle
//
//  Created by Hackintosh on 10/12/14.
//  Copyright (c) 2014 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TableViewController;
@protocol AccessTypeDelegate <NSObject>
-(void)didSelectMultipleTypes:(NSMutableArray *)listId;
@end
@interface TableViewController : UITableViewController
@property (weak, nonatomic) id <AccessTypeDelegate> delegate;
@property (strong, nonatomic) NSMutableArray * selectedAccessType;
@end
