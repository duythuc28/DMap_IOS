//
//  Constant.h
//  DMap
//
//  Created by IOSDev on 3/24/16.
//  Copyright © 2016 apple. All rights reserved.
//

#ifndef Constant_h
#define Constant_h

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

#define IS_IPHONE_4_OR_LESS     (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5             (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6             (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P            (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
#define SYSTEM_VERSION_8        ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

// API Get Location
#define LOCATION_API @"http://www.drdvietnam.org/bandotiepcan/api/get/locations?Time="
// API Get AccessType
#define ACCESSTYPE_API @"http://www.drdvietnam.org/bandotiepcan/api/get/access_types?Time="
// API Get Location Type
#define LOCATIONTYPE_API @"http://www.drdvietnam.org/bandotiepcan/api/get/location_types?Time="
// API Get Feedback
#define COMMENT_API @"http://www.drdvietnam.org/bandotiepcan/api/get/feedback?Locationid="
// API Post Location
#define POST_LOCATION_API @"http://www.drdvietnam.org/bandotiepcan/api/post/location"
// API Post FeedBack
#define POST_COMMENT_API @"http://www.drdvietnam.org/bandotiepcan/api/post/feedback"
#define APP_LANGUAGE @"appLanguage"
#define GOOGLE_MAP_API_KEY @"AIzaSyCL65C3Rt1c2PoMUUGtS1B9YbSZMH708PM"
#define kFIRST_TIME @"firstTimeActive"

#endif /* Constant_h */
