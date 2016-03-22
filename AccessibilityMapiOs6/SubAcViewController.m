//
//  SubAcViewController.m
//  MapGoogle
//
//  Created by Hackintosh on 11/5/14.
//  Copyright (c) 2014 apple. All rights reserved.
//

#import "SubAcViewController.h"
#import "AccessType.h"
#import "AddLocationViewController.h"
#import "SubAcTableCell.h"
@interface SubAcViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *data;
    NSArray* filterCodes;
}
@end

@implementation SubAcViewController{
    UIViewController* _parentController;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withparentcontroller:(UIViewController*)parentController
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _parentController = parentController;
        
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withparentcontroller:(UIViewController*)parentController withSettings:(NSMutableArray*)settings
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        CALayer *layer = self.subview.layer;
        layer.masksToBounds = YES;
        layer.cornerRadius = 5.0f;
        layer.borderWidth = 2.0f;
        [layer setBorderColor:[UIColor darkGrayColor].CGColor];
        _parentController = parentController;
        self.settings = [[NSMutableArray alloc]initWithArray:settings copyItems:YES];
    }
    return self;
}

- (IBAction)test:(id)sender {
    [self.view removeFromSuperview];
}

- (IBAction)exit:(id)sender {
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    // Do any additional setup after loading the view from its nib.
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
    
    SubAcTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AccessType"];
    if (!cell) {
     //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AccessType"];
        [tableView registerNib:[UINib nibWithNibName:@"SubAcTableCell" bundle:nil] forCellReuseIdentifier:@"AccessType"];
        cell=[tableView dequeueReusableCellWithIdentifier:@"AccessType"];
     }
    
    AccessType* locType = (AccessType*) [data objectAtIndex:indexPath.row];
    //cell.textLabel.text = locType.accessName;
    NSArray * lang =  [[NSUserDefaults standardUserDefaults]objectForKey:@"Language"];
    if ([lang count] >1 )
    {
        NSString * tAccessMapName = [NSString stringWithFormat:@"%d.  %@",(int)indexPath.row + 1, locType.accessName_en];
        cell.accessname.text=tAccessMapName;
    }
    else
    {
        NSString * tAccessMapName = [NSString stringWithFormat:@"%d.  %@",(int)indexPath.row + 1, locType.accessName];
        cell.accessname.text=tAccessMapName;
    }
    
    cell.accessTypeID = [locType.accessTypeID intValue];
    cell.accessRow = indexPath.row;
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    //type swtich
    bool isOn = false;
    
    if(filterCodes == nil){
        [cell.typeswitch setOn:true];
    }
    else{
        for(NSNumber * code in filterCodes){
            if([code intValue] == [locType.accessTypeID intValue]){
                isOn = true;
                break;
            }
        }
        
        [cell.typeswitch setOn:isOn];
    }
    
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (IBAction)cancel:(id)sender {
    NSMutableArray * tAccessTypeList = [[NSMutableArray alloc]init];
    self.settings = [[NSMutableArray alloc] init];
    NSArray *cells = [self.tableView visibleCells];
    for(SubAcTableCell *cusCell in cells){
        if(cusCell.typeswitch.isOn == TRUE){
            [self.settings addObject:[NSNumber numberWithInt:cusCell.accessTypeID]];
            [tAccessTypeList addObject:[NSNumber numberWithInt:(int)cusCell.accessRow]];
        }
    }
    
    AddLocationViewController * addLocation= (AddLocationViewController *)_parentController;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [addLocation saveAccessType:self.settings andNumberOfArray:(int)data.count numberOfCell:tAccessTypeList];
    });
    
    //addLocation.view.alpha = 1.0f;
    addLocation.view.backgroundColor = [UIColor whiteColor];
    addLocation._addressLocation.backgroundColor = [UIColor whiteColor];
    addLocation._nameLocation.backgroundColor = [UIColor whiteColor];
    addLocation._phoneLocation.backgroundColor = [UIColor whiteColor];
    [self.view removeFromSuperview];
}

- (IBAction)cancelpress:(id)sender {
    [ self.cancel setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
}
@end
