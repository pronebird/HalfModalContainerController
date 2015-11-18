//
//  HalfModalContainerController.m
//  Expenses
//
//  Created by pronebird on 11/18/15.
//  Copyright © 2015 pronebird. All rights reserved.
//

#import "HalfModalContainerController.h"
#import "HalfModalPresentationAnimator.h"
#import "HalfModalPresentationController.h"
#import <PureLayout/PureLayout.h>

@interface HalfModalContainerController ()

@property (nonatomic, readwrite) UIViewController *contentController;

@property (nonatomic) UIView *contentWrapperView;
@property (nonatomic) UIView *accessoryWrapperView;

@end

@implementation HalfModalContainerController

- (instancetype)initWithContentController:(UIViewController *)contentController {
    NSParameterAssert(contentController);
    
    self = [super init];
    if(!self) {
        return nil;
    }
    
    self.contentWrapperView = [[UIView alloc] initForAutoLayout];
    self.accessoryWrapperView = [[UIView alloc] initForAutoLayout];
    
    self.contentController = contentController;
    
    self.transitioningDelegate = self;
    self.modalPresentationStyle = UIModalPresentationCustom;
    
    return self;
}

- (void)replaceContentController:(UIViewController *)newContentController {
    NSParameterAssert(newContentController);
    
    if(self.contentController) {
        [self.contentController willMoveToParentViewController:nil];
        [self.contentController.view removeFromSuperview];
        [self.contentController removeFromParentViewController];
    }
    
    self.contentController = newContentController;
    
    [self addChildContentController];
}

- (void)addChildContentController {
    if(![self isViewLoaded]) {
        return;
    }
    
    [self addChildViewController:self.contentController];
    [self.contentWrapperView addSubview:self.contentController.view];
    [self.contentController didMoveToParentViewController:self];
    
    [self.contentController.view autoPinEdgesToSuperviewEdges];
}

#pragma mark - View lifecycle
#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.accessoryWrapperView];
    [self.view addSubview:self.contentWrapperView];
    
    [self.contentWrapperView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
    [self.contentWrapperView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.accessoryWrapperView];
    
    [self.accessoryWrapperView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
    
    [self addChildContentController];
}

- (HalfModalPresentationController *)currentPresentationController {
    if([self.presentationController isKindOfClass:[HalfModalPresentationController class]]) {
        return (HalfModalPresentationController *)self.presentationController;
    }
    
    return nil;
}

#pragma mark - Accessors
#pragma mark -

- (void)setDimBackground:(BOOL)dimBackground {
    if(_dimBackground == dimBackground) {
        return;
    }
    
    _dimBackground = dimBackground;
    
    [self currentPresentationController].dimBackground = dimBackground;
}

- (void)setDismissOnTap:(BOOL)dismissOnTap {
    if(_dismissOnTap == dismissOnTap) {
        return;
    }
    
    _dismissOnTap = dismissOnTap;
    
    [self currentPresentationController].dismissOnTap = dismissOnTap;
}

- (void)setAccessoryView:(UIView *)accessoryView {
    if(_accessoryView == accessoryView) {
        return;
    }
    
    if(_accessoryView) {
        [_accessoryView removeFromSuperview];
    }
    
    _accessoryView = accessoryView;
    
    if(accessoryView) {
        [_accessoryWrapperView addSubview:_accessoryView];
        [_accessoryView autoPinEdgesToSuperviewEdges];
    }
}

#pragma mark - UIViewControllerTransitioningDelegate
#pragma mark -

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return [[HalfModalPresentationAnimator alloc] init];
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return nil;
}

- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source {
    HalfModalPresentationController *presentationController = [[HalfModalPresentationController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
    
    presentationController.dimBackground = self.dimBackground;
    presentationController.dismissOnTap = self.dismissOnTap;
    
    return presentationController;
}

@end
