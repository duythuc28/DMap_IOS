//
//  DownloadData.h
//  MapGoogle
//
//  Created by apple on 10/11/14.
//  Copyright (c) 2014 apple. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DownloadData : NSObject <NSURLConnectionDelegate>


+ (BOOL) downloadImageFromURL:(NSString*)url toPath:(NSString*)path;

+ (BOOL) downloadLocation;

+ (BOOL) downloadLocationType;

+ (BOOL) downloadAccessType;

//+ (BOOL) downloadFeedbacks:(int) LocationID;

+ (BOOL) downloadWholePackage;


+ (NSArray *) downloadCommentFromLocationID:(NSString*)locationId;

/**
 *  Download whole data package
 *
 *  @param completionHandler Block notify after request successfully
 */
+ (void) downloadDataCompletion:(void (^) (BOOL finished)) completionHandler;

@end
