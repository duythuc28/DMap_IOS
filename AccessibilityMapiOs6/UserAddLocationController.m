//
//  UserAddLocationController.m
//  MapGoogle
//
//  Created by Hackintosh on 10/22/14.
//  Copyright (c) 2014 apple. All rights reserved.
//

#import "UserAddLocationController.h"
#import <CoreLocation/CoreLocation.h>
#import "AccessTypeTableViewController.h"
#import "LocationTypeTableViewController.h"
#import "Ulti.h"
#import "Reachability.h"
#import "LocationTemp.h"
#import "AppDelegate.h"
#import "SaveLocationTempTableController.h"
#import "LocationType.h"
#import "ComboBox.h"
#import "TableViewController.h"
@interface UserAddLocationController ()<NSURLConnectionDataDelegate , CLLocationManagerDelegate , AccessTypeDelegate>
{
    NSString *name;
    NSString *address;
    NSString *phone;
    NSString *latitude;
    NSString *longtitude;
    NSString *dateUpdate;
    NSNumber *typelocation;
    NSString *date_Update;
    NSString * userphonenumber;
    NSString * password;
    NSMutableArray * access;
    NSString * typeaccess;
    CLLocationManager *locationManager;
    Reachability *internetReachableFoo;
    NSArray *data;
    ComboBox *combo;
    NSMutableArray *_locationType;
    
    NSString * error_ms;
    NSString * success;
    NSString * sc_info;
    NSString * sc_save;
    NSString * error_save;
    NSString * error_GPS;
    NSString * error_timeout;
    NSString * error_Internet;
    NSString * error_lackinfo;
    NSString * select;
    NSString * user_pw;
    NSString * list;
}
@end

@implementation UserAddLocationController
bool isConnect;
//static NSString *POST_COMMENT_API = @"http://mapsdemo.tk/web/api/post/location";
@synthesize comboBox;
- (IBAction)Save:(id)sender {
    [self storeLocationTempToCoreData];
}

-(void)didSelectMultipleTypes:(NSMutableArray *)listId
{
    access = listId;
    typeaccess = @"";
    for (int i = 0; i < access.count ; i++)
    {
        typeaccess = [typeaccess stringByAppendingString:[NSString stringWithFormat:@"%ld",(long)[access[i] integerValue]]];
    }
    NSLog(@"%@",typeaccess);
}

- (IBAction)selectAccessType:(id)sender {
    self.subacc = [[SubAcViewController alloc]initWithNibName:@"SubAcViewController" bundle:nil withparentcontroller:self withSettings:access];
    [self._scrollView addSubview:self.subacc.view];
    //self.subacc.view.frame = CGRectMake(0, 45, 320, 500);
}

- (IBAction)getKeyboardAway:(id)sender
{
    [sender resignFirstResponder];
}

- (IBAction)postLocation:(id)sender {
    
    if (isConnect == TRUE)
    {
        //JSON USER
        //NSMutableArray *user = [[NSMutableArray alloc] init];
        userphonenumber = self.userphone.text;
        password = self.userpassword.text;
        NSMutableArray *user = [[NSMutableArray alloc] initWithObjects:userphonenumber,password, nil];
        [[NSUserDefaults standardUserDefaults] setObject:user forKey:@"user"];
        if (userphonenumber.length ==0 || password.length ==0)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:error_ms
                                                            message:user_pw
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
        
        // JSON Location
        name = self._name.text;
        address = self._address.text;
        phone=self._phone.text;
        //userphonenumber = self.userphone.text;
        if(name.length == 0 || address.length == 0 || access.count==0 || typelocation==0 || userphonenumber.length == 0 || longtitude == nil || latitude == nil){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:error_ms
                                                            message:error_lackinfo
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
        if (phone == nil)
        {phone = @"";}
        
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
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:success
                                                                message:sc_info
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
                [self clearAllData];
                [self searchLocationTempName:name];
            }
            else
            {
                UIAlertView *message = [[UIAlertView alloc] initWithTitle:error_ms
                                                                  message:error_save
                                                                 delegate:nil
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles:nil];
                [message show];
            }
        }
        
        @catch (NSException *exception) {
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:error_ms
                                                              message:error_timeout
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
            [message show];
        }
        
        
    }
    
    
    
    
    
    else
    {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:error_ms                                                          message:error_Internet
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
    }

}

-(void) clearAllData
{
    self._name.text = @"";
    self._address.text=@"";
    self._phone.text=@"";
    [comboBox setLabelText:select];
    access = nil;
    [self getKeyboardAway:self._address];
    
}

-(void) searchLocationTempName:(NSString*)locationtitle
{
    NSArray * getloctemp = [LocationTemp getUserData:[NSNumber numberWithInt:YES]];
    for (LocationTemp * loctemp in getloctemp)
    {
        if( [loctemp.title isEqualToString:locationtitle])
        {
            [LocationTemp removeSaveDataByName:loctemp.title];
        }
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
- (void)testInternetConnection
{
    internetReachableFoo = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    // Internet is reachable
    internetReachableFoo.reachableBlock = ^(Reachability*reach)
    {
        isConnect = TRUE;
    };
    
    // Internet is not reachable
    internetReachableFoo.unreachableBlock = ^(Reachability*reach)
    {
        isConnect = FALSE;
        
    };
    
    [internetReachableFoo startNotifier];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self testInternetConnection];
    [locationManager startUpdatingLocation];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    data=[LocationType getAllData];
    NSArray * lang =  [[NSUserDefaults standardUserDefaults]objectForKey:@"Language"];
    if ([lang count] >1 )
    {
        error_ms = @"Error";
        success = @"Success";
        sc_info = @"You have post data to server successfully";
        error_save = @"Your information has already saved";
        error_GPS = @"Your device do not have GPS";
        error_timeout = @"Your Internet is not strong enough to post data";
        error_Internet = @"Your device does not connect to Internet";
        error_lackinfo = @"Please fill all of the field";
        select = @"- SELECT -";
        user_pw = @"Please fill your user phone and password";
        list= @"List";
        sc_save = @"You have save to waiting list";
        _locationType = [[NSMutableArray alloc] init];
        for(int i=0;i<data.count;i++){
            LocationType* locType = (LocationType*) [data objectAtIndex:i];
            [_locationType addObject:locType.locationName_en];
        }

    }
    else
    {
        error_ms = @"Lỗi";
        success = @"Thành công";
        sc_info = @"Bạn đã gửi phản hồi thành công";
        error_save = @"Dữ liệu đã được lưu";
        error_GPS = @"Thiết bị của bạn không kết nối GPS";
        error_timeout = @"Internet của bạn không đủ để tải dữ liệu";
        error_Internet = @"Bạn không có Internet";
        error_lackinfo = @"Bạn chưa đủ dữ liệu";
        select = @"- LỰA CHỌN -";
        user_pw = @"Bạn chưa nhập số điện thoại và mật khẩu";
        list= @"Xem danh sách";
        sc_save = @"Bạn đã lưu dữ liệu thành công";
        _locationType = [[NSMutableArray alloc] init];
        for(int i=0;i<data.count;i++){
            LocationType* locType = (LocationType*) [data objectAtIndex:i];
            [_locationType addObject:locType.locationName];
        }

    }

    
    NSArray *arrauser =[[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    self.userphone.text = [arrauser objectAtIndex:0];
    self.userpassword.text = [arrauser objectAtIndex:1];
    self.userpassword.secureTextEntry = TRUE;
    
    UIBarButtonItem *flipButton = [[UIBarButtonItem alloc]
                                   initWithTitle:list
                                   style:UIBarButtonItemStyleBordered
                                   target:self
                                   action:@selector(flipView)];
    self.navigationItem.rightBarButtonItem = flipButton;
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    // Do any additional setup after loading the view.
    
    
    
    
    /* //Goi comboBox add du lieu vao Combobox
    combo = [[ComboBox alloc] init];
    [combo setComboData:_locationType];  //Assign the array to ComboBox
    [self._scrollView addSubview:combo.view];
    combo.view.frame = CGRectMake(150,138,140,30);*/
    
    
    NSString *version = [[UIDevice currentDevice] systemVersion];
    int ver = [version intValue];
    if (ver < 7){
        //iOS 6 work
        comboBox = [[AJComboBox alloc] initWithFrame:CGRectMake(151,141,160,31) andisUser:TRUE parentView:self._scrollView];
        [comboBox setLabelText:select];
        [comboBox setDelegate:self];
        [comboBox setTag:1];
        [comboBox setArrayData:_locationType];
        [self._scrollView addSubview:comboBox];
    }
    else{
        //iOS 7 related work
        comboBox = [[AJComboBox alloc] initWithFrame:CGRectMake(151,145,160,31) andisUser:TRUE parentView:self._scrollView];
        [comboBox setLabelText:select];
        [comboBox setDelegate:self];
        [comboBox setTag:1];
        [comboBox setArrayData:_locationType];
        [self._scrollView addSubview:comboBox];
    }


}

// Done button
-(IBAction)flipView
{
    SaveLocationTempTableController * savelocation = (SaveLocationTempTableController*)[self.storyboard instantiateViewControllerWithIdentifier:@"SaveLocationTemp"];
    savelocation.container = self;
    savelocation.usercode = [NSNumber numberWithInt:YES];
    [self.navigationController pushViewController:savelocation animated:YES];

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
    else if ([segueName isEqualToString:@"UserAddLocationSegue"])
    {
        SaveLocationTempTableController * savelocation = [segue destinationViewController];
        savelocation.container = self;
        savelocation.usercode = [NSNumber numberWithInt:YES];
    }
    
    
}

- (void) saveLocationType:(LocationType*)locationtype
{
    typelocation = locationtype.locationTypeID;
    //self.locationtypename.text = locationtype.locationName;
}

- (void) saveAccessType:(NSMutableArray *)settings
{
    access = [[NSMutableArray alloc]initWithArray:settings copyItems:YES];
    typeaccess = @"";
    for (int i = 0; i < access.count ; i++)
    {
        typeaccess = [typeaccess stringByAppendingString:[NSString stringWithFormat:@"%ld",(long)[access[i] integerValue]]];
    }
    NSLog(@"%@",typeaccess);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:error_ms message:error_GPS delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
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

-(void)storeLocationTempToCoreData
{
    userphonenumber = self.userphone.text;
    password = self.userpassword.text;
    name = self._name.text;
    address = self._address.text;
    phone=self._phone.text;
    //userphonenumber = self.userphone.text;
    NSArray * getdata = [LocationTemp getUserData:[NSNumber numberWithInt:YES]];
    for(LocationTemp * loctemp in getdata)
    {
        
        if ([loctemp.latitude isEqualToString:latitude] && [loctemp.longtitude isEqualToString:longtitude] && [loctemp.title isEqualToString:name])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:success
                                                            message:sc_save
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            return;

        }
    }
    if (phone == nil)
    {phone = @"";}
    //
    if(name.length == 0 || address.length == 0 || access.count==0 || typelocation==0 || longtitude ==nil || latitude == nil || userphonenumber.length ==0 || password.length ==0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:error_ms
                                                        message:error_lackinfo
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    
        NSMutableArray *user = [[NSMutableArray alloc] initWithObjects:userphonenumber,password, nil];
        [[NSUserDefaults standardUserDefaults] setObject:user forKey:@"user"];
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *context = [appDelegate managedObjectContext];
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"LocationTemp" inManagedObjectContext:context];
        LocationTemp * locationTemp = [[LocationTemp alloc]initWithEntity:entityDescription insertIntoManagedObjectContext:nil];
        locationTemp.address = address;
        locationTemp.title = name;
        locationTemp.phone = phone;
        locationTemp.longtitude = longtitude;
        locationTemp.latitude = latitude;
        locationTemp.locationtype = typelocation;
        locationTemp.accesstype = typeaccess;
        locationTemp.isUser = [NSNumber numberWithInt:YES];
        [LocationTemp insert:locationTemp];
        // message
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:success
                                                        message:sc_save
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    [self clearAllData];
}
// Load Information from Location Temp

- (void) loadSaveLocationType:(LocationTemp*) locationtemp
{
    NSArray *arrauser =[[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    self.userphone.text = [arrauser objectAtIndex:0];
    self.userpassword.text = [arrauser objectAtIndex:1];
    self._name.text = locationtemp.title;
    self._address.text = locationtemp.address;
    self._phone.text = locationtemp.phone;
    //self.userphone.text = locationtemp.userphone;
    typeaccess = locationtemp.accesstype;
    typelocation = locationtemp.locationtype;
    longtitude = locationtemp.longtitude;
    latitude = locationtemp.latitude;
    LocationType * locationtype =[LocationType getLocationTypeById:[typelocation intValue]];
    [comboBox setLabelText:locationtype.locationName];
    //[access removeAllObjects];
    access = [[NSMutableArray alloc]init];
    for(NSInteger i = 0; i < typeaccess.length; ++i) {
        [access addObject:[NSString stringWithFormat:@"%c",[typeaccess characterAtIndex:i]]];
        //NSLog(@"%c",[typeaccess characterAtIndex:i]);
    }
    
}

-(void)didChangeComboBoxValue:(AJComboBox *)comboBox selectedIndex:(NSInteger)selectedIndex
{
    for(int i=0;i<data.count;i++){
        LocationType* locType = (LocationType*) [data objectAtIndex:i];
        NSArray * lang =  [[NSUserDefaults standardUserDefaults]objectForKey:@"Language"];
        if ([lang count] >1 )
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
