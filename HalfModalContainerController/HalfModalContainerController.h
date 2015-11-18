//
//  HalfModalContainerController.h
//  Expenses
//
//  Created by pronebird on 11/18/15.
//  Copyright © 2015 pronebird. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HalfModalContainerController : UIViewController<UIViewControllerTransitioningDelegate>

@property (nonatomic, readonly) UIViewController *contentController;
@property (nonatomic) UIView *accessoryView;

@property (nonatomic) BOOL dimBackground;
@property (nonatomic) BOOL dismissOnTap;

- (instancetype)initWithContentController:(UIViewController *)contentController;

- (void)replaceContentController:(UIViewController *)newContentController;

@end
