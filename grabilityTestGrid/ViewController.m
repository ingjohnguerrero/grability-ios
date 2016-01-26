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
    _resultArray = [NSMutableArray new];
    [self getAppSInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark AFNetworking
- (BOOL)connected {
    return [AFNetworkReachabilityManager sharedManager].reachable;
}

- (NSMutableDictionary *)getAppSInfo{
    NSMutableDictionary *dict = [NSMutableDictionary new];
    static NSString * const BaseURLString = @"https://itunes.apple.com/us/rss/topfreeapplications/limit=20/json";
    
    // 1
    NSString *stringURL = [NSString stringWithFormat:@"%@", BaseURLString];
    
    // 2
    if (![self currentNetworkStatus]) {
        NSLog(@"There IS NO internet connection");
        _appArray = [NSKeyedUnarchiver unarchiveObjectWithFile:[StoreApplication getFileURL]];
        [self.collectionView reloadData];
        //[self showNetWorkAlert];
    } else {
        NSLog(@"There IS internet connection");
        NSURL *URL = [NSURL URLWithString:stringURL];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager GET:URL.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            //NSLog(@"JSON: %@", responseObject);
            NSError *localError = nil;
            //NSLog(@"Json: %@", [responseObject valueForKey:@"feed"]);
            NSDictionary *parsedObject = [responseObject valueForKey:@"feed"];//[NSJSONSerialization JSONObjectWithData:[responseObject valueForKey:@"feed"] options:0 error:&localError];
            
            if (localError != nil) {
                //*error = localError;
                //return nil;
            }else{
                NSMutableArray *appsArray = [[NSMutableArray alloc] init];
                StoreApplication *storeApp;
                NSArray *results = [(NSData *)parsedObject valueForKey:@"entry"];
                //NSLog(@"Count %lu", (unsigned long)results.count);
                
                NSMutableString *imagePath = [NSMutableString new];
                float displayScale = [UIScreen mainScreen].scale;
                
                for (NSDictionary *appDict in results) {
                    storeApp = [StoreApplication new];
                    //NSLog(@"Name: %@", [[appDict valueForKey:@"im:name"] valueForKey:@"label"]);
                    [_resultArray addObject:appDict];//[[appDict valueForKey:@"im:name"] valueForKey:@"label"]];
                    [storeApp setAppId:[[appDict valueForKey:@"im:name"] valueForKey:@"label"]];
                    
                    [storeApp setName:[[appDict valueForKey:@"im:name"] valueForKey:@"label"]];
                    
                    [storeApp setPrice:[[[appDict valueForKey:@"im:price"] valueForKey:@"attributes"] valueForKey:@"amount"]];
                    
                    [storeApp setCurrency:[[[appDict valueForKey:@"im:price"] valueForKey:@"attributes"] valueForKey:@"currency"]];
                    
                    [storeApp setSummary:[[appDict valueForKey:@"summary"] valueForKey:@"label"]];
                    
                    if (displayScale < 2.0) {
                        [storeApp setImgPath: [[appDict valueForKey:@"im:image"][0]valueForKey:@"label"]];
                    }else if (displayScale == 2.0){
                        [storeApp setImgPath: [[appDict valueForKey:@"im:image"][1]valueForKey:@"label"]];
                    }else if (displayScale > 2.0){
                        [storeApp setImgPath: [[appDict valueForKey:@"im:image"][2]valueForKey:@"label"]];
                    }
                    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:storeApp.imgPath]]];
                    
                    [storeApp setAppImage:image];
                    
                    [_appArray addObject:storeApp];
                    
                }
                [self.collectionView reloadData];
                
                if ([NSKeyedArchiver archiveRootObject:_appArray toFile:[StoreApplication getFileURL]]){
                    NSLog(@"Guardado en %@", [StoreApplication getFileURL]);
                }else{
                    NSLog(@"Error al guardar");
                }
                
            }
            
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            _appArray = [NSKeyedUnarchiver unarchiveObjectWithFile:[StoreApplication getFileURL]];
            [self showNetWorkAlert];
        }];
    }
    
    
    
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
    
    
    UIImage *image = [[_appArray objectAtIndex:indexPath.row] appImage];
    [cell.mainImage setImage:image];
    
    
    cell.titleLabel.text = [[_appArray objectAtIndex:indexPath.row] name];
    cell.priceLabel.text = [[_appArray objectAtIndex:indexPath.row] price];
    cell.currencyLabel.text = [[_appArray objectAtIndex:indexPath.row] currency];
    
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"AppDetailSegue"]) {
        // get index path of selected cell
        NSIndexPath *indexPath = [_collectionView.indexPathsForSelectedItems objectAtIndex:0];
        // get the cell object
        MainCollectionViewCell *cell = (MainCollectionViewCell *)[_collectionView cellForItemAtIndexPath:indexPath];
        StoreApplication *selectedApp = [_appArray objectAtIndex:indexPath.row];
        
        NSLog(@"Clase de destino: %@", [[segue destinationViewController]class]);
        AppDetailViewController *destination = [segue destinationViewController];
        destination.view = destination.view;
        
        destination.appNameLbl.text = [selectedApp name];
        destination.titleNavItem.title = [selectedApp name];
        [destination.summaryTextView setText:[selectedApp summary]];
        destination.currencyLabl.text = [selectedApp currency];
        destination.priceLbl.text = [selectedApp price];
        [destination.appIconUIImage setImage:[selectedApp appImage]];
        
        
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

#pragma mark To Check Network Connection.
- (BOOL) currentNetworkStatus {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    BOOL connected;
    const char *host = "www.apple.com";
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(NULL, host);
    SCNetworkReachabilityFlags flags;
    connected = SCNetworkReachabilityGetFlags(reachability, &flags);
    BOOL isConnected = YES;
    isConnected = connected && (flags & kSCNetworkFlagsReachable) && !(flags & kSCNetworkFlagsConnectionRequired);
    CFRelease(reachability);
    
    if(!isConnected) {
        // sleep(1);
        [self showNetWorkAlert];
        //[self check];
    }
    else
        return isConnected;
    //[self sendRequest];
    return isConnected;
}

-(void) showNetWorkAlert {
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"DefaultStyle"
                              message:@"Usando datos locales por no conexión a internet"
                              delegate:self
                              cancelButtonTitle:@"Cancel"
                              otherButtonTitles:@"OK", nil];
    
    [alertView show];
}



@end
