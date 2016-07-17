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


+ (void)downloadCommentFromLocationID:(NSString*)locationId
                              success:(void(^)(NSDictionary * response))success
                              failure:(void(^)(NSError * error)) failure;

/**
 *  Download whole data package
 *
 *  @param completionHandler Block notify after request successfully
 */
+ (void) downloadDataCompletion:(void (^) (BOOL finished)) completionHandler;

+ (void)postSharingLocationWithParams:(NSDictionary *)params
                    completionHandler:(void (^) (NSURLSessionTask *operation, id response))completionHandler
                              failure:(void (^)(NSURLSessionTask *operation, NSError *error)) failure;

@end
