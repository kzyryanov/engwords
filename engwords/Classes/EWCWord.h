//
//  EWCWord.h
//  engwords
//
//  Created by Konstantin on 23.01.14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class EWCCategory;

@interface EWCWord : NSManagedObject

@property (nonatomic, retain) NSDate * dictationTime;
@property (nonatomic, retain) NSArray* images;
@property (nonatomic, retain) NSDate * learnTime;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * sound;
@property (nonatomic, retain) NSNumber * stageDictation;
@property (nonatomic, retain) NSNumber * stageLearn;
@property (nonatomic, retain) NSNumber * stageTest;
@property (nonatomic, retain) NSNumber * stageWrite;
@property (nonatomic, retain) NSDate * testTime;
@property (nonatomic, retain) NSDate * writeTime;
@property (nonatomic, retain) NSNumber * stage;
@property (nonatomic, retain) EWCCategory *category;

@end
