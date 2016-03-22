//
//  AccessTypeTableViewController.m
//  MapGoogle
//
//  Created by Hackintosh on 10/19/14.
//  Copyright (c) 2014 apple. All rights reserved.
//

#import "AccessTypeTableViewController.h"
#import "AccessTypeTableViewCell.h"
#import "AccessType.h"
#import "AddLocationViewController.h"
#define ROW_HEIGHT 60.0f
@interface AccessTypeTableViewController ()
{
    NSArray *data;
    NSArray* filterCodes;
}

@end

@implementation AccessTypeTableViewController


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //NSMutableArray *settings = [[NSUserDefaults standardUserDefaults] objectForKey:@"accesstype"];
    id typesCode;

    if ([self.settings count]== 0)
    {
        typesCode = nil;
    }
    else
    {
        typesCode = self.settings;
    }
    
    filterCodes = typesCode;
    
    data=[AccessType getAllData];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ROW_HEIGHT;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return data.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AccessTypeTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"AccessIdentifier"];
    AccessType* locType = (AccessType*) [data objectAtIndex:indexPath.row];
    NSString * languageKey = [[NSUserDefaults standardUserDefaults] objectForKey:APP_LANGUAGE];
    // Configure the cell...
    cell._nameAccess.text= [languageKey isEqualToString:@"vi"] ? locType.accessName : locType.accessName_en;
    cell.accessTypeID = [locType.accessTypeID intValue];
    //type swtich
    bool isOn = false;
    
    if(filterCodes == nil){
        [cell.typeSwitch setOn:true];
    }
    else{
        for(NSNumber * code in filterCodes){
            if([code intValue] == [locType.accessTypeID intValue]){
                isOn = true;
                break;
            }
        }
        
        [cell.typeSwitch setOn:isOn];
    }

    
    return cell;
}


- (IBAction)_doneButton:(id)sender {
   self.settings = [[NSMutableArray alloc] init];
    NSArray *cells = [self.tableView visibleCells];
    for(AccessTypeTableViewCell *cusCell in cells){
        if(cusCell.typeSwitch.isOn == TRUE){
            [self.settings addObject:[NSNumber numberWithInt:cusCell.accessTypeID]];
        }
    }
    AddLocationViewController * addLocation= (AddLocationViewController *)self.container;
    [self.navigationController popToViewController:addLocation animated:YES];
//    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
//        //[addLocation saveAccessType:self.settings];
//    });
}
@end
