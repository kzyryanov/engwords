//
//  EWCSettings.m
//  engwords
//
//  Created by Konstantin on 08.12.13.
//
//

#import "EWCSettings.h"

static NSString* const kSettingsWordsCount = @"kSettingsWordsCount";
static NSString* const kSettingsSortType = @"kSettingsSortType";
static NSString* const kSettingsStep1Interval = @"kSettingsStep1Interval";
static NSString* const kSettingsStep2Interval = @"kSettingsStep2Interval";
static NSString* const kSettingsStep3Interval = @"kSettingsStep3Interval";
static NSString* const kSettingsStep4Interval = @"kSettingsStep4Interval";
static NSString* const kSettingsStep5Interval = @"kSettingsStep5Interval";

static NSInteger const DefaultWordsCount = 20;
static NSInteger const MinWordsCount = 5;
static NSInteger const MaxWordsCount = 100;
static EWCSortType const DefaultSortType = EWCSortTypeAscending;

@implementation EWCSettings

+(instancetype)sharedInstance
{
    static dispatch_once_t pred;
    static id instance;
    dispatch_once(&pred, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

-(id)init
{
    if(nil == (self = [super init]))
    {
        return nil;
    }
    
    NSDictionary* settings = [[NSUserDefaults standardUserDefaults] objectForKey:kSettings];
    NSNumber* wordsCount = settings[kSettingsWordsCount];
    if(nil == wordsCount)
    {
        wordsCount = @(DefaultWordsCount);
    }
    self.wordsCount = [wordsCount integerValue];
    NSNumber* sortType = settings[kSettingsSortType];
    if(nil == sortType)
    {
        sortType = @(DefaultSortType);
    }
    self.sortType = [sortType intValue];
    NSNumber* step1Interval = settings[kSettingsStep1Interval];
    if(nil == step1Interval)
    {
        step1Interval = @(2*EWCHourTimeInterval);
    }
    self.step1Interval = [step1Interval doubleValue];
    NSNumber* step2Interval = settings[kSettingsStep2Interval];
    if(nil == step2Interval)
    {
        step2Interval = @(EWCDayTimeInterval);
    }
    self.step2Interval = [step2Interval doubleValue];
    NSNumber* step3Interval = settings[kSettingsStep3Interval];
    if(nil == step3Interval)
    {
        step3Interval = @(EWCWeekTimeInterval);
    }
    self.step3Interval = [step3Interval doubleValue];
    NSNumber* step4Interval = settings[kSettingsStep4Interval];
    if(nil == step4Interval)
    {
        step4Interval = @(EWCMonthTimeInterval);
    }
    self.step4Interval = [step4Interval doubleValue];
    NSNumber* step5Interval = settings[kSettingsStep5Interval];
    if(nil == step5Interval)
    {
        step5Interval = @(EWCYearTimeInterval);
    }
    self.step5Interval = [step5Interval doubleValue];
    
    return self;
}

-(void)saveSettings
{
    NSDictionary* settings = @{
                               kSettingsWordsCount:@(self.wordsCount),
                               kSettingsSortType:@(self.sortType),
                               kSettingsStep1Interval:@(self.step1Interval),
                               kSettingsStep2Interval:@(self.step2Interval),
                               kSettingsStep3Interval:@(self.step3Interval),
                               kSettingsStep4Interval:@(self.step4Interval),
                               kSettingsStep5Interval:@(self.step5Interval),
                               };
    [[NSUserDefaults standardUserDefaults] setObject:settings forKey:kSettings];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)setSortType:(EWCSortType)sortType
{
    _sortType = sortType;
    [self saveSettings];
}

-(void)setWordsCount:(NSInteger)wordsCount
{
    _wordsCount = wordsCount;
    [self saveSettings];
}

-(void)setStep1Interval:(NSTimeInterval)step1Interval
{
    _step1Interval = step1Interval;
    [self saveSettings];
}

-(void)setStep2Interval:(NSTimeInterval)step2Interval
{
    _step2Interval = step2Interval;
    [self saveSettings];
}

-(void)setStep3Interval:(NSTimeInterval)step3Interval
{
    _step3Interval = step3Interval;
    [self saveSettings];
}

-(void)setStep4Interval:(NSTimeInterval)step4Interval
{
    _step4Interval = step4Interval;
    [self saveSettings];
}

-(void)setStep5Interval:(NSTimeInterval)step5Interval
{
    _step5Interval = step5Interval;
    [self saveSettings];
}

-(NSInteger)minWordsCount
{
    return MinWordsCount;
}

-(NSInteger)maxWordsCount
{
    return MaxWordsCount;
}

-(NSTimeInterval)timeIntervalForStage:(EWCWordStage)stage
{
    switch (stage) {
        case EWCWordStageFirst:
            return self.step1Interval;
        case EWCWordStageSecond:
            return self.step2Interval;
        case EWCWordStageThird:
            return self.step3Interval;
        case EWCWordStageFourth:
            return self.step4Interval;
        case EWCWordStageFifth:
            return self.step5Interval;
        default:
            break;
    }
    return 0.0;
}

@end
