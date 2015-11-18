//
//  HalfModalPresentationAnimator.m
//  HalfModalContainerController
//
//  Created by pronebird on 11/18/15.
//  Copyright © 2015 pronebird. All rights reserved.
//

#import "HalfModalPresentationAnimator.h"

@implementation HalfModalPresentationAnimator

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.4;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *destinationController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *destinationView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *containerView = [transitionContext containerView];
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    [containerView addSubview:destinationView];
    
    CGRect targetFrame = [transitionContext finalFrameForViewController:destinationController];
    CGRect initialFrame = targetFrame;
    
    initialFrame.origin.y = CGRectGetMaxY(containerView.frame);
    
    destinationView.frame = initialFrame;
    
    [UIView animateWithDuration:duration animations:^{
        destinationView.frame = targetFrame;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
}

@end
