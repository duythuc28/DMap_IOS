//
//  DownloadData.m
//  MapGoogle
//
//  Created by apple on 10/11/14.
//  Copyright (c) 2014 apple. All rights reserved.
//

#import "DownloadData.h"
#import "AppDelegate.h"
#import "Location.h"
#import "LocationType.h"
#import "AccessType.h"
#import "Comment.h"
#import "Base64.h"
#import "RequestDataManager.h"
@implementation DownloadData


+ (NSArray *) downloadCommentFromLocationID:(NSString*)locationId{
    @try {
        NSString *url = [NSString stringWithFormat:@"%@%@",COMMENT_API, locationId];
        NSURL *jsonURL = [NSURL URLWithString:url];
        NSURLResponse *response = nil;
        NSError* error = nil;
        NSData* data = [NSURLConnection sendSynchronousRequest:[[NSURLRequest alloc] initWithURL:jsonURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:(20.0)] returningResponse:&response error:&error];
        
        NSArray *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSMutableArray *returnArray = [[NSMutableArray alloc]init];
        for(NSArray * data in json){
            Comment * comment = [[Comment alloc]init];
            comment.name = [data valueForKeyPath:@"name"];
            comment.content = [data valueForKeyPath:@"Content"];
            [returnArray addObject:comment];
        }
        return returnArray;
        
    }
    @catch (NSException *exception) {
        return NULL;
    }
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"time out");
}

+ (BOOL)downloadLocation{
    id lastupdate = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastupdate"];
    NSString* timestamp = @"0";
    if(lastupdate)
    {
        timestamp = lastupdate;
    }
    NSString *url = [NSString stringWithFormat:@"%@%@",LOCATION_API,timestamp];
    RequestDataManager * requestData = [[RequestDataManager alloc]initWithUrl:url];
    [requestData setRequestMethod:GET];
    [requestData requestHTMLDataSuccess:^(NSURLSessionTask *operation, id response) {
        NSDictionary * responseData = response;
        [DownloadData storeLocationToCoreData:(NSArray*)[responseData objectForKey:@"Location"]];
        NSString* lastUpdate = [responseData objectForKey:@"Time"];
        [[NSUserDefaults standardUserDefaults] setObject:lastUpdate forKey:@"lastupdate"];

    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Can not download data");
    }];
    return YES;
}

+ (void)downloadLocationWithCompletionHandler:(void (^) (BOOL finished))completionHandler {
    id lastupdate = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastupdate"];
    NSString* timestamp = @"0";
    if(lastupdate)
    {
        timestamp = lastupdate;
    }
    NSString *url = [NSString stringWithFormat:@"%@%@",LOCATION_API,timestamp];
    RequestDataManager * requestData = [[RequestDataManager alloc]initWithUrl:url];
    [requestData setRequestMethod:GET];
    [requestData requestHTMLDataSuccess:^(NSURLSessionTask *operation, id response) {
        NSDictionary * responseData = response;
        [DownloadData storeLocationToCoreData:(NSArray*)[responseData objectForKey:@"Location"]];
        NSString* lastUpdate = [responseData objectForKey:@"Time"];
        [[NSUserDefaults standardUserDefaults] setObject:lastUpdate forKey:@"lastupdate"];
        completionHandler(YES);
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Can not download data");
        completionHandler(NO);
    }];
}

+ (void) storeLocationToCoreData:(NSArray*)json{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Location" inManagedObjectContext:context];
    
    for(NSDictionary *data in json)
    {
        BOOL isActive = [[data valueForKeyPath:@"isActive"] boolValue];
        if(!isActive){
            [Location deleteDataWithLatitude:[data valueForKeyPath:@"Latitude"] andLongtitude:[data valueForKeyPath:@"Longitude"]];
        }
        else{
            Location* location  = [[Location alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:nil];
            location.locationID = [NSNumber numberWithInt:[[data valueForKeyPath:@"LocationID"]intValue]];
            location.latitude   = [data valueForKeyPath:@"Latitude"];
            location.longtitude = [data valueForKeyPath:@"Longitude"];
            NSArray* idcodesArray    = [data valueForKeyPath:@"AccessType"];
            NSMutableSet * set = [[NSMutableSet alloc]init];
            for(NSNumber* perCode in idcodesArray){
                [set addObject:[AccessType getTypeById:[perCode intValue]]];
            }
            location.title      = [data valueForKeyPath:@"Title"];
            location.address    = [data valueForKeyPath:@"Address"];
            location.phone      = [data valueForKeyPath:@"Phone"];
            
            [Location insertWithCheck:location accessRelation:set locationTypeRelation:[LocationType getLocationTypeById:(int)[[data valueForKeyPath:@"LocationType"] integerValue]]];
        }
    }
    
}


+ (BOOL)downloadAccessType{
    id lastupdate = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastupdate"];
    NSString* timestamp = @"0";
    if(lastupdate)
    {
       timestamp = lastupdate;
    }
    NSString * url = [NSString stringWithFormat:@"%@%@",ACCESSTYPE_API,timestamp];
    RequestDataManager * requestData = [[RequestDataManager alloc]initWithUrl:url];
    [requestData setRequestMethod:GET];
    [requestData requestHTMLDataSuccess:^(NSURLSessionTask *operation, id response) {
        NSDictionary * json = response;
        [DownloadData storeAccessTypeToCoreData:(NSArray*)[json objectForKey:@"AccessibilityType"]];
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Can not download Access Type");
        NSLog(@"Error %@",error.description);
    }];
    return YES;
}

+ (void)downloadMeasureTypeWithCompletionHandler:(void (^) (BOOL finished))completionHandler {
    id lastupdate = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastupdate"];
    NSString* timestamp = @"0";
    if(lastupdate)
    {
        timestamp = lastupdate;
    }
    NSString * url = [NSString stringWithFormat:@"%@%@",ACCESSTYPE_API,timestamp];
    RequestDataManager * requestData = [[RequestDataManager alloc]initWithUrl:url];
    [requestData setRequestMethod:GET];
    [requestData requestHTMLDataSuccess:^(NSURLSessionTask *operation, id response) {
        NSDictionary * json = response;
        [DownloadData storeAccessTypeToCoreData:(NSArray*)[json objectForKey:@"AccessibilityType"]];
        completionHandler(YES);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Can not download Access Type");
        NSLog(@"Error %@",error.description);
        completionHandler(NO);
    }];
}

+ (void)postSharingLocationWithParams:(NSDictionary *)params
                    completionHandler:(void (^) (NSURLSessionTask *operation, id response))completionHandler
                              failure:(void (^)(NSURLSessionTask *operation, NSError *error)) failure {
    RequestDataManager * requestData = [[RequestDataManager alloc]initWithUrl:POST_LOCATION_API];
    [requestData setRequestMethod:POST];
    [requestData setParameters:params];
    [requestData requestDataSuccess:^(NSURLSessionTask *operation, id response) {
        completionHandler (operation, response);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        failure (operation , error);
    }];
}

+ (void)storeAccessTypeToCoreData:(NSArray *)json{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"AccessType" inManagedObjectContext:context];
    //First remove all data in AccessType
    //[AccessType removeAllData];
    
    //
    for(NSArray *data in json)
    {
        AccessType* accessType  = [[AccessType alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:nil];
        accessType.accessTypeID =       [NSNumber numberWithInt:[[data valueForKeyPath:@"ACType_ID"]intValue]];
        accessType.accessName   =       [data valueForKeyPath:@"Name"];
        accessType.accessDescribtion =  [data valueForKeyPath:@"Description"];
        accessType.accessImageLink = [NSString stringWithFormat:@"/AccessTypeIcons/%d.png",[accessType.accessTypeID intValue]];
        accessType.accessName_en = [data valueForKeyPath:@"Name_en"];
        //[AccessType insert:accessType];
        [AccessType insertWithCheck:accessType];
        //Check if there is new image or not
        if([data valueForKeyPath:@"Image"]){
            //Save the image
            NSString* imageEncode = [data valueForKeyPath:@"Image"];
            NSString *docDir    = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            NSString *path      = [NSString stringWithFormat:@"%@%@",docDir,accessType.accessImageLink];
            
            NSData *decodedData = [Base64 decode:imageEncode];
            [decodedData writeToFile:path atomically:YES];
        }
    }
}

+ (BOOL)downloadLocationType{
    id lastupdate = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastupdate"];
    NSString* timestamp = @"0";
    if(lastupdate)
    {
        timestamp = lastupdate;
    }
    NSString *url = [NSString stringWithFormat:@"%@%@",LOCATIONTYPE_API,timestamp];

    RequestDataManager * requestData = [[RequestDataManager alloc]initWithUrl:url];
    [requestData setRequestMethod:GET];
    [requestData requestHTMLDataSuccess:^(NSURLSessionTask *operation, id response) {
        NSDictionary * json = response;
        [DownloadData storeLocaionTypeToCoreData:(NSArray*)[json objectForKey:@"LocationType"]];
        [self downloadLocation];
        NSLog(@"Location Type %@",response);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Can not download Location Type");
        NSLog(@"Error %@",error.description);
    }];
    return YES;
}

+ (void)downloadLocationTypeWithCompletionHandler:(void (^) (BOOL finished))completionHandler {
    id lastupdate = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastupdate"];
    NSString* timestamp = @"0";
    if(lastupdate)
    {
        timestamp = lastupdate;
    }
    NSString *url = [NSString stringWithFormat:@"%@%@",LOCATIONTYPE_API,timestamp];
    
    RequestDataManager * requestData = [[RequestDataManager alloc]initWithUrl:url];
    [requestData setRequestMethod:GET];
    [requestData requestHTMLDataSuccess:^(NSURLSessionTask *operation, id response) {
        NSDictionary * json = response;
        [DownloadData storeLocaionTypeToCoreData:(NSArray*)[json objectForKey:@"LocationType"]];
//        [self downloadLocation];
        [self downloadLocationWithCompletionHandler:^(BOOL finished) {
            if (finished) {
                completionHandler (finished);
            }
        }];
        NSLog(@"Location Type %@",response);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Can not download Location Type");
        NSLog(@"Error %@",error.description);
        completionHandler(NO);
    }];
}

+ (void)storeLocaionTypeToCoreData:(NSArray*)json{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"LocationType" inManagedObjectContext:context];
    //First remove all data in AccessType
    //[LocationType removeAllData];
    
    for(NSDictionary *data in json)
    {
        LocationType* locType  = [[LocationType alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:nil];
        locType.locationTypeID =       [NSNumber numberWithInt:[[data valueForKeyPath:@"LocationTypeID"]intValue]];
        locType.locationName   =       [data valueForKeyPath:@"Name"];
        locType.locationImageLink = [NSString stringWithFormat:@"/LocationTypeIcons/%d.png",[locType.locationTypeID intValue]];
        locType.locationName_en = [data valueForKeyPath:@"Name_en"];
        locType.isCheck = [NSNumber numberWithInt:1];
        //[LocationType insert:locType];
        [LocationType insertWithCheck:locType];
        //Check if there is new image or not
        if([data valueForKeyPath:@"Image"]){
            //Save the image
            NSString* imageEncode = [data valueForKeyPath:@"Image"];
            NSString *docDir    = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            NSString *path      = [NSString stringWithFormat:@"%@%@",docDir,locType.locationImageLink];
            
            NSData *decodedData = [Base64 decode:imageEncode];
            [decodedData writeToFile:path atomically:YES];
            //[DownloadData downloadImageFromURL:url toPath:path];
        }
    }
}

+ (void)createDir :(NSString *)dirName{
    NSString *path;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    path = [[paths objectAtIndex:0] stringByAppendingPathComponent:dirName];
    NSError *error;
    if (![[NSFileManager defaultManager] fileExistsAtPath:path])    //Does directory already exist?
    {
        if (![[NSFileManager defaultManager] createDirectoryAtPath:path
                                       withIntermediateDirectories:NO
                                                        attributes:nil
                                                             error:&error])
        {
            NSLog(@"Create directory error: %@", error);
        }
    }
    
}
+ (BOOL) downloadImageFromURL:(NSString*)url toPath:(NSString*)path{
    UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
    NSData *data1 = [NSData dataWithData:UIImagePNGRepresentation(image)];
	[data1 writeToFile:path atomically:YES];
    return YES;
}

+ (BOOL) downloadWholePackage{
    [self createDir:@"/AccessTypeIcons"];
    [self createDir:@"/LocationTypeIcons"];
    if (![self downloadAccessType]) {
        return NO;
    }
    if (![self downloadLocationType]) {
        return NO;
    }
    return YES;
}

+ (void) downloadDataCompletion:(void (^) (BOOL finished)) completionHandler {
    [self createDir:@"/AccessTypeIcons"];
    [self createDir:@"/LocationTypeIcons"];
    
    __block BOOL tThread1 = NO;
    __block BOOL tThread2 = NO;
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    [self downloadMeasureTypeWithCompletionHandler:^(BOOL finished) {
        //        completionHandler (finished);
        tThread1 = finished;
        NSLog(@"Block1 End");
        dispatch_group_leave(group);
    }];
    
    dispatch_group_enter(group);
    [self downloadLocationTypeWithCompletionHandler:^(BOOL finished) {
        tThread2 = finished;
        NSLog(@"Block2 End");
        dispatch_group_leave(group);
    }];
    dispatch_group_notify(group,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^ {
        // block3
        completionHandler (tThread1 && tThread2);
    });
}


@end
