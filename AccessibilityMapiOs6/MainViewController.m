//
//  MainViewController.m
//  AccessibilityMapiOs6
//
//  Created by apple on 10/2/14.
//  Copyright (c) 2014 apple. All rights reserved.
//
#import "MainViewController.h"
#import "ViewController.h"
#import "BookmarkTableViewController.h"
#import "SearchTableViewController.h"
#import "RouteViewController.h"
#import "CustomAlertViewController.h"
#import "ToolView.h"
#import "DownloadData.h"
#import "FilterController.h"
#import "LocalizeHelper.h"
#import "SVProgressHUD.h"
#import "InfoDRDViewController.h"
#import "DetailViewController.h"

@interface MainViewController ()<UISearchBarDelegate , UIActionSheetDelegate>

@end
typedef enum { English = 0 , VietNamese = 1 } SegmentLanguages ;
typedef enum { Share = 0 , Favorite = 1 , Info = 2} RoundMenuButton;
@implementation MainViewController
{
    CustomAlertViewController * customAlertView;
    ToolView * toolView;
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
    // Do any additional setup after loading the view.
    self.fakeButtonSearchBarClicked.hidden = YES;
    /* Add the search bar */
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(53, 0, SCREEN_WIDTH-53-53, 44)];
    self.searchBar.delegate = self;
    self.navigationItem.titleView = self.searchBar;
    [self setCustomNavigationBackButton];
    [self setUpRoundButton];
}

/**
 *  Setup back button item
 */
- (void)setCustomNavigationBackButton
{
    UIImage *backBtn = [UIImage imageNamed:@"main_back_button"];
    backBtn = [backBtn imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationController.navigationBar.backIndicatorImage = backBtn;
    self.navigationController.navigationBar.backIndicatorTransitionMaskImage = backBtn;
    // Cheat to hide title
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -66) forBarMetrics:UIBarMetricsDefault];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString * segueName = segue.identifier;
    if ([segueName isEqualToString: @"mapViewSegue"]) {
        self._mapViewController = (ViewController *) [segue destinationViewController];
        ViewController *viewController = (ViewController *)self._mapViewController;
        viewController.parentController = self;
    }
    else if ([segueName isEqualToString: @"searchBarSegue"]) {
        //Save the searchController
        SearchTableViewController* searchController = (SearchTableViewController *)[segue destinationViewController];
        searchController.container = self;
    }
    else if ([segueName isEqualToString: @"bookmarkSegue"]) {
        //Save the bookmarkContoller
        BookmarkTableViewController* bookmarkController = (BookmarkTableViewController *)[segue destinationViewController];
        bookmarkController.container = self;
    }
    else if ([segueName isEqualToString:@"RouteViewSegue"])
    {
        RouteViewController * routeview = (RouteViewController *)[segue destinationViewController];
        routeview.container = self;
    }
    else if ([segueName isEqualToString:@"kPushToDetailViewController"]) {
        ViewController *viewController = (ViewController *)self._mapViewController;
        DetailViewController * detailViewController = (DetailViewController *)[segue destinationViewController];
        detailViewController.locationInfo = viewController.placeInfoView.customMarker.location;
    }
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    [self.fakeButtonSearchBarClicked sendActionsForControlEvents:UIControlEventTouchUpInside];
    return NO;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)reloadButtonClick {
    ViewController* mapView = (ViewController*)self._mapViewController;
    [mapView reloadMarker];
}
- (IBAction)showMapMenu:(id)sender {
    [self addToolView];
}

-(void)addToolView {
    [self.view layoutSubviews];
    toolView = [[[NSBundle mainBundle] loadNibNamed:@"ToolView" owner:self options:nil] objectAtIndex:0];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    toolView.frame = CGRectMake(0, 0, screenWidth, screenHeight);
//    CGRect frame1 = toolView.frame;
    self.navigationController.navigationBarHidden = YES;
    [self.view setAlpha:0.9];
    [self.view addSubview:toolView];
    [toolView.doneButton addTarget:self action:@selector(removeView) forControlEvents:UIControlEventTouchUpInside];
    [toolView addTarget:self action:@selector(removeView) forControlEvents:UIControlEventTouchUpInside];
    [toolView.updateDatabaseButton addTarget:self action:@selector(updatePlaces) forControlEvents:UIControlEventTouchUpInside];
    [toolView.sliderRange addTarget:self action:@selector(changeRadiusRange) forControlEvents:UIControlEventValueChanged];
    [toolView.selectPlaceType addTarget:self action:@selector(didMoveToFilterViewController) forControlEvents:UIControlEventTouchUpInside];
    [toolView.aboutButton addTarget:self action:@selector(viewAboutInfo) forControlEvents:UIControlEventTouchUpInside];
    NSString * language =[[NSUserDefaults standardUserDefaults] objectForKey:@"appLanguage"];
    toolView.languageSelected.selectedSegmentIndex = ([language isEqualToString:@"en"]) ? English : VietNamese;
    [toolView.languageSelected addTarget:self action:@selector(changeLanguageForApp:) forControlEvents:UIControlEventValueChanged];
}

-(void)didMoveToFilterViewController
{
    FilterController * filterView = [self.storyboard instantiateViewControllerWithIdentifier:@"filterVC"];
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController pushViewController:filterView animated:YES];
    
}


-(void)viewAboutInfo{
//    NSArray *viewsToRemove = [self.view subviews];
//    NSLog(@"CCC %lu",(unsigned long)[viewsToRemove count]);
//    for (UIView *v in viewsToRemove) {
//        [v removeFromSuperview];
//    }
//    NSArray * array = self.childViewControllers;
    InfoDRDViewController * infoViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"infoVC"];
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController pushViewController:infoViewController animated:YES];
}

-(void)changeLanguageForApp:(UISegmentedControl *)segmentControl
{
    if (segmentControl.selectedSegmentIndex == English) {
        [[NSUserDefaults standardUserDefaults] setObject:@"en" forKey:@"appLanguage"];
    }
    else {
        [[NSUserDefaults standardUserDefaults] setObject:@"vi" forKey:@"appLanguage"];
    }
    NSString * language = [[NSUserDefaults standardUserDefaults]objectForKey:@"appLanguage"];
    [[LocalizeHelper sharedLocalSystem] setLanguage:language];
    [self reloadSubView];
}

-(void)reloadSubView {
    [toolView removeFromSuperview];
    toolView = nil;
    [self addToolView];
}
-(void)changeRadiusRange
{
    toolView.kilometerLable.text = [NSString stringWithFormat:@"%.0f km", toolView.sliderRange.value];
    [[NSUserDefaults standardUserDefaults] setInteger:(toolView.sliderRange.value + 0.5) forKey:@"radius"];
     ViewController* mapView = (ViewController*)self._mapViewController;
    [mapView reloadMarker];
}
-(void)removeView
{
    [self.view setAlpha:1.0];
    self.navigationController.navigationBarHidden = NO;
    [toolView removeFromSuperview];
    toolView = nil;
}

-(void)updatePlaces
{
    [SVProgressHUD showWithStatus:LocalizedString(@"loading")];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [DownloadData downloadWholePackage];
        // trigger the main completion handler when this completed
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:LocalizedString(@"Success")
                                                              message:LocalizedString(@"Update Success")
                                                             delegate:nil
                                                    cancelButtonTitle:LocalizedString(@"Ok")
                                                    otherButtonTitles:nil];
            [message show];
            [SVProgressHUD dismiss];
        });
    });

}
- (IBAction)locationButtonClicked:(id)sender {
    ViewController* mapView = (ViewController*)self._mapViewController;
    [mapView didSelectGetCurrentLocationButton];
}

- (void)setUpRoundButton {
    [self.roundButton loadButtonWithIcons:@[
                                            [UIImage imageNamed:@"map-share"],
                                            [UIImage imageNamed:@"map-favorite"],
                                            [UIImage imageNamed:@"map-info"]
                                            ] startDegree:-M_PI layoutDegree:M_PI/2];
    [self.roundButton setButtonClickBlock:^(NSInteger idx) {
        switch (idx) {
            case Share:
                [self performSegueWithIdentifier:@"addLocationSegue" sender:self];
                break;
            case Favorite:
                [self performSegueWithIdentifier:@"bookmarkSegue" sender:self];
                break;
            case Info:
                [self addToolView];
                break;
        }
        NSLog(@"button %@ clicked !",@(idx));
    }];
    [self.roundButton setTintColor:[UIColor whiteColor]];
    self.roundButton.centerButtonSize = CGSizeMake(44, 44);
    self.roundButton.mainColor = [UIColor colorWithRed:1.0 green:0.48 blue:0.1 alpha:1];
}
@end
