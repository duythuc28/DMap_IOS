//
//  InfoDRDViewController.m
//  DMap
//
//  Created by MC976 on 9/15/15.
//  Copyright (c) 2015 apple. All rights reserved.
//

#import "InfoDRDViewController.h"
#import "LocalizeHelper.h"
@interface InfoDRDViewController ()

@end

@implementation InfoDRDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.drdTitle.text = LocalizedString(@"DRD");
    self.drdContent.text = LocalizedString(@"DRD Info");
    self.hoasenTitle.text = LocalizedString(@"Hoa Sen");
    self.hoasenContent.text = LocalizedString(@"Hoa Sen Info");
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    [super viewWillDisappear:animated];
}

@end
