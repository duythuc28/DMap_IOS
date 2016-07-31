//
//  CommentPopupView.m
//  DMap
//
//  Created by iOSDev on 7/26/16.
//  Copyright © 2016 apple. All rights reserved.
//

#import "CommentPopupView.h"
@interface CommentPopupView()
@property (strong, nonatomic) UIView * blurView;
@end
@implementation CommentPopupView


-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"CommentPopupView" owner:self options:nil] firstObject];
        self.frame = frame;
        self.userComment.placeholder = LocalizedString(@"Comment_PlaceHolder");
        self.userPhone.placeholder = LocalizedString(@"User Phone");
        [self.userPhone becomeFirstResponder];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame delegate:(id<CommentPopupViewDelegate>)delegate {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"CommentPopupView" owner:self options:nil] firstObject];
        self.frame = frame;
        self.delegate = delegate;
        [self.userPhone becomeFirstResponder];
    }
    return self;
}

- (void)showPopupInView:(UIView *)view {
    self.layer.cornerRadius = 6.0;
    self.blurView = [[UIView alloc]initWithFrame:view.bounds];
    self.blurView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [view addSubview:self.blurView];
    CGFloat centerX = view.center.x - (self.frame.size.width/2);
    CGRect frame = CGRectMake(centerX, 15, self.frame.size.width, self.frame.size.height);
    self.frame = frame;
    [view addSubview:self];
}

- (IBAction)cancelButtonClicked:(id)sender {
    [self.blurView removeFromSuperview];
    [self removeFromSuperview];
}

- (IBAction)postComment:(id)sender {
    [self.delegate postButtonClicked:self.userPhone.text comment:self.userComment.text];
}
@end
