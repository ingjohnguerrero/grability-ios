//
//  ViewController.h
//  grabilityTestGrid
//
//  Created by John Edwin Guerrero Ayala on 12/30/15.
//  Copyright © 2015 ingjohnguerrero. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainCollectionViewCell.h"
#import "AFNetworking/AFNetworking.h"

@interface ViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource>
@property (strong, nonatomic) NSString *reuseIdentifier;

@end

