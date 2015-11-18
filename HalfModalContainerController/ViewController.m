//
//  ViewController.m
//  HalfModalContainerController
//
//  Created by pronebird on 11/18/15.
//  Copyright © 2015 pronebird. All rights reserved.
//

#import "ViewController.h"
#import "HalfModalContainerController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showHalfModalDimmedPresentation:(id)sender {
    UIViewController *content = [self.storyboard instantiateViewControllerWithIdentifier:@"Content Controller"];
    
    [self showHalfModalPresentationWithContentController:content dimmed:YES];
}

- (IBAction)showHalfModalPresentation:(id)sender {
    UIViewController *content = [self.storyboard instantiateViewControllerWithIdentifier:@"Content Controller 2"];
    
    [self showHalfModalPresentationWithContentController:content dimmed:NO];
}

- (void)showHalfModalPresentationWithContentController:(UIViewController *)contentController dimmed:(BOOL)dimmed {
    UIToolbar *accessoryView = [[UIToolbar alloc] init];
    
    accessoryView.items = @[
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissHalfModal:)]
    ];
    
    if([[self presentedViewController] isKindOfClass:[HalfModalContainerController class]]) {
        HalfModalContainerController *presentedController = (HalfModalContainerController *)[self presentedViewController];
        
        presentedController.dimBackground = dimmed;
        presentedController.accessoryView = accessoryView;
        
        [presentedController replaceContentController:contentController];
        
        return;
    }
    
    HalfModalContainerController *container = [[HalfModalContainerController alloc] initWithContentController:contentController];
    
    container.dimBackground = dimmed;
    container.accessoryView = accessoryView;
    container.dismissOnTap = YES;
    
    [self presentViewController:container animated:YES completion:^{
        
    }];
}

- (void)dismissHalfModal:(id)sender {
    [[self presentedViewController] dismissViewControllerAnimated:YES completion:nil];
}

@end
