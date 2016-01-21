//
//  CoolUIStoryboardSegue.m
//  grabilityTestGrid
//
//  Created by John Edwin Guerrero Ayala on 1/21/16.
//  Copyright © 2016 ingjohnguerrero. All rights reserved.
//

#import "CoolUIStoryboardSegue.h"

@implementation CoolUIStoryboardSegue

-(void) perform{
    UIViewController *src = self.sourceViewController;
    UIViewController *dest = self.destinationViewController;
    
    // Add the destination view as a subview, temporarily
    [src.view addSubview:dest.view];
    
    // Transformation start scale
    dest.view.transform = CGAffineTransformMakeScale(0.05, 0.05);
    
    // Store original center point of the destination view
    CGPoint originalCenter = dest.view.center;
    
    // Set center to start point of the button
    dest.view.center = originalCenter;
    
    [UIView animateWithDuration:1.0 animations:^{
        //src.view.transform = CGAffineTransformMakeScale(0.05, 0.05);
        
        float theta  = 1440;
        float angle = theta * (M_PI / 100);
        CGAffineTransform transform = CGAffineTransformMakeRotation(angle);
        src.view.transform = CGAffineTransformConcat(transform, CGAffineTransformMakeScale(0.05, 0.05));
    }completion:^(BOOL finished){
        src.view.alpha = 0;
        dest.view.alpha = 0;
        [[src.view superview]addSubview:dest.view];
        [UIView animateWithDuration:0.5 animations:^{
            dest.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
            dest.view.center = originalCenter;
            dest.view.alpha = 1.0;
        }completion:^(BOOL finished){
            if ([dest isKindOfClass:[AppDetailViewController class]]) {
                [src presentViewController:dest animated:NO completion:nil];
            }
            else {
                [dest dismissViewControllerAnimated:NO completion:nil];
            }
            
        }];
    }];}

@end
