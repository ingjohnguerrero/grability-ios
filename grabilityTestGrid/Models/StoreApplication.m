//
//  StoreApplication.m
//  grabilityTestGrid
//
//  Created by John Edwin Guerrero Ayala on 1/21/16.
//  Copyright © 2016 ingjohnguerrero. All rights reserved.
//

#import "StoreApplication.h"

@implementation StoreApplication

- (id)init {
    if ((self = [super init])) {
    }
    return self;
}

- (id)initWithDocPath:(NSString *)docPath {
    if ((self = [super init])) {
        _docPath = [docPath copy];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    self.appId = [aDecoder decodeObjectForKey:@"appId"];
    self.name = [aDecoder decodeObjectForKey:@"name"];
    self.imgPath = [aDecoder decodeObjectForKey:@"imgPath"];
    self.summary = [aDecoder decodeObjectForKey:@"summary"];
    self.price = [aDecoder decodeObjectForKey:@"price"];
    self.currency = [aDecoder decodeObjectForKey:@"currency"];
    self.appImage = [aDecoder decodeObjectForKey:@"appImage"];
    self.categoryId = [aDecoder decodeObjectForKey:@"categoryId"];
    self.categoryTerm = [aDecoder decodeObjectForKey:@"categoryTerm"];
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:self.appId forKey:@"appId"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.imgPath forKey:@"imgPath"];
    [aCoder encodeObject:self.summary forKey:@"summary"];
    [aCoder encodeObject:self.price forKey:@"price"];
    [aCoder encodeObject:self.currency forKey:@"currency"];
    [aCoder encodeObject:self.appImage forKey:@"appImage"];
    [aCoder encodeObject:self.categoryId forKey:@"categoryId"];
    [aCoder encodeObject:self.categoryTerm forKey:@"categoryTerm"];
    
}

+(NSString *)getFileURL{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent: kDataFile];
    
    if (filePath) {
        return filePath;
    }else{
        return nil;
    }
    
}



+ (NSString *)getPrivateDocsDir {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"privateDocuments"];
    
    NSError *error;
    [[NSFileManager defaultManager] createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES attributes:nil error:&error];
    
    return documentsDirectory;
    
}

@end
