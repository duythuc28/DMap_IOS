//
//  FilterController.m
//  MapGoogle
//
//  Created by apple on 9/30/14.
//  Copyright (c) 2014 apple. All rights reserved.
//


#import "FilterController.h"
#import "LocationType.h"
#import "FilterTableCell.h"
#import "AppDelegate.h"
#import "LocalizeHelper.h"
@interface FilterController ()<UITableViewDelegate,UITableViewDataSource>
@end

@implementation FilterController{
    NSArray* filterCodes;
    NSArray* data;
    NSMutableArray* checkedArray;
    bool isSwitchAll;
    NSMutableArray * Language;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalizedString(@"Settings");
    [self.saveButton setTitle:LocalizedString(@"Save")];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //Set language
    NSString * language = [[NSUserDefaults standardUserDefaults] objectForKey:APP_LANGUAGE];
    data = [language isEqualToString:@"vi"] ? [LocationType getAllData] : [LocationType getAllDataByEn];

    NSArray* settings = [[NSUserDefaults standardUserDefaults] objectForKey:@"settings"];
    checkedArray = [[NSMutableArray alloc]init];
    id typesCode;
    if([settings count] > 1)
        typesCode = [settings objectAtIndex:1];
    else
        typesCode = nil;
    
    filterCodes = typesCode;
    
    for(LocationType *locType in data){
        int temp = [locType.isCheck intValue];
        if(temp == 1)
            [checkedArray addObject:locType.locationTypeID];
    }
    self.tableView.delegate = self;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return data.count;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    FilterTableCell* cusCell= (FilterTableCell*)cell;
    BOOL isOn= false;
    for(NSNumber *locId in checkedArray){
        if([locId intValue] == cusCell.locationTypeID){
            cusCell.isCheck = true;
            [cusCell.typeSwitch setOn:true];
            isOn = true;
            break;
        }
    }
    if(isOn == false)
    {
        cusCell.isCheck = false;
        [cusCell.typeSwitch setOn: false];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* CellIdentifier = @"FilterCellIdentifier";
    
    FilterTableCell *cell=[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.Cells = [[NSMutableArray alloc]init];
    cell.checkedArray = checkedArray;
    LocationType* locType = (LocationType*) [data objectAtIndex:indexPath.row];
    
    NSString * language = [[NSUserDefaults standardUserDefaults] objectForKey:APP_LANGUAGE];
    cell.typeTitle.text = [language isEqualToString:@"vi"] ? locType.locationName : locType.locationName_en;
    cell._image.image = [LocationType getImageByLocationTypeId: [locType.locationTypeID intValue]];
    cell.locationTypeID = [locType.locationTypeID intValue];
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    if (locType.isCheck ==[NSNumber numberWithInt:YES])
    {
        [cell.typeSwitch setOn:TRUE];
    }
    else
    {
        [cell.typeSwitch setOn:FALSE];
    }
    
    return cell;
}

- (IBAction)check_all:(id)sender {
    
    NSArray *cells = [self.tableView visibleCells];
    
    if(self.switch_all.on)
    {
        isSwitchAll = true;
        self.checkallname.text = @"On";
        
        for(FilterTableCell * cell in cells)
        {
            [cell.typeSwitch setOn:YES];
        }
        [checkedArray removeAllObjects];
        for(LocationType* type in data){
            [checkedArray addObject:type.locationTypeID];
        }
        
    }
    else
    {
        isSwitchAll = false;
        self.checkallname.text = @"Off";
        
        for(FilterTableCell * cell in cells)
        {
            [cell.typeSwitch setOn:FALSE];
        }
        [checkedArray removeAllObjects];
    }
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (IBAction)save:(id)sender {
    for (LocationType *locType in data)
    {
        bool isTrue = false;
        for(NSNumber * number in checkedArray){
            if([number intValue] == [locType.locationTypeID intValue]){
                locType.isCheck = [NSNumber numberWithInt:1];
                isTrue = true;
            }
        }
        if(isTrue == false){
            locType.isCheck = [NSNumber numberWithInt:0];
        }
    }


        UIAlertView *message = [[UIAlertView alloc] initWithTitle:LocalizedString(@"Success")
                                                          message:LocalizedString(@"Success Save Message")
                                                         delegate:nil
                                                cancelButtonTitle:LocalizedString(@"Ok")
                                                otherButtonTitles:nil];
        [message show];

    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSError* error;
    [context save:&error];
}

@end
