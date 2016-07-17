//
//  DetailViewController.m
//  DMap
//
//  Created by IOSDev on 5/13/16.
//  Copyright © 2016 apple. All rights reserved.
//

#import "DetailViewController.h"
#import "MessageViewCell.h"
#import "DownloadData.h"
#import "Comment.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) NSMutableArray * comments;
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpHeaderView];
    self.tableView.estimatedRowHeight = 140;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.title =  LocalizedString(@"Details");
    [self getUserComments];
}

- (NSMutableArray *)comments {
    if (!_comments) {
        _comments = [[NSMutableArray alloc]init];
    }
    return _comments;
}

- (void)getUserComments {
    [DownloadData downloadCommentFromLocationID:[self.locationInfo.locationID stringValue] success:^(NSDictionary *response) {
        for(NSArray * data in response){
            Comment * comment = [[Comment alloc]init];
            comment.name = [data valueForKeyPath:@"name"];
            comment.content = [data valueForKeyPath:@"Content"];
            [self.comments addObject:comment];
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        NSLog(@"download error");
    }];
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
    return [self.comments count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MessageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"messageCell" forIndexPath:indexPath];
    
    if ([self.comments count] > 0) {
        Comment * currentComment = [self.comments objectAtIndex:indexPath.row];
        [cell setupCellUserPhone:currentComment.name userComment:currentComment.content];
    }
    
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
