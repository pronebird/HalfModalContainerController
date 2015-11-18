//
//  HalfModalPresentationController.h
//  HalfModalContainerController
//
//  Created by pronebird on 11/18/15.
//  Copyright © 2015 pronebird. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HalfModalPresentationController : UIPresentationController

/**
 *  Dim background during presentation.
 *  This prevent user from tapping through on other controls in
 *  presenting controller.
 * 
 *  Default: NO
 */
@property (nonatomic) BOOL dimBackground;

/**
 *  Dismiss on tap on dimmed background view.
 *
 *  Default: NO
 */
@property (nonatomic) BOOL dismissOnTap;

@end
