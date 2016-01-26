//
//  AppDetailViewController.h
//  grabilityTestGrid
//
//  Created by John Edwin Guerrero Ayala on 1/21/16.
//  Copyright © 2016 ingjohnguerrero. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UINavigationItem *titleNavItem;
@property (weak, nonatomic) IBOutlet UILabel *appNameLbl;
@property (weak, nonatomic) IBOutlet UIImageView *appIconUIImage;
@property (weak, nonatomic) IBOutlet UITextView *summaryTextView;
@property (weak, nonatomic) IBOutlet UILabel *currencyLabl;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;

@end
