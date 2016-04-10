//
//  EWCConstValues.h
//  engwords
//
//  Created by Konstantin on 08.12.13.
//
//

#import <Foundation/Foundation.h>

extern NSString* const kSettings;
extern NSString* const kLastSelectedCategories;
extern NSString* const kEWCRateAppNumber;

extern NSInteger const EWCRateNumber;

extern NSString* const EWCGameTypeSegue;
extern NSString* const EWCGamePageSegue;
extern NSString* const EWCGameLearnSegue;
extern NSString* const EWCGameDictationSegue;
extern NSString* const EWCGameWriteSegue;
extern NSString* const EWCGameTestSegue;
extern NSString* const EWCResultSegue;

extern NSString* const EWCCancelButtonTitle;
extern NSString* const EWCSkipButtonTitle;

typedef enum
{
    EWCWordStageNone,
    EWCWordStageFirst,
    EWCWordStageSecond,
    EWCWordStageThird,
    EWCWordStageFourth,
    EWCWordStageFifth,
    EWCWordStageCount
} EWCWordStage;

typedef enum
{
    EWCResultFail,
    EWCResultPass,
    EWCResultNotBad,
    EWCResultGood,
    EWCResultPerfect
} EWCResult;

extern NSTimeInterval const EWCHourTimeInterval;
extern NSTimeInterval const EWCDayTimeInterval;
extern NSTimeInterval const EWCWeekTimeInterval;
extern NSTimeInterval const EWCMonthTimeInterval;
extern NSTimeInterval const EWCYearTimeInterval;

EWCResult resultFromPercentage(CGFloat percentage);