//
//  TableViewController.m
//  MapGoogle
//
//  Created by Hackintosh on 10/12/14.
//  Copyright (c) 2014 apple. All rights reserved.
//

#import "TableViewController.h"
#import "AccessType.h"
#import "GuideTableViewCell.h"
#import "LocalizeHelper.h"
@interface TableViewController ()
@end

@implementation TableViewController
{
    NSArray * data;
//    NSArray * testDescription;
}
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setUpArray];
}

-(NSMutableArray *)setUpArray
{
    if (_selectedAccessType == nil)
    {
        _selectedAccessType = [[NSMutableArray alloc]init];
    }
    return _selectedAccessType;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = LocalizedString(@"Measure Accessibility");
//#warning Can not sort this information, we should if/else this statement
//    testDescription = [[NSArray alloc]initWithObjects:@"Độ rộng > 90cm\nTay nắm: 80-110cm\n Bậc cấp < 2cm",@"Độ rộng > 120cm\nChỗ đổi hướng > 90cm",@"Đường dốc < 15 độ\nBậc thang < 1",@"Độ rộng cửa > 80cm\nBồn cầu 40-50cm\nĐộ cao bồn rửa tay 40-80 cm",@"Độ rộng cửa > 90 cm", nil];
    NSString * languageKey = [[NSUserDefaults standardUserDefaults] objectForKey:APP_LANGUAGE];
    data = [languageKey isEqualToString:@"vi"] ? [AccessType getAllData] : [AccessType getAllDataByEn];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    GuideTableViewCell *cell= [self.tableView dequeueReusableCellWithIdentifier:@"GuideCell"];
    AccessType* actype = (AccessType*) [data objectAtIndex:indexPath.row];
    
    NSString * languageKey = [[NSUserDefaults standardUserDefaults] objectForKey:APP_LANGUAGE];
    // Configure the cell...
    cell.Description.text= [languageKey isEqualToString:@"vi"] ? actype.accessName : actype.accessName_en;
    cell.detaildes.text = [languageKey isEqualToString:@"vi" ] ?actype.accessDescribtion : LocalizedString(actype.accessName_en);
    cell.Image.image = [AccessType getImageByAcessTypeID:[actype.accessTypeID intValue]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    // Configure the cell...
    for (NSNumber * accessTypeId in _selectedAccessType)
    {
        if (accessTypeId == actype.accessTypeID)
        {
            NSLog(@"%@", actype.accessTypeID);
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            break;
        }
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    AccessType* actype = (AccessType*) [data objectAtIndex:indexPath.row];
    GuideTableViewCell * cell = (GuideTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    if(cell.accessoryType == UITableViewCellAccessoryCheckmark){
       cell.accessoryType = UITableViewCellAccessoryNone;
        [self removeObject:actype];
    }else{
       cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self addObject:actype];
    }
}
-(NSMutableArray *)removeObject:(AccessType *)acessType
{
    [_selectedAccessType removeObject:acessType.accessTypeID];
    return _selectedAccessType;
}

-(NSMutableArray *)addObject:(AccessType *)acessType
{
    [_selectedAccessType addObject:acessType.accessTypeID];
    return _selectedAccessType;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.delegate didSelectMultipleTypes:_selectedAccessType];
}
@end
