//
//  EWCSettings.h
//  engwords
//
//  Created by Konstantin on 08.12.13.
//
//

#import <Foundation/Foundation.h>

typedef enum
{
    EWCSortTypeAscending,
    EWCSortTypeDescending,
    EWCSortTypeShuffle,
    EWCSortTypeRandom,
    EWCSortTypesCount
} EWCSortType;

@interface EWCSettings : NSObject

+(instancetype)sharedInstance;

@property (nonatomic, assign) NSInteger wordsCount;
@property (nonatomic, assign) EWCSortType sortType;
@property (nonatomic, assign) NSTimeInterval step1Interval;
@property (nonatomic, assign) NSTimeInterval step2Interval;
@property (nonatomic, assign) NSTimeInterval step3Interval;
@property (nonatomic, assign) NSTimeInterval step4Interval;
@property (nonatomic, assign) NSTimeInterval step5Interval;

@property (nonatomic, readonly) NSInteger minWordsCount;
@property (nonatomic, readonly) NSInteger maxWordsCount;

-(NSTimeInterval)timeIntervalForStage:(EWCWordStage)stage;
  
@end
