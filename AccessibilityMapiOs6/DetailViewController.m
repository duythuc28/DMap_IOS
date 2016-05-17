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
}

- (void)setUpHeaderView {
    DetailInfoViewController * detailInfoViewController = [[DetailInfoViewController alloc]initWithFrame:self.headerView.frame selectedLocation:self.locationInfo];
    detailInfoViewController.delegate = self;
    [self addChildViewController:detailInfoViewController];
    [self.headerView addSubview:detailInfoViewController.view];
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MessageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"messageCell" forIndexPath:indexPath];
    
    return cell;
}


#pragma mark - Detail Info View Delegate
- (void)callButtonClicked {
    NSString *phoneNumber = [@"tel://" stringByAppendingString:self.locationInfo.phone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
}

@end
