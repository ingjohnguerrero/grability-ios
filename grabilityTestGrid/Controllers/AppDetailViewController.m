//
//  AppDetailViewController.m
//  grabilityTestGrid
//
//  Created by John Edwin Guerrero Ayala on 1/21/16.
//  Copyright © 2016 ingjohnguerrero. All rights reserved.
//

#import "AppDetailViewController.h"

@interface AppDetailViewController ()

@end

@implementation AppDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    _appIconUIImage.frame = CGRectMake(
                                       _appIconUIImage.frame.origin.x+(_appIconUIImage.frame.size.height/4),
                                       _appIconUIImage.frame.origin.y, _appIconUIImage.frame.size.height, _appIconUIImage.frame.size.height);//image.size.height);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIImage*)imageWithImage: (UIImage*) sourceImage scaledToWidth: (float) i_width
{
    float oldWidth = sourceImage.size.width;
    float scaleFactor = i_width / oldWidth;
    
    float newHeight = sourceImage.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
