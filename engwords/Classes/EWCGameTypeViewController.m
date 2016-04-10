//
//  EWCGameTypeViewController.m
//  engwords
//
//  Created by Konstantin on 08.12.13.
//
//

#import "EWCGameTypeViewController.h"
#import "EWCGameViewController.h"
#import "EWCCategory.h"
#import "EWCSettings.h"


@interface EWCGameTypeViewController ()

@end

@implementation EWCGameTypeViewController

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    EWCGameViewController* controller = segue.destinationViewController;
    NSString* timeKey = @"learnTime";
    if([segue.identifier isEqualToString:EWCGameLearnSegue])
    {
        controller.gameType = EWCGameTypeLearn;
        timeKey = @"learnTime";
    }
    else if ([segue.identifier isEqualToString:EWCGameDictationSegue])
    {
        controller.gameType = EWCGameTypeDictation;
        timeKey = @"dictationTime";
    }
    else if ([segue.identifier isEqualToString:EWCGameWriteSegue])
    {
        controller.gameType = EWCGameTypeWrite;
        timeKey = @"writeTime";
    }
    else if ([segue.identifier isEqualToString:EWCGameTestSegue])
    {
        controller.gameType = EWCGameTypeTest;
        timeKey = @"testTime";
    }
    NSMutableArray* words = [NSMutableArray array];
    [self.categories enumerateObjectsUsingBlock:^(EWCCategory* obj, NSUInteger idx, BOOL *stop) {
        [words addObjectsFromArray:[obj.words allObjects]];
    }];
    
    NSSortDescriptor* timeDescriptor = [NSSortDescriptor sortDescriptorWithKey:timeKey ascending:YES];
    NSMutableArray* sortDescriptors = [NSMutableArray array];
    EWCSortType sortType = [[EWCSettings sharedInstance] sortType];
    switch (sortType) {
        case EWCSortTypeAscending:
        {
            NSSortDescriptor* nameDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
            [sortDescriptors addObject:nameDescriptor];
            break;
        }
            case EWCSortTypeDescending:
        {
            NSSortDescriptor* nameDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:NO];
            [sortDescriptors addObject:nameDescriptor];
            break;
        }
        default:
            break;
    }
    [sortDescriptors addObject:timeDescriptor];
    [words sortUsingDescriptors:sortDescriptors];
    
    NSMutableArray* resultWords = [NSMutableArray array];
    NSInteger wordsCount = [[EWCSettings sharedInstance] wordsCount];
    
    for (NSInteger i = 0, count = MIN(wordsCount, words.count); i < count; ++i) {
        [resultWords addObject:words[i]];
    }
    
    if([controller isKindOfClass:[EWCGameViewController class]])
    {
        controller.words = resultWords;
    }
}

@end
