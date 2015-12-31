//
//  ViewController.m
//  grabilityTestGrid
//
//  Created by John Edwin Guerrero Ayala on 12/30/15.
//  Copyright © 2015 ingjohnguerrero. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    if(!_reuseIdentifier){
        _reuseIdentifier = @"mainCollectionViewCell";
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark AFNetworking
- (NSMutableDictionary *)getAppSInfo{
    NSMutableDictionary *dict = [NSMutableDictionary new];
    static NSString * const BaseURLString = @"https://itunes.apple.com/us/rss/topfreeapplications/limit=20/json";
    
    // 1
    NSString *stringURL = [NSString stringWithFormat:@"%@", BaseURLString];
    
    // 2
    NSURL *URL = [NSURL URLWithString:stringURL];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:URL.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    return dict;
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    // #warning Incomplete method implementation -- Return the number of sections
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    // #warning Incomplete method implementation -- Return the number of items in the section
    return 1;//[_imageUrlArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MainCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:_reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    
    /*
    [cell.mainImage setImage:((DetailImage *)[_detailImageArray objectAtIndex:indexPath.row]).image];*/
    
    return cell;
}


@end
