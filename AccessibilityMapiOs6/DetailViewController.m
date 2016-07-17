//
//  DetailViewController.m
//  DMap
//
//  Created by IOSDev on 5/13/16.
//  Copyright © 2016 apple. All rights reserved.
//

#import "DetailViewController.h"
#import "MessageViewCell.h"


@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UIView *headerView;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpHeaderView];
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)setUpHeaderView {
    
    if (!self.locationInfo.phone || [self.locationInfo.phone isEqualToString:@""]) {
        CGRect changeFrame = self.headerView.frame;
        changeFrame.size.height = 370;
        self.headerView.frame = changeFrame;
        DetailInfoViewController * detailInfoViewController = [[DetailInfoViewController alloc]initWithFrame:changeFrame selectedLocation:self.locationInfo];
        detailInfoViewController.delegate = self;
        [self addChildViewController:detailInfoViewController];
        [self.headerView addSubview:detailInfoViewController.view];
        
    } else {
        CGRect changeFrame = self.headerView.frame;
        changeFrame.size.height = 450;
        self.headerView.frame = changeFrame;
        DetailInfoViewController * detailInfoViewController = [[DetailInfoViewController alloc]initWithFrame:self.headerView.frame selectedLocation:self.locationInfo];
        detailInfoViewController.delegate = self;
        [self addChildViewController:detailInfoViewController];
        [self.headerView addSubview:detailInfoViewController.view];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MessageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"messageCell" forIndexPath:indexPath];
    
    cell.userComment.text = @"If you build and run now it almost works. Unfortunately the cells displayed on the initial screen are still incorrect. If you scroll the table view you will see that the height is fine for new cells as they appear on screen. I suspect the problem is that the initial cells load before we have a valid row height. The workaround is to force a table reload when the view appears";
    
    return cell;
}


#pragma mark - Detail Info View Delegate
- (void)callButtonClicked {
    NSString *phoneNumber = [@"tel://" stringByAppendingString:self.locationInfo.phone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
}

#pragma mark - Action
- (IBAction)favoriteButtonClicked:(id)sender {
    
}


@end
