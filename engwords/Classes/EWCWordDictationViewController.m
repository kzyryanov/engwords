//
//  EWCWordDictationViewController.m
//  engwords
//
//  Created by Konstantin on 08.12.13.
//
//

#import "EWCWordDictationViewController.h"
#import "EWCWord.h"
#import "EWCModel.h"
#import <MagicalRecord/CoreData+MagicalRecord.h>
#import "EWCSettings.h"

@interface EWCWordDictationViewController ()

@property (nonatomic, weak) IBOutlet UILabel* wordLabel;

@end

@implementation EWCWordDictationViewController

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if(nil == (self = [super initWithCoder:aDecoder]))
    {
        return nil;
    }
    self.autoPlay = YES;
    self.autoNext = YES;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void)setTextFieldWord:(NSString *)textFieldWord
{
    [super setTextFieldWord:textFieldWord];
    self.wordLabel.text = textFieldWord;
    if([self.word.name hasPrefix:self.wordLabel.text] || [self.wordLabel.text isEqualToString:self.word.name])
    {
        self.wordLabel.textColor = [UIColor greenColor];
    }
    else
    {
        self.wordLabel.textColor = [UIColor redColor];
    }
}

-(BOOL)isWordCompleted
{
    return [self.wordLabel.text isEqualToString:self.word.name];
}

-(BOOL)isWordCorrect
{
    return [self.wordLabel.text isEqualToString:self.word.name];
}

-(void)completeWord
{
    [super completeWord];
    if([self isWordCorrect])
    {
        [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
            EWCWord* word = [EWCWord MR_findFirstByAttribute:@"name" withValue:self.word.name];
            word.stageDictation = @(MIN([self.word.stageDictation intValue] +1, EWCWordStageFifth));
            word.stage = @(MIN(MIN(MIN([word.stageDictation intValue], [word.stageLearn intValue]), [word.stageTest intValue]), [word.stageWrite intValue]));
            word.dictationTime = [NSDate dateWithTimeIntervalSinceNow:[[EWCSettings sharedInstance] timeIntervalForStage:[word.stageDictation intValue]]];
        }];
    }
}

@end
