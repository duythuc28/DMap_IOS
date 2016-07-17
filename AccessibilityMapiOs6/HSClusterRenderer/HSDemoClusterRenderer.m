//
//  HSDemoClusterRenderer.m
//  HSClusterMapView
//
//  Created by Alan Bouzek on 8/25/15.
//  Copyright (c) 2015 abouzek. All rights reserved.
//

#import "HSDemoClusterRenderer.h"

@implementation HSDemoClusterRenderer

- (UIImage *)imageForClusterWithCount:(NSUInteger)count {
    // Get the number of digits in the count
    NSString *countString = [NSString stringWithFormat:@"%d", (int)count];
    
    // Set up the cluster view
//    CGFloat widthAndHeight = 25 + (5 * countString.length);
    UIView *clusterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 50)];
//    clusterView.backgroundColor = [UIColor redColor];
//    clusterView.layer.masksToBounds = YES;
//    clusterView.layer.borderColor = [[UIColor blackColor] CGColor];
//    clusterView.layer.borderWidth = 1;
//    clusterView.layer.cornerRadius = clusterView.bounds.size.width / 2.0;
    
    UIImageView * iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 44, 50)];
    iconView.image = [UIImage imageNamed:@"number_marker"];
    [clusterView addSubview:iconView];
    
    // Add the number label
    UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 10, 30, 20)];
    numberLabel.font = [UIFont fontWithName:@"Helvetica-Neue" size:16];
    numberLabel.textColor = [UIColor blackColor];
    numberLabel.text = countString;
    numberLabel.textAlignment = NSTextAlignmentCenter;
    [clusterView addSubview:numberLabel];
    

    
    // Generate an image from the view
    UIGraphicsBeginImageContextWithOptions(clusterView.bounds.size, NO, 0.0);
    [clusterView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *icon = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    

    
//    // Generate an image from the view
//    UIGraphicsBeginImageContextWithOptions(iconView.bounds.size, NO, 0.0);
//    [iconView.layer renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage *icon = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
    return icon;
}

@end
