//
//  HalfModalPresentationController.m
//  HalfModalContainerController
//
//  Created by pronebird on 11/18/15.
//  Copyright © 2015 pronebird. All rights reserved.
//

#import "HalfModalPresentationController.h"
#import <PureLayout/PureLayout.h>

@interface HalfModalPresentationController ()

@property (nonatomic) UIView *backdropView;

@end

@implementation HalfModalPresentationController

- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(UIViewController *)presentingViewController {
    self = [super initWithPresentedViewController:presentedViewController presentingViewController:presentingViewController];
    if(!self) {
        return nil;
    }
    
    self.backdropView = [[UIView alloc] init];
    self.backdropView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    self.backdropView.alpha = 0;
    self.backdropView.userInteractionEnabled = YES;
    
    [self.backdropView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissOnTapHandler:)]];
    
    return self;
}

#pragma mark - Accessors
#pragma mark -

- (void)setDimBackground:(BOOL)dimBackground {
    if(_dimBackground == dimBackground) {
        return;
    }
    
    _dimBackground = dimBackground;
    
    /*
     Update dim background dynamically if controller is already presented.
     */
    [self updateDimBackgroundWithAnimationIfNeeded];
}

#pragma mark - Actions
#pragma mark -

- (void)dismissOnTapHandler:(UITapGestureRecognizer *)gestureRecognizer {
    if(!self.dismissOnTap) {
        return;
    }
    
    if(gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - Dim background management
#pragma mark -

- (void)updateDimBackgroundWithAnimationIfNeeded {
    NSTimeInterval animationDuration = 0.25;
    
    /*
     Container view does not exist until transition.
     So we should let dim background to be animated along with transition.
     */
    if(!self.containerView) {
        return;
    }
    
    if(self.dimBackground) {
        [self addBackdropView];
        
        [self.containerView setNeedsLayout];
        
        /*
         Animate layout changes if any
         */
        [UIView animateWithDuration:animationDuration animations:^{
            [self.containerView layoutIfNeeded];
        } completion:^(BOOL finished) {
            
            /*
             Animate dim background
             */
            [UIView animateWithDuration:animationDuration animations:^{
                self.backdropView.alpha = 1;
            }];
        }];
    }
    else {
        [self.containerView setNeedsLayout];
        /*
         Animate layout changes if any
         */
        [UIView animateWithDuration:animationDuration animations:^{
            [self.containerView layoutIfNeeded];
        } completion:^(BOOL finished) {
            /*
             Animate dim background
             */
            [UIView animateWithDuration:animationDuration animations:^{
                self.backdropView.alpha = 0;
            } completion:^(BOOL finished) {
                [self removeBackdropView];
            }];
        }];
    }
}

- (void)addBackdropView {
    [self.containerView insertSubview:self.backdropView atIndex:0];
    [self.backdropView autoPinEdgesToSuperviewEdges];
}

- (void)removeBackdropView {
    [self.backdropView removeFromSuperview];
}

#pragma mark - Subclassing
#pragma mark -

- (BOOL)shouldPresentInFullscreen {
    return NO;
}

- (BOOL)shouldRemovePresentersView {
    return NO;
}

- (void)presentationTransitionWillBegin {
    [super presentationTransitionWillBegin];
    
    if(self.dimBackground) {
        [self addBackdropView];
        
        [self.presentingViewController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
            self.backdropView.alpha = 1;
        } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
            
        }];
    }
}

- (void)presentationTransitionDidEnd:(BOOL)completed {
    [super presentationTransitionDidEnd:completed];
}

- (void)dismissalTransitionWillBegin {
    [super dismissalTransitionWillBegin];
    
    if(self.dimBackground) {
        [self.presentingViewController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
            self.backdropView.alpha = 0;
        } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
            
        }];
    }
}

- (void)dismissalTransitionDidEnd:(BOOL)completed {
    [super dismissalTransitionDidEnd:completed];
    
    if(self.dimBackground && completed) {
        [self removeBackdropView];
    }
}

- (void)containerViewDidLayoutSubviews {
    [super containerViewDidLayoutSubviews];
    
    if(self.dimBackground) {
        /*
         Keep container view as large as possible.
         */
        self.containerView.frame = self.presentingViewController.view.bounds;
        
        /*
         Move presented view within container
         */
        self.presentedView.frame = [self frameOfPresentedViewInContainerView];
    }
    else {
        /*
         Keep container size equal to presented view size when not showing backdrop.
         This will allow touches to go through to parent controller
         */
        self.containerView.frame = [self frameOfPresentedViewInContainerView];
        self.presentedView.frame = self.containerView.bounds;
    }
}

- (CGRect)frameOfPresentedViewInContainerView {
    CGSize preferredSizeForPresentedController = [self.presentedViewController preferredContentSize];
    
    CGRect targetFrame = [super frameOfPresentedViewInContainerView];
    CGFloat targetHeight;
    
    if((NSInteger)preferredSizeForPresentedController.height == 0) {
        targetHeight = CGRectGetHeight(self.containerView.bounds) * 0.5;
    }
    else {
        targetHeight = preferredSizeForPresentedController.height;
    }
    
    targetFrame = CGRectOffset(targetFrame, 0, targetHeight);
    targetFrame.size.height = targetHeight;
    
    return targetFrame;
}

@end
