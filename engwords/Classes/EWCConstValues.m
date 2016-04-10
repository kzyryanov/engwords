//
//  EWCConstValues.m
//  engwords
//
//  Created by Konstantin on 08.12.13.
//
//

#import "EWCConstValues.h"

NSString* const kSettings = @"kSettings";
NSString* const kLastSelectedCategories = @"kLastSelectedCategories";
NSString* const kEWCRateAppNumber = @"kEWCRateAppNumber";

NSInteger const EWCRateNumber = 30;

NSString* const EWCGameTypeSegue = @"EWCGameTypeSegue";
NSString* const EWCGamePageSegue = @"EWCGamePageSegue";
NSString* const EWCGameLearnSegue = @"EWCGameLearnSegue";
NSString* const EWCGameDictationSegue = @"EWCGameDictationSegue";
NSString* const EWCGameWriteSegue = @"EWCGameWriteSegue";
NSString* const EWCGameTestSegue = @"EWCGameTestSegue";
NSString* const EWCResultSegue = @"EWCResultSegue";

NSString* const EWCCancelButtonTitle = @"Cancel";
NSString* const EWCSkipButtonTitle = @"Skip";

NSTimeInterval const EWCHourTimeInterval = 3600.0;
NSTimeInterval const EWCDayTimeInterval = 24*EWCHourTimeInterval;
NSTimeInterval const EWCWeekTimeInterval = 7*EWCDayTimeInterval;
NSTimeInterval const EWCMonthTimeInterval = 30*EWCDayTimeInterval;
NSTimeInterval const EWCYearTimeInterval = 12*EWCMonthTimeInterval;

EWCResult resultFromPercentage(CGFloat percentage)
{
    if(0.25 > percentage)
    {
        return EWCResultFail;
    }
    if(0.4 > percentage)
    {
        return EWCResultPass;
    }
    if(0.75 > percentage)
    {
        return EWCResultNotBad;
    }
    if(0.9 > percentage)
    {
        return EWCResultGood;
    }
    return EWCResultPerfect;
}