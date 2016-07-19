//
//  Location.m
//  MapGoogle
//
//  Created by apple on 9/25/14.
//  Copyright (c) 2014 apple. All rights reserved.
//

#import "Location.h"
#import "AppDelegate.h"
#import "CustomMarker.h"
#import <GoogleMaps/GoogleMaps.h>
@implementation Location

@dynamic address;
@dynamic isBookmark;
@dynamic latitude;
@dynamic longtitude;
@dynamic phone;
@dynamic title;
@dynamic locationID;
@dynamic location_AccessType;
@dynamic location_LocationType;

+ (NSArray *) getAllData{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSFetchRequest *fetch=[[NSFetchRequest alloc] init];
    [fetch setReturnsObjectsAsFaults:NO];
    [fetch setEntity:[NSEntityDescription entityForName:@"Location" inManagedObjectContext:context]];
    
    NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"title"
                                                               ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortByName, nil];
    [fetch setSortDescriptors:sortDescriptors];
    
    NSError *fetchError;
    NSArray *fetchedProducts=[context executeFetchRequest:fetch error:&fetchError];
    return fetchedProducts;
}

+ (NSArray *) getLocationByName: (NSString*)name;
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSFetchRequest *fetch=[[NSFetchRequest alloc] init];
    [fetch setEntity:[NSEntityDescription entityForName:@"Location" inManagedObjectContext:context]];
    NSPredicate *p=[NSPredicate predicateWithFormat:@"title CONTAINS[cd] %@",name];
    [fetch setPredicate:p];
    NSError *fetchError;
    NSArray *fetchedProducts=[context executeFetchRequest:fetch error:&fetchError];
    return fetchedProducts;
}

+ (NSArray *) getDataWithPos: (NSString*)latitude andWithLong:(NSString*) longtitude{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSFetchRequest *fetch=[[NSFetchRequest alloc] init];
    [fetch setEntity:[NSEntityDescription entityForName:@"Location" inManagedObjectContext:context]];
    NSString *stringPredicate = [NSString stringWithFormat:@"latitude == %@ AND longtitude == %@", latitude, longtitude];
    NSPredicate *p=[NSPredicate predicateWithFormat:stringPredicate];
    [fetch setPredicate:p];
    NSError *fetchError;
    NSArray *fetchedProducts=[context executeFetchRequest:fetch error:&fetchError];
    return fetchedProducts;
}

+ (NSArray *) getDataById:(int)locationID{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSFetchRequest *fetch=[[NSFetchRequest alloc] init];
    [fetch setEntity:[NSEntityDescription entityForName:@"Location" inManagedObjectContext:context]];
    NSString *stringPredicate = [NSString stringWithFormat:@"locationID = %d", locationID];
    NSPredicate *p=[NSPredicate predicateWithFormat:stringPredicate];
    [fetch setPredicate:p];
    NSError *fetchError;
    NSArray *fetchedProducts=[context executeFetchRequest:fetch error:&fetchError];
    return fetchedProducts;
}

+ (NSArray *) getDataWithCurrentZoomPos:(CLLocation*)zoomPos withDistanceInKilomiter:(int)distance;
{
    //Proces filterTypeCode
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSFetchRequest *fetch=[[NSFetchRequest alloc] init];
    [fetch setEntity:[NSEntityDescription entityForName:@"Location" inManagedObjectContext:context]];
    NSPredicate *p=[NSPredicate predicateWithFormat:@"location_LocationType.isCheck = %d",1];
    [fetch setPredicate:p];
    NSError *fetchError;
    NSArray *fetchedProducts=[context executeFetchRequest:fetch error:&fetchError];
    
    NSMutableArray *results = [[NSMutableArray alloc]init];
    distance = distance * 1000;
    for(Location* row in fetchedProducts)
    {
        CLLocation* bookmarkPos    = [[CLLocation alloc] initWithLatitude:[row.latitude doubleValue] longitude:[row.longtitude doubleValue]];
        int meters = [bookmarkPos distanceFromLocation:zoomPos];
        
        if(meters < distance)
        {
            [results addObject:row];
        }
    }
    
    return results;
}

+ (void) deleteDataWithArray: (NSArray*) array{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    for (NSManagedObject *Location in array) {
        [context deleteObject:Location];
    }
}

+ (void) insert:(id)bookmarkId accessRelation:(id)accesTypes locationTypeRelation:(id)locationType{
    Location* location = (Location *) bookmarkId;
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSManagedObject *markerInfo = [NSEntityDescription
                                   insertNewObjectForEntityForName:@"Location"
                                   inManagedObjectContext:context];
    [markerInfo setValue:location.locationID        forKey:@"locationID"];
    [markerInfo setValue:location.title             forKey:@"title"];
    [markerInfo setValue:location.phone             forKey:@"phone"];
    [markerInfo setValue:location.address           forKey:@"address"];
    [markerInfo setValue:location.latitude          forKey:@"latitude"];
    [markerInfo setValue:location.longtitude        forKey:@"longtitude"];
    [markerInfo setValue:[NSNumber numberWithInt:NO]                         forKey:@"isBookmark"];
    
    [markerInfo setValue:accesTypes forKey:@"location_AccessType"];
    [markerInfo setValue:locationType forKey:@"location_LocationType"];
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
}

+ (void) insertWithCheck:(id)bookmarkId accessRelation:(id)accesTypes locationTypeRelation:(id)locationType;{
    Location* location  = (Location*)bookmarkId;
    //Check if it is exist or not
    NSArray* findMarker      = [Location getDataById:[location.locationID intValue]];
    
    if(findMarker.count > 0){
        //Edit
        id editObjectId = [findMarker objectAtIndex:0];
        [self editObject:editObjectId byBookmark:bookmarkId accessRelation:accesTypes locationTypeRelation:locationType];
        
    }else{
        //Add new
        [self insert:location accessRelation:accesTypes locationTypeRelation:locationType];
    }
}

+ (void) editObject:(id)editObjectId byBookmark:(id)bookmarkId accessRelation:(id)accesTypes locationTypeRelation:(id)locationType{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    Location* location      = (Location*)bookmarkId;
    Location* editObject    = (Location*)editObjectId;
    
    editObject.latitude = location.latitude;
    editObject.longtitude = location.longtitude;
    editObject.title    = location.title;
    editObject.phone    = location.phone;
    editObject.address =  location.address;
    editObject.location_LocationType = locationType;
    editObject.location_AccessType = accesTypes;
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
}

+ (void) deleteDataWithLatitude:(NSString*)latitude andLongtitude:(NSString*)longtitude{
    NSArray* array = [Location getDataWithPos:latitude andWithLong:longtitude];
    if(array.count<1)
        return;
    Location* Location = [array objectAtIndex:0];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    [context deleteObject:Location];
}

+ (void) bookmarkTheMarker:(GMSMarker*)pos{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    CustomMarker* marker = (CustomMarker*)pos;
    NSArray* bookmarkOfThePos = [Location getDataWithPos:marker.location.latitude andWithLong:marker.location.longtitude];
    if(bookmarkOfThePos.count > 0){
        Location* Location = [bookmarkOfThePos objectAtIndex:0];
        Location.isBookmark = [NSNumber numberWithBool:YES];
        NSError *error;
        if (![context save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
    }
}

+ (void) setFavoriteLocation:(Location*)location isFavorite:(BOOL) isFavorite {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    location.isBookmark = [NSNumber numberWithBool:isFavorite];
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
}

+ (void) removeBookmarkTheMarker:(Location*)pos{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    //Location* marker = (Location*)pos;
    Location* marker = pos;
    NSArray* bookmarkOfThePos = [Location getDataWithPos:marker.latitude andWithLong:marker.longtitude];
    if(bookmarkOfThePos.count > 0){
        Location* Location = [bookmarkOfThePos objectAtIndex:0];
        Location.isBookmark = [NSNumber numberWithBool:NO];
        NSError *error;
        if (![context save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
    }
}

+ (NSArray *) getBookmarkedData{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSFetchRequest *fetch=[[NSFetchRequest alloc] init];
    [fetch setEntity:[NSEntityDescription entityForName:@"Location" inManagedObjectContext:context]];
    NSString *stringPredicate = [NSString stringWithFormat:@"isBookmark == YES"];
    NSPredicate *p=[NSPredicate predicateWithFormat:stringPredicate];
    [fetch setPredicate:p];
    NSError *fetchError;
    NSArray *fetchedProducts=[context executeFetchRequest:fetch error:&fetchError];
    return fetchedProducts;
}
@end
