//
//  EWCWordTestViewController.m
//  engwords
//
//  Created by Konstantin on 08.12.13.
//
//

#import "EWCWordTestViewController.h"
#import "EWCWord.h"
#import "EWCModel.h"
#import <MagicalRecord/CoreData+MagicalRecord.h>
#import "EWCSettings.h"

@interface EWCWordTestViewController ()

@property (nonatomic, strong) IBOutletCollection(UIButton) NSArray* buttons;
@property (nonatomic, strong) IBOutletCollection(UILabel) NSArray* labels;

@property (nonatomic, strong) NSMutableArray* words;

@property (nonatomic, strong) EWCWord* selectedWord;

-(IBAction)selectWord:(id)sender;

@property (nonatomic, strong) NSTimer* nextTimer;

@end

@implementation EWCWordTestViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.words = [NSMutableArray array];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"NOT (name LIKE %@)", self.word.name];
    NSMutableArray* words = [[EWCWord MR_findAllWithPredicate:predicate] mutableCopy];
    
    NSInteger index = arc4random_uniform(self.labels.count);
    
    for (NSInteger i = 0; i < self.labels.count; ++i) {
        EWCWord* w = nil;
        if(index == i)
        {
            w = self.word;
        }
        else
        {
            w = words[arc4random_uniform(words.count)];
            [words removeObject:w];
        }
        [self.words addObject:w];
        [self.labels[i] setText:w.name];
    }
    for (UIButton* button in self.buttons) {
        [button setUserInteractionEnabled:![self isWordCompleted]];
    }
}

-(BOOL)isWordCompleted
{
    return nil != self.selectedWord;
}

-(BOOL)isWordCorrect
{
    return [self.selectedWord.name isEqualToString:self.word.name];
}

-(void)completeWord
{
    [super completeWord];
    [self.nextTimer invalidate];
    self.nextTimer = nil;
    if([self isWordCorrect])
    {
        [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
            EWCWord* word = [EWCWord MR_findFirstByAttribute:@"name" withValue:self.word.name];
            word.stageTest = @(MIN([self.word.stageWrite intValue] +1, EWCWordStageFifth));
            word.stage = @(MIN(MIN(MIN([word.stageDictation intValue], [word.stageLearn intValue]), [word.stageTest intValue]), [word.stageWrite intValue]));
            word.testTime = [NSDate dateWithTimeIntervalSinceNow:[[EWCSettings sharedInstance] timeIntervalForStage:([word.stageTest intValue])]];
        }];
    }
}

//-(void)playSound
//{
//    
//}

-(void)next
{
    [self.delegate showNextViewControllerFromViewController:self];
}

-(void)selectWord:(UIButton*)sender
{
    NSInteger index = [self.buttons indexOfObject:sender];
    if(NSNotFound != index)
    {
        self.selectedWord = self.words[index];
        for (UIButton* button in self.buttons) {
            [button setUserInteractionEnabled:NO];
        }
        if([self isWordCorrect])
        {
            [self playSound];
            [sender setBackgroundColor:[UIColor greenColor]];
        }
        else
        {
            [sender setBackgroundColor:[UIColor redColor]];
        }
        [self.nextTimer invalidate];
        self.nextTimer = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(next) userInfo:nil repeats:NO];
    }
}

@end
