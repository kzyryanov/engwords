//
//  EWCSettingsViewController.m
//  engwords
//
//  Created by Konstantin on 08.12.13.
//
//

#import "EWCSettingsViewController.h"
#import "EWCSettings.h"

@interface EWCSettingsViewController ()

@property (nonatomic, weak) IBOutlet UILabel* sortLabel;
@property (nonatomic, weak) IBOutlet UILabel* countLabel;
@property (nonatomic, weak) IBOutlet UILabel* stage1Label;
@property (nonatomic, weak) IBOutlet UILabel* stage2Label;
@property (nonatomic, weak) IBOutlet UILabel* stage3Label;
@property (nonatomic, weak) IBOutlet UILabel* stage4Label;
@property (nonatomic, weak) IBOutlet UILabel* stage5Label;

@property (nonatomic, weak) IBOutlet UIButton* stage1UpButton;
@property (nonatomic, weak) IBOutlet UIButton* stage1DownButton;
@property (nonatomic, weak) IBOutlet UIButton* stage2UpButton;
@property (nonatomic, weak) IBOutlet UIButton* stage2DownButton;
@property (nonatomic, weak) IBOutlet UIButton* stage3UpButton;
@property (nonatomic, weak) IBOutlet UIButton* stage3DownButton;
@property (nonatomic, weak) IBOutlet UIButton* stage4UpButton;
@property (nonatomic, weak) IBOutlet UIButton* stage4DownButton;
@property (nonatomic, weak) IBOutlet UIButton* stage5UpButton;
@property (nonatomic, weak) IBOutlet UIButton* stage5DownButton;

-(IBAction)sortUpTapped:(id)sender;
-(IBAction)sortDownTapped:(id)sender;
-(IBAction)countUpTapped:(id)sender;
-(IBAction)countDownUpTapped:(id)sender;
-(IBAction)stage1UpTapped:(id)sender;
-(IBAction)stage1DownTapped:(id)sender;
-(IBAction)stage2UpTapped:(id)sender;
-(IBAction)stage2DownTapped:(id)sender;
-(IBAction)stage3UpTapped:(id)sender;
-(IBAction)stage3DownTapped:(id)sender;
-(IBAction)stage4UpTapped:(id)sender;
-(IBAction)stage4DownTapped:(id)sender;
-(IBAction)stage5UpTapped:(id)sender;
-(IBAction)stage5DownTapped:(id)sender;
-(IBAction)resetTapped:(id)sender;

@end

@implementation EWCSettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(NSString*)stringFromSortOrder:(EWCSortType)sortType
{
    switch (sortType) {
        case EWCSortTypeAscending:
            return @"Ascending";
        case EWCSortTypeDescending:
            return @"Descenging";
        case EWCSortTypeRandom:
            return @"Random";
        case EWCSortTypeShuffle:
            return @"Shuffle";
        default:
            break;
    }
    return @"";
}

-(NSString*)stringFromTimeInterval:(NSTimeInterval)timeInterval
{
    NSTimeInterval rounded = 0;
    NSString* interval = nil;
    if(timeInterval >= EWCYearTimeInterval)
    {
        rounded = ceil(timeInterval / EWCYearTimeInterval);
        interval = [NSString stringWithFormat:@"%.0f year", rounded];
    }
    else if(timeInterval >= EWCMonthTimeInterval)
    {
        rounded = ceil(timeInterval / EWCMonthTimeInterval);
        interval = [NSString stringWithFormat:@"%.0f month", rounded];
    }
    else if(timeInterval >= EWCWeekTimeInterval)
    {
        rounded = ceil(timeInterval / EWCWeekTimeInterval);
        interval = [NSString stringWithFormat:@"%.0f week", rounded];
    }
    else if(timeInterval >= EWCDayTimeInterval)
    {
        rounded = ceil(timeInterval / EWCDayTimeInterval);
        interval = [NSString stringWithFormat:@"%.0f day", rounded];
    }
    else
    {
        rounded = ceil(timeInterval / EWCHourTimeInterval);
        interval = [NSString stringWithFormat:@"%.0f hour", rounded];
    }
    
    if(1 < rounded)
    {
        interval = [interval stringByAppendingString:@"s"];
    }
    return interval;
}

-(void)updateView
{
    EWCSettings* settings = [EWCSettings sharedInstance];
    EWCSortType sortType = settings.sortType;
    NSInteger count = settings.wordsCount;
    NSTimeInterval stage1TimeInterval = settings.step1Interval;
    NSTimeInterval stage2TimeInterval = settings.step2Interval;
    NSTimeInterval stage3TimeInterval = settings.step3Interval;
    NSTimeInterval stage4TimeInterval = settings.step4Interval;
    NSTimeInterval stage5TimeInterval = settings.step5Interval;
    self.sortLabel.text = [self stringFromSortOrder:sortType];
    self.countLabel.text = [NSString stringWithFormat:@"%ld", (long)count];
    self.stage1Label.text = [self stringFromTimeInterval:stage1TimeInterval];
    self.stage2Label.text = [self stringFromTimeInterval:stage2TimeInterval];
    self.stage3Label.text = [self stringFromTimeInterval:stage3TimeInterval];
    self.stage4Label.text = [self stringFromTimeInterval:stage4TimeInterval];
    self.stage5Label.text = [self stringFromTimeInterval:stage5TimeInterval];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateView];
}

-(IBAction)sortUpTapped:(id)sender
{
    EWCSettings* settings = [EWCSettings sharedInstance];
    EWCSortType sortType = (settings.sortType-1+EWCSortTypesCount)%EWCSortTypesCount;
    settings.sortType = sortType;
    self.sortLabel.text = [self stringFromSortOrder:sortType];
}

-(IBAction)sortDownTapped:(id)sender
{
    EWCSettings* settings = [EWCSettings sharedInstance];
    EWCSortType sortType = (settings.sortType+1+EWCSortTypesCount)%EWCSortTypesCount;
    settings.sortType = sortType;
    self.sortLabel.text = [self stringFromSortOrder:sortType];
}

-(IBAction)countUpTapped:(id)sender
{
    EWCSettings* settings = [EWCSettings sharedInstance];
    NSInteger count = settings.wordsCount;
    count = count+1;
    if(count > settings.maxWordsCount)
    {
        count = settings.minWordsCount;
    }
    self.countLabel.text = [NSString stringWithFormat:@"%ld", (long)count];
    settings.wordsCount = count;
    
}

-(IBAction)countDownUpTapped:(id)sender
{
    EWCSettings* settings = [EWCSettings sharedInstance];
    NSInteger count = settings.wordsCount;
    count = count-1;
    if(count < settings.minWordsCount)
    {
        count = settings.maxWordsCount;
    }
    self.countLabel.text = [NSString stringWithFormat:@"%ld", (long)count];
    settings.wordsCount = count;
}

-(NSTimeInterval)nextTimeIntervalFromTimeInterval:(NSTimeInterval)timeInterval
{
    NSTimeInterval nextTimeInterval = EWCHourTimeInterval;
    if(timeInterval >= EWCYearTimeInterval)
    {
        nextTimeInterval = (floor(timeInterval/EWCYearTimeInterval)+1)*EWCYearTimeInterval;
    }
    else if(timeInterval >= EWCMonthTimeInterval)
    {
        nextTimeInterval = (floor(timeInterval/EWCMonthTimeInterval)+1)*EWCMonthTimeInterval;
        if(nextTimeInterval >= EWCYearTimeInterval)
        {
            nextTimeInterval = EWCYearTimeInterval;
        }
    }
    else if(timeInterval >= EWCWeekTimeInterval)
    {
        nextTimeInterval = (floor(timeInterval/EWCWeekTimeInterval)+1)*EWCWeekTimeInterval;
        if(nextTimeInterval >= EWCMonthTimeInterval)
        {
            nextTimeInterval = EWCMonthTimeInterval;
        }
    }
    else if(timeInterval >= EWCDayTimeInterval)
    {
        nextTimeInterval = (floor(timeInterval/EWCDayTimeInterval)+1)*EWCDayTimeInterval;
        if(nextTimeInterval >= EWCWeekTimeInterval)
        {
            nextTimeInterval = EWCWeekTimeInterval;
        }
    }
    else if(timeInterval >= EWCHourTimeInterval)
    {
        nextTimeInterval = (floor(timeInterval/EWCHourTimeInterval)+1)*EWCHourTimeInterval;
        if(nextTimeInterval >= EWCDayTimeInterval)
        {
            nextTimeInterval = EWCDayTimeInterval;
        }
    }
    return MIN(nextTimeInterval, 30*EWCYearTimeInterval);
}

-(NSTimeInterval)prevTimeIntervalFromTimeInterval:(NSTimeInterval)timeInterval
{
    NSTimeInterval prevTimeInterval = 0.0;
    if(timeInterval <= EWCDayTimeInterval)
    {
        prevTimeInterval = (floor(timeInterval/EWCHourTimeInterval)-1)*EWCHourTimeInterval;
    }
    else if(timeInterval <= EWCWeekTimeInterval)
    {
        prevTimeInterval = (floor(timeInterval/EWCDayTimeInterval)-1)*EWCDayTimeInterval;
    }
    else if(timeInterval <= EWCMonthTimeInterval)
    {
        prevTimeInterval = (ceil(timeInterval/EWCWeekTimeInterval)-1)*EWCWeekTimeInterval;
    }
    else if(timeInterval <= EWCYearTimeInterval)
    {
        prevTimeInterval = (floor(timeInterval/EWCMonthTimeInterval)-1)*EWCMonthTimeInterval;
    }
    else
    {
        prevTimeInterval = (floor(timeInterval/EWCYearTimeInterval)-1)*EWCYearTimeInterval;
    }
    return MAX(prevTimeInterval, EWCHourTimeInterval);
}

-(IBAction)stage1UpTapped:(id)sender
{
    EWCSettings* settings = [EWCSettings sharedInstance];
    NSTimeInterval timeInterval = [self nextTimeIntervalFromTimeInterval:settings.step1Interval];
    settings.step1Interval = timeInterval;
    self.stage1Label.text = [self stringFromTimeInterval:timeInterval];
}

-(IBAction)stage1DownTapped:(id)sender
{
    EWCSettings* settings = [EWCSettings sharedInstance];
    NSTimeInterval timeInterval = [self prevTimeIntervalFromTimeInterval:settings.step1Interval];
    settings.step1Interval = timeInterval;
    self.stage1Label.text = [self stringFromTimeInterval:timeInterval];
}

-(IBAction)stage2UpTapped:(id)sender
{
    EWCSettings* settings = [EWCSettings sharedInstance];
    NSTimeInterval timeInterval = [self nextTimeIntervalFromTimeInterval:settings.step2Interval];
    settings.step2Interval = timeInterval;
    self.stage2Label.text = [self stringFromTimeInterval:timeInterval];
}

-(IBAction)stage2DownTapped:(id)sender
{
    EWCSettings* settings = [EWCSettings sharedInstance];
    NSTimeInterval timeInterval = [self prevTimeIntervalFromTimeInterval:settings.step2Interval];
    settings.step2Interval = timeInterval;
    self.stage2Label.text = [self stringFromTimeInterval:timeInterval];
}

-(IBAction)stage3UpTapped:(id)sender
{
    EWCSettings* settings = [EWCSettings sharedInstance];
    NSTimeInterval timeInterval = [self nextTimeIntervalFromTimeInterval:settings.step3Interval];
    settings.step3Interval = timeInterval;
    self.stage3Label.text = [self stringFromTimeInterval:timeInterval];
}

-(IBAction)stage3DownTapped:(id)sender
{
    EWCSettings* settings = [EWCSettings sharedInstance];
    NSTimeInterval timeInterval = [self prevTimeIntervalFromTimeInterval:settings.step3Interval];
    settings.step3Interval = timeInterval;
    self.stage3Label.text = [self stringFromTimeInterval:timeInterval];
}

-(IBAction)stage4UpTapped:(id)sender
{
    EWCSettings* settings = [EWCSettings sharedInstance];
    NSTimeInterval timeInterval = [self nextTimeIntervalFromTimeInterval:settings.step4Interval];
    settings.step4Interval = timeInterval;
    self.stage4Label.text = [self stringFromTimeInterval:timeInterval];
}

-(IBAction)stage4DownTapped:(id)sender
{
    EWCSettings* settings = [EWCSettings sharedInstance];
    NSTimeInterval timeInterval = [self prevTimeIntervalFromTimeInterval:settings.step4Interval];
    settings.step4Interval = timeInterval;
    self.stage4Label.text = [self stringFromTimeInterval:timeInterval];
}

-(IBAction)stage5UpTapped:(id)sender
{
    EWCSettings* settings = [EWCSettings sharedInstance];
    NSTimeInterval timeInterval = [self nextTimeIntervalFromTimeInterval:settings.step5Interval];
    settings.step5Interval = timeInterval;
    self.stage5Label.text = [self stringFromTimeInterval:timeInterval];
}

-(IBAction)stage5DownTapped:(id)sender
{
    EWCSettings* settings = [EWCSettings sharedInstance];
    NSTimeInterval timeInterval = [self prevTimeIntervalFromTimeInterval:settings.step5Interval];
    settings.step5Interval = timeInterval;
    self.stage5Label.text = [self stringFromTimeInterval:timeInterval];
}

-(IBAction)resetTapped:(id)sender
{
    EWCSettings* settings = [EWCSettings sharedInstance];
    settings.wordsCount = 20;
    settings.sortType = EWCSortTypeAscending;
    settings.step1Interval = 2*EWCHourTimeInterval;
    settings.step2Interval = EWCDayTimeInterval;
    settings.step3Interval = EWCWeekTimeInterval;
    settings.step4Interval = EWCMonthTimeInterval;
    settings.step5Interval = EWCYearTimeInterval;
    [self updateView];
}

@end
