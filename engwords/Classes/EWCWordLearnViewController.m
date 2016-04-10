//
//  EWCWordLearnViewController.m
//  engwords
//
//  Created by Konstantin on 08.12.13.
//
//

#import "EWCWordLearnViewController.h"
#import "EWCWord.h"
#import "EWCModel.h"
#import <MagicalRecord/CoreData+MagicalRecord.h>
#import "EWCSettings.h"


@interface EWCWordLearnViewController ()

@property (nonatomic, weak) IBOutlet UILabel* wordLabel;

@end

@implementation EWCWordLearnViewController

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if(nil == (self = [super initWithCoder:aDecoder]))
    {
        return nil;
    }
    self.autoPlay = YES;
    self.autoNext = NO;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.wordLabel.text = self.word.name;
}

-(BOOL)isWordCompleted
{
    return YES;
}

-(BOOL)isWordCorrect
{
    return YES;
}

-(void)completeWord
{
    [super completeWord];
    if([self isWordCorrect])
    {
        [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
            EWCWord* word = [EWCWord MR_findFirstByAttribute:@"name" withValue:self.word.name];
            word.stageLearn = @(MIN([self.word.stageWrite intValue] +1, EWCWordStageFifth));
            word.stage = @(MIN(MIN(MIN([word.stageDictation intValue], [word.stageLearn intValue]), [word.stageTest intValue]), [word.stageWrite intValue]));
            word.learnTime = [NSDate dateWithTimeIntervalSinceNow:[[EWCSettings sharedInstance] timeIntervalForStage:([word.stageLearn intValue])]];
        }];
    }
}

@end
