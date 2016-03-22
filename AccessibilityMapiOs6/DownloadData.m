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
@implementation DownloadData

//static NSString *LOCATION_API = @"http://www.accessmap.somee.com/AccessMapServices.svc/GetLocation?Time=%@";
//static NSString *ACCESSTYPE_API = @"http://www.accessmap.somee.com/AccessMapServices.svc/GetAccessibilityType?Time=%@";
//static NSString *LOCATIONTYPE_API = @"http://www.accessmap.somee.com/AccessMapServices.svc/GetLocationType?Time=%@";
//
//static NSString *COMMENT_API = @"http://www.accessmap.somee.com/AccessMapServices.svc/GetFeedback?locationid=%@";

//static NSString *LOCATION_API = @"http://mapsdemo.tk/web/api/get/locations?Time=%@";
//static NSString *ACCESSTYPE_API = @"http://mapsdemo.tk/web/api/get/access_types?Time=%@";
//static NSString *LOCATIONTYPE_API = @"http://mapsdemo.tk/web/api/get/location_types?Time=%@";
//
//static NSString *COMMENT_API = @"http://mapsdemo.tk/web/api/get/feedback?Locationid=%@";


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
    @try {
        id lastupdate = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastupdate"];
        NSString* timestamp;
        NSString *url;
        if(!lastupdate)
        {
            timestamp = @"0";
            url = [NSString stringWithFormat:@"%@%@",LOCATION_API,timestamp];
        }
        else
        {
            timestamp = lastupdate;
            url = [NSString stringWithFormat:@"%@%@",LOCATION_API,timestamp];
        }
        NSURL *jsonURL = [NSURL URLWithString:url];
        
        NSURLResponse *response = nil;
        NSError* error = nil;
        
        
        NSData* data = [NSURLConnection sendSynchronousRequest:[[NSURLRequest alloc] initWithURL:jsonURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:(15.0)] returningResponse:&response error:&error];
        if(error!=nil)
            NSLog(@"Whoops, couldn't download: %@", [error localizedDescription]);
        NSArray *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        [DownloadData storeLocationToCoreData:(NSArray*)[json valueForKeyPath:@"Location"]];
        
        //Set lastupdate time
        NSString* lastUpdate = [json valueForKeyPath:@"Time"];
        [[NSUserDefaults standardUserDefaults] setObject:lastUpdate forKey:@"lastupdate"];
        return YES;
    }
    @catch (NSException *exception) {
        return NO;
    }
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
    @try {
        id lastupdate = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastupdate"];
        NSString* timestamp;
        NSString *url;
        if(!lastupdate)
        {
            timestamp = @"0";
            url = [NSString stringWithFormat:@"%@%@",ACCESSTYPE_API,timestamp];
        }
        else
        {
            timestamp = lastupdate;
            url = [NSString stringWithFormat:@"%@%@",ACCESSTYPE_API,timestamp];
        }
        
        NSURL *jsonURL = [NSURL URLWithString:url];
        NSURLResponse *response = nil;
        NSError* error = nil;
        NSData* data = [NSURLConnection sendSynchronousRequest:[[NSURLRequest alloc] initWithURL:jsonURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:(15.0)] returningResponse:&response error:&error];
        if(error!=nil)
            NSLog(@"Whoops, couldn't download: %@", [error localizedDescription]);
        NSArray *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        //[DownloadData storeAccessTypeToCoreData:[(NSArray*)[json valueForKey:@"AccessibilityType"]]];
        [DownloadData storeAccessTypeToCoreData:(NSArray*)[json valueForKeyPath:@"AccessibilityType"]];
        return YES;
        
    }
    @catch (NSException *exception) {
        return NO;
    }
    
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

+(BOOL)downloadLocationType{
    @try {
        id lastupdate = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastupdate"];
        NSString* timestamp;
        NSString *url;
        if(!lastupdate)
        {
            timestamp = @"0";
            url = [NSString stringWithFormat:@"%@%@",LOCATIONTYPE_API,timestamp];
        }
        else
        {
            timestamp = lastupdate;
            url = [NSString stringWithFormat:@"%@%@",LOCATIONTYPE_API,timestamp];
        }
        
        NSURL *jsonURL = [NSURL URLWithString:url];
        NSURLResponse *response = nil;
        NSError* error = nil;
        NSData* data = [NSURLConnection sendSynchronousRequest:[[NSURLRequest alloc] initWithURL:jsonURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:(15.0)] returningResponse:&response error:&error];
        if(error!=nil)
            NSLog(@"Whoops, couldn't download: %@", [error localizedDescription]);
        NSArray *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        [DownloadData storeLocaionTypeToCoreData:(NSArray*)[json valueForKeyPath:@"LocationType"]];
        return YES;
        
    }
    @catch (NSException *exception) {
        return NO;
    }
}
+(void)storeLocaionTypeToCoreData:(NSArray*)json{
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

+(void)createDir :(NSString *)dirName{
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
    if(![self downloadLocationType]){
        return NO;
    }
    if(![self downloadLocation]){
        return NO;
    }
    /*
     NSArray* test1 = [AccessType getAllData];
     NSArray* test2 = [LocationType getAllData];
     NSArray* test3 = [Location getAllData];
     */
    return YES;
}



@end
