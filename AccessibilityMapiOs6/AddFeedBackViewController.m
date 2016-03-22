//
//  AddFeedBackViewController.m
//  MapGoogle
//
//  Created by Hackintosh on 11/22/14.
//  Copyright (c) 2014 apple. All rights reserved.
//

#import "AddFeedBackViewController.h"
#import "Ulti.h"
#import "LocationTabBarController.h"
#import "LocalizeHelper.h"
#import "Utils.h"
@interface AddFeedBackViewController ()<NSURLConnectionDataDelegate>
@end

@implementation AddFeedBackViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [Utils checkInternetConnection];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.nameBox.attributedPlaceholder = [[NSAttributedString alloc]initWithString:LocalizedString(@"Name/Phone/Email")];
    [[self.commentBox layer] setBorderColor:[[UIColor grayColor]CGColor]];
    [[self.commentBox layer] setBorderWidth:1.0];
    [[self.commentBox layer] setCornerRadius:1.5];
    
    // Do any additional setup after loading the view.
    
    UIBarButtonItem *flipButton = [[UIBarButtonItem alloc]
                                   initWithTitle:LocalizedString(@"Post Feedback")
                                   style:UIBarButtonItemStyleBordered
                                   target:self
                                   action:@selector(flipView)];
    
    self.navigationItem.rightBarButtonItem = flipButton;
}

- (IBAction)getKeyboardAway:(id)sender {
    [self.nameBox resignFirstResponder];
}

-(void) flipView
{
    if ([Utils checkInternetConnection] == YES)
    {
        NSString * name = self.nameBox.text;
        NSString * comment = self.commentBox.text;
        
        if(name.length == 0 || comment.length == 0){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LocalizedString(@"Error")
                                                            message:LocalizedString(@"ErrorNotValid")
                                                           delegate:nil
                                                  cancelButtonTitle:LocalizedString(@"Ok")
                                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
        NSArray *keys = [NSArray arrayWithObjects:@"LocationID", @"Name", @"Content", nil];
        NSArray *objects = [NSArray arrayWithObjects:self.locationid, name, comment, nil];
        NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:objects
                                                               forKeys:keys];
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:nil];
        // Create the request
        @try{
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:POST_COMMENT_API]cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0];
            [request setHTTPMethod:@"POST"];
            [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)jsonData.length] forHTTPHeaderField:@"Content-Length"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setHTTPBody:jsonData];
            
            NSURLResponse *requestResponse;
            NSData *requestHandler = [NSURLConnection sendSynchronousRequest:request returningResponse:&requestResponse error:nil];
            
            NSString *requestReply = [[NSString alloc] initWithBytes:[requestHandler bytes] length:[requestHandler length] encoding:NSASCIIStringEncoding];
            NSLog(@"requestReply: %@", requestReply);
            if([requestReply isEqualToString:@"1"]){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LocalizedString(@"Success")
                                                                message:LocalizedString(@"Success Post Feedback")
                                                               delegate:nil
                                                      cancelButtonTitle:LocalizedString(@"Ok")
                                                      otherButtonTitles:nil];
                [alert show];
                self.commentBox.text = @"";
                self.nameBox.text = @"";
                [self.commentBox resignFirstResponder];
                [self.nameBox resignFirstResponder];
            }
            else
            {
                UIAlertView *message = [[UIAlertView alloc] initWithTitle:LocalizedString(@"Error")
                                                                  message:LocalizedString(@"Error Post Feedback")
                                                                 delegate:nil
                                                        cancelButtonTitle:LocalizedString(@"Ok")
                                                        otherButtonTitles:nil];
                [message show];
            }
        }
        @catch(NSException *exception){
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:LocalizedString(@"Error")

                                                              message:LocalizedString(@"Error TimeOut")
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
