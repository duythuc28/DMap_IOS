//
//  AccessTypes.m
//  MapGoogle
//
//  Created by apple on 10/11/14.
//  Copyright (c) 2014 apple. All rights reserved.
//

#import "AccessType.h"
#import "AppDelegate.h"

@implementation AccessType

@dynamic accessTypeID;
@dynamic accessName;
@dynamic accessImageLink;
@dynamic accessDescribtion;
@dynamic accessName_en;
+ (NSArray*)getAllData{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSFetchRequest *fetch=[[NSFetchRequest alloc] init];
    [fetch setReturnsObjectsAsFaults:NO];
    [fetch setEntity:[NSEntityDescription entityForName:@"AccessType" inManagedObjectContext:context]];
    
    NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"accessName"
                                                               ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortByName, nil];
    [fetch setSortDescriptors:sortDescriptors];
    
    NSError *fetchError;
    NSArray *fetchedProducts=[context executeFetchRequest:fetch error:&fetchError];
    return fetchedProducts;
}

+ (NSArray *) getAllDataByEn
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSFetchRequest *fetch=[[NSFetchRequest alloc] init];
    [fetch setReturnsObjectsAsFaults:NO];
    [fetch setEntity:[NSEntityDescription entityForName:@"AccessType" inManagedObjectContext:context]];
    
    NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"accessName_en"
                                                               ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortByName, nil];
    [fetch setSortDescriptors:sortDescriptors];
    
    NSError *fetchError;
    NSArray *fetchedProducts=[context executeFetchRequest:fetch error:&fetchError];
    return fetchedProducts;
}

+ (void)removeAllData{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSArray* allData = [AccessType  getAllData];
    for (NSManagedObject *accessType in allData) {
        [context deleteObject:accessType];
    }
}

+ (void)insert:(id)accessType{
    AccessType* willInsert = (AccessType *) accessType;
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSManagedObject *accessInfo = [NSEntityDescription
                                   insertNewObjectForEntityForName:@"AccessType"
                                   inManagedObjectContext:context];
    [accessInfo setValue:willInsert.accessTypeID        forKey:@"accessTypeID"];
    [accessInfo setValue:willInsert.accessName          forKey:@"accessName"];
    [accessInfo setValue:willInsert.accessImageLink     forKey:@"accessImageLink"];
    [accessInfo setValue:willInsert.accessDescribtion   forKey:@"accessDescribtion"];
    [accessInfo setValue:willInsert.accessName_en       forKey:@"accessName_en"];
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    
}

+ (NSArray *) getDataByIdCodes:(long)idCode{
    NSMutableArray * returnData = [[NSMutableArray alloc]init];
    NSArray * allData = [self getAllData];
    for(AccessType * each in allData){
        if([each.accessTypeID intValue] & idCode){
            [returnData addObject:each];
        }
    }
    
    return[returnData mutableCopy];
}

+ (AccessType*)getTypeById:(int)typeId{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSFetchRequest *fetch=[[NSFetchRequest alloc] init];
    [fetch setEntity:[NSEntityDescription entityForName:@"AccessType" inManagedObjectContext:context]];
    NSString *stringPredicate = [NSString stringWithFormat:@"accessTypeID == %d", typeId];
    NSPredicate *p=[NSPredicate predicateWithFormat:stringPredicate];
    [fetch setPredicate:p];
    NSError *fetchError;
    NSArray *fetchedProducts=[context executeFetchRequest:fetch error:&fetchError];
    if([fetchedProducts count] == 0)
        return nil;
    return (AccessType*)[fetchedProducts objectAtIndex:0];
}

+ (UIImage*) getImageByAcessTypeID:(int)acTypeCode{
    AccessType * acType = [self getTypeById:acTypeCode];
    
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:acType.accessImageLink];
    UIImage * returnImage = [UIImage imageWithContentsOfFile: path];
    return returnImage;
}

+ (void)insertWithCheck:(id)accessType{
    AccessType * checkedObject = (AccessType*) accessType;
    AccessType * check = [AccessType getTypeById:[checkedObject.accessTypeID intValue]];
    
    if(check == nil){
        [self insert:accessType];
    }else{
        [self editObject:check fromObject:accessType];
    }
}
+ (void) editObject:(id)editObjectId fromObject:(id)fromObjectId{
//    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
//    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    AccessType * editObject = (AccessType*)editObjectId;
    AccessType * fromObject = (AccessType*)fromObjectId;
    
    editObject.accessName = fromObject.accessName;
}

@end
