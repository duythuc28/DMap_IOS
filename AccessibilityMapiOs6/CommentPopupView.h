//
//  CommentPopupView.h
//  DMap
//
//  Created by iOSDev on 7/26/16.
//  Copyright © 2016 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CommentPopupView;
@protocol CommentPopupViewDelegate <NSObject>
- (void)postButtonClicked;
@end

@interface CommentPopupView : UIView
@property (weak, nonatomic) IBOutlet UITextField *userPhone;
@property (weak, nonatomic) IBOutlet UITextView *userComment;
@property (weak, nonatomic) id <CommentPopupViewDelegate> delegate;

-(id)initWithFrame:(CGRect)frame;
-(id)initWithFrame:(CGRect)frame delegate:(id<CommentPopupViewDelegate>)delegate;
@end
