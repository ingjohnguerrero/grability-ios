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
    _appArray = [NSMutableArray new];
    [self getAppSInfo];
    
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
        NSError *localError = nil;
        NSLog(@"Json: %@", [responseObject valueForKey:@"feed"]);
        NSDictionary *parsedObject = [responseObject valueForKey:@"feed"];//[NSJSONSerialization JSONObjectWithData:[responseObject valueForKey:@"feed"] options:0 error:&localError];
        
        if (localError != nil) {
            //*error = localError;
            //return nil;
        }else{
            NSMutableArray *appsArray = [[NSMutableArray alloc] init];
            StoreApplication *storeApp;
            NSArray *results = [(NSData *)parsedObject valueForKey:@"entry"];
            NSLog(@"Count %lu", (unsigned long)results.count);
            for (NSDictionary *appDict in results) {
                storeApp = [StoreApplication new];
                NSLog(@"Name: %@", [[appDict valueForKey:@"im:name"] valueForKey:@"label"]);
                //[_appArray addObject:appDict];//[[appDict valueForKey:@"im:name"] valueForKey:@"label"]];
                [storeApp setAppId:[[appDict valueForKey:@"im:name"] valueForKey:@"label"]];
                
                [storeApp setName:[[appDict valueForKey:@"im:name"] valueForKey:@"label"]];
                
                /*
                 @property int appId;
                 @property NSString *imgPath;
                 @property NSString *name;
                 @property NSString *summary;
                 @property NSString *price;
                 @property NSString *currency;
                 */
                
                [_appArray addObject:storeApp];
                
            }
            [self.collectionView reloadData];
            
        }
        
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
    return [_appArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MainCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:_reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    //NSLog(@"Screen type: %f",[UIScreen mainScreen].scale);
    //[cell.mainImage setImage:((DetailImage *)[_detailImageArray objectAtIndex:indexPath.row]).image];
    NSMutableString *imagePath = [NSMutableString new];
    float displayScale = [UIScreen mainScreen].scale;
    
    if (displayScale < 2.0) {
        imagePath = [[[_appArray objectAtIndex:indexPath.row] valueForKey:@"im:image"][0]valueForKey:@"label"];
    }else if (displayScale == 2.0){
        imagePath = [[[_appArray objectAtIndex:indexPath.row] valueForKey:@"im:image"][1]valueForKey:@"label"];
    }else if (displayScale > 2.0){
        imagePath = [[[_appArray objectAtIndex:indexPath.row] valueForKey:@"im:image"][2]valueForKey:@"label"];
    }
    
    /*
    NSURL *imageURL = [NSURL URLWithString:imagePath];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    UIImage *image = [UIImage imageWithData:imageData];
     */
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imagePath]]];//image;
    
    //if (cell.mainImage.image == nil){
        [cell.mainImage setImage:image];
    //}
    
    
    cell.titleLabel.text = [[[_appArray objectAtIndex:indexPath.row] valueForKey:@"im:name"]valueForKey:@"label"];
    cell.priceLabel.text = [[[[_appArray objectAtIndex:indexPath.row] valueForKey:@"im:price"]valueForKey:@"attributes"] valueForKey:@"amount"];
    cell.currencyLabel.text = [[[[_appArray objectAtIndex:indexPath.row] valueForKey:@"im:price"]valueForKey:@"attributes"] valueForKey:@"currency"];
    
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"AppDetailSegue"]) {
        // get index path of selected cell
        NSIndexPath *indexPath = [_collectionView.indexPathsForSelectedItems objectAtIndex:0];
        // get the cell object
        MainCollectionViewCell *cell = (MainCollectionViewCell *)[_collectionView cellForItemAtIndexPath:indexPath];
        
        NSLog(@"Clase de destino: %@", [[segue destinationViewController]class]);
        AppDetailViewController *destination = [segue destinationViewController];
        destination.view = destination.view;
        
        destination.appNameLbl.text = @"Hello";
        destination.titleNavItem.title = @"Here goes the title";
        
        // get image from selected cell
        //self.image = cell.imageView.image;
    }
}

-(UIStoryboardSegue*)segueForUnwindingToViewController:(UIViewController *)toViewController fromViewController:(UIViewController *)fromViewController identifier:(NSString *)identifier{
    NSLog(@"%@", identifier);
    UIStoryboardSegue *unWindSegue;
   if([identifier  isEqual: @"AppDetailSegueUnWind"]){
        unWindSegue = [[CoolUIStoryboardSegue alloc]initWithIdentifier:identifier source:fromViewController destination:toViewController];
    }
    
    return unWindSegue;
}

- (IBAction)returnFromAppDetailScene:(UIStoryboardSegue*)segue {
    //self.sceneLabel.text = @"Returned from scene 2";
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    MainCollectionViewCell *cell = (MainCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    NSLog(@"%@", cell.titleLabel.text);
    [self performSegueWithIdentifier:@"AppDetailSegue" sender:self];
}

#pragma mark Collection layout
//
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
//    
//    int row = indexPath.row;
//    UIImage *img = ((DetailImage *)[_detailImageArray objectAtIndex:row]).image;
//    
//    UICollectionViewFlowLayout *layout = (id) _imageCollectionView.collectionViewLayout;
//    layout.itemSize = _collectionView.frame.size;
//    
//    NSLog(@"CollectionView size: height:%f, width:%f ", _imageCollectionView.frame.size.height, _collectionView.frame.size.width);
//    
//    CGSize cellSize = img.size;
//    
//    if(cellSize.height > cellSize.width){
//        float oldHeight = cellSize.height;
//        float scaleFactor =  200 / oldHeight;
//        
//        cellSize.width = cellSize.width * scaleFactor;
//        cellSize.height = oldHeight * scaleFactor;
//    }else{
//        float oldWidth = cellSize.width;
//        float scaleFactor = 200 / oldWidth;
//        
//        cellSize.height = cellSize.height * scaleFactor;
//        cellSize.width = oldWidth * scaleFactor;
//    }
//    
//    if(cellSize.height > _collectionView.frame.size.height){
//        cellSize.height = _collectionView.frame.size.height;
//        float oldHeight = cellSize.height;
//        float scaleFactor =  _collectionView.frame.size.height / oldHeight;
//        
//        cellSize.width = cellSize.width * scaleFactor;
//        cellSize.height = oldHeight * scaleFactor;
//    }
//    
//    NSLog(@"CollectionViewCell size: height:%f, width:%f ", cellSize.height, cellSize.width);
//    
//    return cellSize;
//    
//}
//
//-(UIImage*)imageWithImage: (UIImage*) sourceImage scaledToWidth: (float) i_width
//{
//    float oldWidth = sourceImage.size.width;
//    float scaleFactor = i_width / oldWidth;
//    
//    float newHeight = sourceImage.size.height * scaleFactor;
//    float newWidth = oldWidth * scaleFactor;
//    
//    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
//    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
//    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return newImage;
//}
//
//-(UIImage*)imageWithImage: (UIImage*) sourceImage scaledToHeight: (float) i_height
//{
//    float oldHeight = sourceImage.size.height;
//    float scaleFactor = i_height / oldHeight;
//    
//    float newWidth = sourceImage.size.width * scaleFactor;
//    float newHeight = oldHeight * scaleFactor;
//    
//    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
//    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
//    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return newImage;
//}


@end
