//
//  StoreApplication.h
//  grabilityTestGrid
//
//  Created by John Edwin Guerrero Ayala on 1/21/16.
//  Copyright © 2016 ingjohnguerrero. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define kDataFile       @"data.plist"

@interface StoreApplication : NSObject<NSCoding>{
    NSString *_docPath;
}

@property NSString *appId;
@property NSString *imgPath;
@property NSString *name;
@property NSString *summary;
@property NSString *price;
@property NSString *currency;
@property NSString *categoryId;
@property NSString *categoryTerm;
@property UIImage *appImage;

+ (NSString *)getPrivateDocsDir;
+ (NSURL *)getFileURL;

@end
