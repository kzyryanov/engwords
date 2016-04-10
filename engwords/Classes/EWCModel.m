//
//  EWCModel.m
//  engwords
//
//  Created by Konstantin on 24.11.13.
//
//

#import "EWCModel.h"
#import "ZipArchive.h"
#import "EWCDictionary.h"
#import "EWCWord.h"
#import "EWCCategory.h"
#import <MagicalRecord/CoreData+MagicalRecord.h>

@interface EWCModel ()

@end

@implementation EWCModel

- (NSString *) applicationDocumentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

+(instancetype)sharedModel
{
    static dispatch_once_t pred;
    static id instance;
    dispatch_once(&pred, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

-(NSArray *)dictionaries
{
    NSArray* dictionaries = [EWCDictionary MR_findAllSortedBy:@"name" ascending:YES];
    
    if(0 < dictionaries.count)
    {
        return dictionaries;
    }
    
    NSString* documentsDirectory = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"Data"];
    NSLog(@"%@", documentsDirectory);
    NSFileManager* fileManager = [NSFileManager defaultManager];
    
        NSError* error = nil;
    
    BOOL isDir;
    
    if(![fileManager fileExistsAtPath:documentsDirectory isDirectory:&isDir])
    {
        BOOL created = [fileManager createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES attributes:nil error:&error];
        if(!created || nil != error)
        {
            NSLog(@"Error with creating documents directory: %@", error);
            return nil;
        }
    }


    
    NSInteger i = 0;
    NSString* path = nil;
    while (nil != (path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%d", i] ofType:@"zip"]))
    {
        NSString* documentPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%d", i]];
        if(![fileManager fileExistsAtPath:documentPath isDirectory:&isDir])
        {
            ZipArchive* zipArchive = [[ZipArchive alloc] init];
            [zipArchive UnzipOpenFile:path];
            [zipArchive UnzipFileTo:documentsDirectory overWrite:YES];
            [zipArchive UnzipCloseFile];
        }
        [self readDictionaryFromPath:documentPath];
        ++i;
    }
    
    return [EWCDictionary MR_findAllSortedBy:@"name" ascending:YES];
}

-(void)readDictionaryFromPath:(NSString*)documentPath
{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    BOOL isDir;
    NSError* error;
    
    NSString* infoPath = [documentPath stringByAppendingPathComponent:@"info.csv"];
    if(![fileManager fileExistsAtPath:infoPath isDirectory:&isDir])
    {
        NSLog(@"No info.csv! in %@", infoPath);
        return;
    }
    
    NSString* content = [NSString stringWithContentsOfFile:infoPath encoding:NSUTF8StringEncoding error:&error];
    if(nil == content || nil != error)
    {
        NSLog(@"%@", error);
        return;
    }
    
    NSArray* components = [content componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    if(0 >= components.count)
    {
        NSLog(@"Empty info.csv");
        return;
    }
    
    NSArray* lineComponents = [components[0] componentsSeparatedByString:@";"];
    if(0 >= lineComponents.count)
    {
        NSLog(@"Empty title of info.csv");
        return;
    }
    
    NSString* dictionaryTitle = lineComponents[0];
    NSLog(@"Title: %@", dictionaryTitle);
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        for (NSInteger j = 1, count = components.count; j < count; ++j) {
            NSArray* wordLine = [components[j] componentsSeparatedByString:@";"];
            if(4 > wordLine.count)
            {
                continue;
            }
            NSString* categoryName = wordLine[0];
            NSString* wordTitle = wordLine[1];
            NSString* sound = [[documentPath stringByAppendingPathComponent:@"Sounds"] stringByAppendingPathComponent:wordLine[2]];
            NSArray* images = [wordLine subarrayWithRange:NSMakeRange(3, wordLine.count-3)];
            NSMutableArray* imagesPaths = [NSMutableArray array];
            [images enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                if(0 < [obj length])
                {
                    [imagesPaths addObject:[[documentPath stringByAppendingPathComponent:@"Images"] stringByAppendingPathComponent:obj]];
                }
            }];
            
            EWCWord* word = [EWCWord MR_createInContext:localContext];
            word.name = wordTitle;
            word.sound = sound;
            word.images = imagesPaths;
            
            EWCCategory* category = [EWCCategory MR_findFirstByAttribute:@"name" withValue:categoryName inContext:localContext];
            if(nil == category)
            {
                category = [EWCCategory MR_createInContext:localContext];
                category.name = categoryName;
            }
            [category addWordsObject:word];
            
            EWCDictionary* dictionary = [EWCDictionary MR_findFirstByAttribute:@"name" withValue:dictionaryTitle inContext:localContext];
            if(nil == dictionary)
            {
                dictionary = [EWCDictionary MR_createInContext:localContext];
                dictionary.name = dictionaryTitle;
            }
            
            [dictionary addCategoriesObject:category];
        }
    }];
}

-(NSArray *)categories
{
    return [EWCCategory MR_findAllSortedBy:@"name" ascending:YES];
}

@end
