//
//  AddLocationViewController.m
//  MapGoogle
//
//  Created by Hackintosh on 10/18/14.
//  Copyright (c) 2014 apple. All rights reserved.
//

#import "AddLocationViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "AccessTypeTableViewController.h"
#import "LocationTypeTableViewController.h"
#import "Ulti.h"
#import "Reachability.h"
#import "LocationTemp.h"
#import "AppDelegate.h"
#import "SaveLocationTempTableController.h"
#import "LocationType.h"
#import "SubAcTableCell.h"
#import "CustomAlertViewController.h"
#import "TableViewController.h"
#import "LocalizeHelper.h"
#import "Utils.h"
#import "AccessType.h"

@interface AddLocationViewController ()<NSURLConnectionDataDelegate , CLLocationManagerDelegate , UITextFieldDelegate , AccessTypeDelegate>
{
    NSString *name;
    NSString *password;
    NSString *address;
    NSString *phone;
    NSString *latitude;
    NSString *longtitude;
    NSString *dateUpdate;
    NSNumber *typelocation;
    NSString *date_Update;
    NSString * userphonenumber;
    NSString * typeaccess;
    CLLocationManager *locationManager;
    NSArray *data;
    NSMutableArray *_locationType;
    CustomAlertViewController * alertView;
}
@property (weak, nonatomic) IBOutlet CustomTextField *mNameTextField;
@property (weak, nonatomic) IBOutlet CustomTextField *mPhoneTextField;
@property (weak, nonatomic) IBOutlet CustomTextField *mAddressTextField;
@property (weak, nonatomic) IBOutlet UIScrollView    *mCarouselScrollView;
//@property (weak, nonatomic) IBOutlet UIView          *mCarouselSubView;

@property (strong, nonatomic) NSMutableArray * access;
@end

@implementation AddLocationViewController
@synthesize comboBox ,access;

- (void)loadCarousel {
    [self.mCarouselScrollView setAlwaysBounceVertical:NO];
    
    NSArray * measureData = [AccessType getAllData];
    for (int i = 0 ; i < 5 ; i++) {
        CGFloat xOrigin = i * 50 + (i * 20);

        UIButton * accessType = [[UIButton alloc]initWithFrame:CGRectMake(xOrigin, 0, 50, 50)];
        AccessType * selectedImage = [measureData objectAtIndex:i];
        [accessType setImage:[AccessType getImageByAcessTypeID:[selectedImage.accessTypeID intValue]] forState:UIControlStateNormal];
//        [accessType setBackgroundImage:[AccessType getImageByAcessTypeID:[selectedImage.accessTypeID intValue]] forState:UIControlStateNormal];
        accessType.selected = NO;
        accessType.tag = i;
        [accessType addTarget:self action:@selector(selectAccessType:) forControlEvents:UIControlEventTouchUpInside];
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        [accessType addGestureRecognizer:longPress];

        [self.mCarouselScrollView addSubview:accessType];
    }
    self.mCarouselScrollView.contentSize = CGSizeMake(self.mCarouselScrollView.frame.size.width + (1 * 50),
                                                      self.mCarouselScrollView.frame.size.height);
}

- (void)longPress:(UILongPressGestureRecognizer*)gesture {
    CMPopTipView *popTipView = [[CMPopTipView alloc] initWithTitle:@"Test" message:@"Test 123"];
    [popTipView presentPointingAtView:gesture.view inView:self.view animated:YES];
    NSLog(@"Long Press");
    if ( gesture.state == UIGestureRecognizerStateEnded ) {
        NSLog(@"Long Press End");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [popTipView dismissAnimated:YES];
        });
        
    }
}

- (void)selectAccessType:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
         [sender setImage:[UIImage imageNamed:@"map_sharing_selected"] forState:UIControlStateNormal];
    } else {
        NSArray * measureData = [AccessType getAllData];
        AccessType * selectedImage = [measureData objectAtIndex:sender.tag];
        [sender setImage:[AccessType getImageByAcessTypeID:[selectedImage.accessTypeID intValue]] forState:UIControlStateNormal];
    }
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(BOOL)checkValidationAccount:(NSString *)account password:(NSString *)userPassword {
    if (account.length == 0 || userPassword.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LocalizedString(@"Error")
                                                        message:LocalizedString(@"Error Password")
                                                       delegate:nil
                                              cancelButtonTitle:LocalizedString(@"Ok")
                                              otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    return YES;
}

-(BOOL)checkValidInfo
{
    if(name.length == 0 || address.length == 0 || access.count==0 || typelocation==0 || longtitude == nil || latitude == nil){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LocalizedString(@"Error")
                                                        message:LocalizedString(@"Error Validation")
                                                       delegate:nil
                                              cancelButtonTitle:LocalizedString(@"Ok")
                                              otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    return YES;
}

-(void)postToServerByDRDStaff
{
    if ([Utils checkInternetConnection] == YES)
    {
        if ([self checkValidationAccount:alertView.userNameText.text password:alertView.passwordText.text] == NO) {
            return;
        }
        // JSON Location
        name = self._nameLocation.text;
        address = self._addressLocation.text;
        phone=self._phoneLocation.text;
        
        if ([self checkValidInfo] == NO) {
            return;
        }
        NSArray *keys = [NSArray arrayWithObjects:@"Location",@"User",nil];
        NSArray *array =[NSArray arrayWithObjects:latitude, longtitude, access,typelocation,name,address,phone, nil];
        
        NSArray *arrauser =[NSArray arrayWithObjects:userphonenumber,password ,nil];
        
        NSArray *objects = [NSArray arrayWithObjects:array,arrauser, nil];
        NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:objects
                                                               forKeys:keys];
        //[data addObject:dictionary];
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:nil];
        // Create the request
        @try {
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:POST_LOCATION_API]cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0];
            [request setHTTPMethod:@"POST"];
            [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)jsonData.length] forHTTPHeaderField:@"Content-Length"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setHTTPBody:jsonData];
            
            // Request Reply
            NSURLResponse *requestResponse;
            NSData *requestHandler = [NSURLConnection sendSynchronousRequest:request returningResponse:&requestResponse error:nil];
            
            NSString *requestReply = [[NSString alloc] initWithBytes:[requestHandler bytes] length:[requestHandler length] encoding:NSASCIIStringEncoding];
            NSLog(@"requestReply: %@", requestReply);
            
            //NSError* error = nil;
            //NSData* dat = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
            
            if([requestReply isEqualToString:@"1"]){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LocalizedString(@"Success")
                                                                message:LocalizedString(@"Success Post Message")
                                                               delegate:nil
                                                      cancelButtonTitle:LocalizedString(@"Ok")
                                                      otherButtonTitles:nil];
                [alert show];
                [self clearAllData];
                [self searchLocationTempName:name];
            }
            else
            {
                UIAlertView *message = [[UIAlertView alloc] initWithTitle:LocalizedString(@"Error")
                                                                  message:LocalizedString(@"Error Post")
                                                                 delegate:nil
                                                        cancelButtonTitle:LocalizedString(@"Ok")
                                                        otherButtonTitles:nil];
                [message show];
            }
        }
        
        @catch (NSException *exception) {
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:LocalizedString(@"Error")
                                                              message:LocalizedString(@"Error Post")
                                                             delegate:nil
                                                    cancelButtonTitle:LocalizedString(@"Ok")
                                                    otherButtonTitles:nil];
            [message show];
        }
    }
    else {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:LocalizedString(@"Error")
                                                          message:LocalizedString(@"Error Internet Connection")
                                                         delegate:nil
                                                cancelButtonTitle:LocalizedString(@"Ok")
                                                otherButtonTitles:nil];
        [message show];
    }
}

-(void)postToServerByEndUser
{
    if ([Utils checkInternetConnection] == YES)
    {
        name = self._nameLocation.text;
        address = self._addressLocation.text;
        phone=self._phoneLocation.text;
        userphonenumber = alertView.userNameText.text;
        if ([self checkValidInfo] == NO) {
            return;
        }
        NSArray *keys = [NSArray arrayWithObjects:@"Location", nil];
        NSArray *array =[NSArray arrayWithObjects:latitude, longtitude, access,typelocation,name,address,phone,userphonenumber, nil];
        NSArray *objects = [NSArray arrayWithObjects:array, nil];
        NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:objects
                                                               forKeys:keys];
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:nil];
        // Create the request
        @try {
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:POST_LOCATION_API]cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0];
            [request setHTTPMethod:@"POST"];
            [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)jsonData.length] forHTTPHeaderField:@"Content-Length"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setHTTPBody:jsonData];
            
            // Request Reply
            NSURLResponse *requestResponse;
            NSData *requestHandler = [NSURLConnection sendSynchronousRequest:request returningResponse:&requestResponse error:nil];
            
            NSString *requestReply = [[NSString alloc] initWithBytes:[requestHandler bytes] length:[requestHandler length] encoding:NSASCIIStringEncoding];
            NSLog(@"requestReply:%@", requestReply);
            
            if([requestReply isEqualToString:@"1"]){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LocalizedString(@"Success")
                                                                message:LocalizedString(@"Success Post Message")
                                                               delegate:nil
                                                      cancelButtonTitle:LocalizedString(@"Ok")
                                                      otherButtonTitles:nil];
                [alert show];
                [self clearAllData];
                [self searchLocationTempName:name];
            }
            else
            {
                UIAlertView *message = [[UIAlertView alloc] initWithTitle:LocalizedString(@"Error")
                                                                  message:LocalizedString(@"Error Post")
                                                                 delegate:nil
                                                        cancelButtonTitle:LocalizedString(@"Ok")
                                                        otherButtonTitles:nil];
                [message show];
            }
            
        }
        @catch (NSException *exception) {
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:LocalizedString(@"Error")
                                                              message:LocalizedString(@"Error Post")
                                                             delegate:nil
                                                    cancelButtonTitle:LocalizedString(@"Ok")
                                                    otherButtonTitles:nil];
            [message show];
        }
    }
    else {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:LocalizedString(@"Error")
                                                          message:LocalizedString(@"Error Internet Connection")
                                                         delegate:nil
                                                cancelButtonTitle:LocalizedString(@"Ok")
                                                otherButtonTitles:nil];
        [message show];
    }
}

- (IBAction)postLocation:(id)sender {
    
     alertView = [[CustomAlertViewController alloc]initWithFrame:CGRectMake(10, self.view.frame.size.height - 390, self.view.frame.size.width-20, 235)];
    self.view.backgroundColor = [UIColor lightGrayColor];
    self._addressLocation.backgroundColor = [UIColor lightGrayColor];
    self._nameLocation.backgroundColor = [UIColor lightGrayColor];
    self._phoneLocation.backgroundColor = [UIColor lightGrayColor];
    
    [alertView.selectUser addTarget:self action:@selector(switchUser) forControlEvents:UIControlEventValueChanged];
    
    [alertView.okButton addTarget:self action:@selector(doPostDataToServer) forControlEvents:UIControlEventTouchUpInside];
    
    [alertView.cancelButton addTarget:self action:@selector(dismissAlertView) forControlEvents:UIControlEventTouchUpInside];
    
    [UIView transitionWithView:self.view
                      duration:0.5
                       options:UIViewAnimationOptionTransitionCrossDissolve //any animation
                    animations:^ { [self.view addSubview:alertView.view]; }
                    completion:nil];
    //[self._scrollView addSubview:alertView.view];
    
}

-(void)doPostDataToServer
{
    if (alertView.selectUser.selectedSegmentIndex == 0)
    {
        [self postToServerByEndUser];
        [self dismissAlertView];
    }
    else
    {
        [self postToServerByDRDStaff];
        [self dismissAlertView];
    }
}

-(void)dismissAlertView
{
    [alertView.view removeFromSuperview];
    self.view.backgroundColor = [UIColor whiteColor];
    self._addressLocation.backgroundColor = [UIColor whiteColor];
    self._nameLocation.backgroundColor = [UIColor whiteColor];
    self._phoneLocation.backgroundColor = [UIColor whiteColor];
}

-(void)switchUser
{
    if(alertView.selectUser.selectedSegmentIndex == 0)
    {
        alertView.passwordText.hidden = YES;
        alertView.labelPassword.hidden = YES;
        alertView.passwordText.text = @"";
    }
    else
    {
        alertView.passwordText.hidden = NO;
        alertView.labelPassword.hidden = NO;
    }
}

- (IBAction)getKeyboardAway:(id)sender
{
    [sender resignFirstResponder];
}

-(void) clearAllData
{
    self._nameLocation.text = @"";
    self._addressLocation.text=@"";
    self._phoneLocation.text=@"";
    [self.selectAccessTypeButton setTitle:LocalizedString(@"Select") forState:UIControlStateNormal];
    //self.userphone.text=@"";
    [comboBox setLabelText:LocalizedString(@"Select")];
    access = nil;
    [self getKeyboardAway:self._addressLocation];

}

-(void) searchLocationTempName:(NSString*)locationtitle
{
    NSArray * getloctemp = [LocationTemp getUserData:[NSNumber numberWithInt:NO]];
    for (LocationTemp * loctemp in getloctemp)
    {
        if( [loctemp.title isEqualToString:locationtitle])
        {
            [LocationTemp removeSaveDataByName:loctemp.title];
        }
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [Utils checkInternetConnection];
    [locationManager startUpdatingLocation];
    
}
-(NSMutableArray *)setUpArray
{
    if (access == nil)
    {
        access = [[NSMutableArray alloc]init];
    }
    return access;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    phone = @"";
      data=[LocationType getAllData];
    _locationType = [[NSMutableArray alloc] init];
    [self localizeLanguage];
    locationManager = [[CLLocationManager alloc] init];
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
  
    //combo.textField.delegate = self;
    NSString *version = [[UIDevice currentDevice] systemVersion];
    int ver = [version intValue];
    if (ver < 7){
        //iOS 6 work
        comboBox = [[AJComboBox alloc] initWithFrame:self.comboboxView.frame andisUser:FALSE parentView:self.view];
        [comboBox setLabelText:LocalizedString(@"Select")];
        [comboBox setDelegate:self];
        [comboBox setTag:1];
        [comboBox setArrayData:_locationType];
        [self.view addSubview:comboBox];
    }
    else{
        //iOS 7 related work
        comboBox = [[AJComboBox alloc] initWithFrame:self.comboboxView.frame andisUser:FALSE parentView:self.view];
        [comboBox setLabelText:LocalizedString(@"Select")];
        [comboBox setDelegate:self];
        [comboBox setTag:1];
        [comboBox setArrayData:_locationType];
        [self.view addSubview:comboBox];
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self loadCarousel];
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString * segueName = segue.identifier;
    if ([segueName isEqualToString: @"LocationTypeSegue"]) {
        LocationTypeTableViewController * locationtype = [segue destinationViewController];
        locationtype.container = self;
        
    }
    else if ([segueName isEqualToString: @"AccessTypeSegue"]) {
        AccessTypeTableViewController * accesstype = [segue destinationViewController];
        accesstype.container = self;
        accesstype.settings =[[NSMutableArray alloc]initWithArray:access copyItems:YES];
    }
    else if ([segueName isEqualToString:@"SaveLocationTempSegue"])
    {
        SaveLocationTempTableController * savelocation = [segue destinationViewController];
        savelocation.container = self;
        savelocation.usercode = [NSNumber numberWithInt:NO];
    }
    else if ([segueName isEqualToString:@"accessTypeSG"])
    {
        TableViewController * accessTypeViewController = [segue destinationViewController];
        accessTypeViewController.delegate = self;
        accessTypeViewController.selectedAccessType = [access mutableCopy];
    }
    
}

- (void) saveLocationType:(LocationType*)locationtype
{
    typelocation = locationtype.locationTypeID;
}

-(void)didSelectMultipleTypes:(NSMutableArray *)listId
{
    access = [[NSMutableArray alloc]initWithArray:listId copyItems:YES];
    access = (NSMutableArray *)[access sortedArrayUsingSelector:@selector(compare:)];
    if ([listId count]) {
        typeaccess = @"";
        for (int i = 0; i < access.count ; i++)
        {
            if (i == access.count -1 )
            {
                typeaccess = [typeaccess stringByAppendingString:[NSString stringWithFormat:@"%d",(int)[access indexOfObject:access[i]]+1]];
            }
            else
            {
                typeaccess = [typeaccess stringByAppendingString:[NSString stringWithFormat:@"%d,",(int)[access indexOfObject:access[i]]+1]];
            }
        }
        [self.selectAccessTypeButton setTitle:typeaccess forState:UIControlStateNormal];
        return;
    }
    [self.selectAccessTypeButton setTitle:LocalizedString(@"Select") forState:UIControlStateNormal];
}

- (void) saveAccessType: (NSMutableArray*)settings andNumberOfArray:(int)number numberOfCell:(NSMutableArray *)listOfSelected
{
    access = [[NSMutableArray alloc]initWithArray:settings copyItems:YES];
    access = (NSMutableArray *)[access sortedArrayUsingSelector:@selector(compare:)];
    //NSString * accessTypeString = @"";
    typeaccess = @"";
    for (int i = 0; i < access.count ; i++)
    {
        if (i == access.count -1)
        {
            typeaccess = [typeaccess stringByAppendingString:[NSString stringWithFormat:@"%d",(int)[listOfSelected[i]integerValue]+1]];
        }
        else
        {
            typeaccess = [typeaccess stringByAppendingString:[NSString stringWithFormat:@"%d,",(int)[listOfSelected[i]integerValue]+1]];
        }
    }
    [self.selectAccessTypeButton setTitle:typeaccess forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// Thong bao GPS khong hoat dong
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:LocalizedString(@"Error")
                               message:LocalizedString(@"Error GPS")
                               delegate:nil
                               cancelButtonTitle:LocalizedString(@"Ok")
                               otherButtonTitles:nil];
    [errorAlert show];
}
// Lay GPS hien tai
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    //NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        longtitude = [NSString stringWithFormat:@"%.6f", currentLocation.coordinate.longitude];
        latitude = [NSString stringWithFormat:@"%.6f", currentLocation.coordinate.latitude];
    }

}



#pragma mark - Navigation


//Save info location
- (IBAction)Save:(id)sender {
    [self storeLocationTempToCoreData];
}

-(void)storeLocationTempToCoreData
{
    name = self._nameLocation.text;
    address = self._addressLocation.text;
    phone=self._phoneLocation.text;
    if ([self checkValidInfo] == NO) {
        return;
    }
    NSArray * getdata = [LocationTemp getUserData:[NSNumber numberWithInt:NO]];
    for(LocationTemp * loctemp in getdata)
    {
        if ([loctemp.latitude isEqualToString:latitude] && [loctemp.longtitude isEqualToString:longtitude])
        {
            [LocationTemp removeSaveDataByName:loctemp.title];
        }
    }

    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"LocationTemp" inManagedObjectContext:context];
    LocationTemp * locationTemp = [[LocationTemp alloc]initWithEntity:entityDescription insertIntoManagedObjectContext:nil];
    locationTemp.address = address;
    locationTemp.title = name;
    locationTemp.phone = phone;
    //locationTemp.userphone = userphonenumber;
    locationTemp.longtitude = longtitude;
    locationTemp.latitude = latitude;
    locationTemp.locationtype = typelocation;
    locationTemp.accesstype = typeaccess;
    locationTemp.isUser = [NSNumber numberWithInt:NO];
    [LocationTemp insert:locationTemp];
    // message
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LocalizedString(@"Success")
                                                        message:LocalizedString(@"Success Save Message")
                                                       delegate:nil
                                              cancelButtonTitle:LocalizedString(@"Ok")
                                              otherButtonTitles:nil];
        [alert show];
    [self clearAllData];
}
// Load Information from Location Temp

- (void) loadSaveLocationType:(LocationTemp*) locationtemp
{
    self._nameLocation.text = locationtemp.title;
    self._addressLocation.text = locationtemp.address;
    self._phoneLocation.text = locationtemp.phone;
    //self.userphone.text = locationtemp.userphone;
    typeaccess = locationtemp.accesstype;
    typelocation = locationtemp.locationtype;
    longtitude = locationtemp.longtitude;
    latitude = locationtemp.latitude;
    LocationType * locationtype =[LocationType getLocationTypeById:[typelocation intValue]];
    [comboBox setLabelText:locationtype.locationName];
    //[access removeAllObjects];
    access = [[NSMutableArray alloc]init];
     [self.selectAccessTypeButton setTitle:typeaccess forState:UIControlStateNormal];
    access = (NSMutableArray *)[typeaccess componentsSeparatedByString:@","];
}

- (IBAction)_doneButton:(id)sender {
    SaveLocationTempTableController * savelocation = (SaveLocationTempTableController*)[self.storyboard instantiateViewControllerWithIdentifier:@"SaveLocationTemp"];
    savelocation.container = self;
    savelocation.usercode = [NSNumber numberWithInt:NO];
    [self.navigationController pushViewController:savelocation animated:YES];
}


-(void)didChangeComboBoxValue:(AJComboBox *)comboBox selectedIndex:(NSInteger)selectedIndex
{
    for(int i=0;i<data.count;i++){
        LocationType* locType = (LocationType*) [data objectAtIndex:i];
        NSArray * lang =  [[NSUserDefaults standardUserDefaults]objectForKey:@"Language"];
        if ([lang count] >1)
        {
            if([locType.locationName_en isEqualToString:[_locationType objectAtIndex:selectedIndex]]){
                typelocation=locType.locationTypeID;
            }
        }
        else
        {
            if([locType.locationName isEqualToString:[_locationType objectAtIndex:selectedIndex]]){
                typelocation=locType.locationTypeID;
            }
        }
        
    }
}
#pragma Localize language 
-(void)localizeLanguage {
    self.infoLabel.text = LocalizedString(@"Place Information");
    self.placeTypeLabel.text = LocalizedString(@"Place Category");
    self._phoneLocation.attributedPlaceholder = [[NSAttributedString alloc]initWithString:LocalizedString(@"Place Phone")];
    self._addressLocation.attributedPlaceholder = [[NSAttributedString alloc]initWithString:LocalizedString(@"Place Address")];
    self._nameLocation.attributedPlaceholder = [[NSAttributedString alloc]initWithString:LocalizedString(@"Place Name")];
    self.measureTypeLabel.text = LocalizedString(@"Measure Accessibility");
    [self.selectAccessTypeButton setTitle:LocalizedString(@"Select") forState:UIControlStateNormal];
    self.selectAccessTypeButton.layer.cornerRadius = 5.0f;
    [self.viewListButton setTitle:LocalizedString(@"Saved places")];
    [self.postButton setTitle:LocalizedString(@"Post to server") forState:UIControlStateNormal];
    [self.saveButton setTitle:LocalizedString(@"Save to list") forState:UIControlStateNormal];
    NSString * languageKey = [[NSUserDefaults standardUserDefaults] objectForKey:APP_LANGUAGE];
    for(int i=0;i<data.count;i++){
        LocationType* locType = (LocationType*) [data objectAtIndex:i];
        if ([languageKey isEqualToString:@"vi"]) {
            [_locationType addObject:locType.locationName];
        }
        else
        {
            [_locationType addObject:locType.locationName_en];
        }
    }
}

@end
