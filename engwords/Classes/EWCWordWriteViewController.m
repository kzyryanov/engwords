//
//  EWCWordWriteViewController.m
//  engwords
//
//  Created by Konstantin on 08.12.13.
//
//

#import "EWCWordWriteViewController.h"
#import "EWCWord.h"
#import "EWCModel.h"
#import <MagicalRecord/CoreData+MagicalRecord.h>
#import "EWCSettings.h"

@interface EWCWordWriteViewController ()

@property (nonatomic, weak) IBOutlet UILabel* wordLabel;

@end

@implementation EWCWordWriteViewController

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if(nil == (self = [super initWithCoder:aDecoder]))
    {
        return nil;
    }
    self.autoPlay = NO;
    self.autoNext = NO;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void)updateNextPrevButton
{
    [super updateNextPrevButton];
    self.prevButton.hidden = YES;
}

-(void)setTextFieldWord:(NSString *)textFieldWord
{
    [super setTextFieldWord:textFieldWord];
    self.wordLabel.text = textFieldWord;
    self.wordLabel.textColor = [UIColor whiteColor];
}

-(BOOL)isWordCompleted
{
    return 0 < self.wordLabel.text.length;
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
            word.stageWrite = @(MIN([self.word.stageWrite intValue] +1, EWCWordStageFifth));
            word.stage = @(MIN(MIN(MIN([word.stageDictation intValue], [word.stageLearn intValue]), [word.stageTest intValue]), [word.stageWrite intValue]));
            word.writeTime = [NSDate dateWithTimeIntervalSinceNow:[[EWCSettings sharedInstance] timeIntervalForStage:([word.stageWrite intValue])]];
        }];
    }
}

@end
