//
//  EWCGameViewController.m
//  engwords
//
//  Created by Konstantin on 08.12.13.
//
//

#import "EWCGameViewController.h"
#import "EWCWord.h"
#import "EWCWordViewController.h"
#import "EWCWordLearnViewController.h"
#import "EWCWordDictationViewController.h"
#import "EWCWordWriteViewController.h"
#import "EWCWordTestViewController.h"
#import "EWCAlertView.h"
#import "EWCResultViewController.h"

@interface EWCGameViewController ()<UIPageViewControllerDataSource, UIPageViewControllerDelegate, EWCWordViewControllerDelegate, UITextFieldDelegate, UIAlertViewDelegate>

@property (nonatomic, weak) IBOutlet UITextField* textField;
@property (nonatomic, weak) IBOutlet UILabel* titleLabel;
@property (nonatomic, weak) IBOutlet UIPageViewController* pageController;

@property (nonatomic, strong) NSMutableDictionary* viewControllers;

@property (nonatomic, strong) NSString* wordControllerIdentifier;

@property (nonatomic, assign) NSInteger correctWordsCount;

-(IBAction)textChanged:(id)sender;

@end

@implementation EWCGameViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    switch (self.gameType) {
        case EWCGameTypeDictation:
        {
            [self.textField becomeFirstResponder];
            self.titleLabel.text = @"DICTATION";
            self.wordControllerIdentifier = NSStringFromClass([EWCWordDictationViewController class]);
            break;
        }
        case EWCGameTypeTest:
        {
            self.titleLabel.text = @"TEST";
            self.wordControllerIdentifier = NSStringFromClass([EWCWordTestViewController class]);
            break;
        }
        case EWCGameTypeWrite:
        {
            [self.textField becomeFirstResponder];
            self.titleLabel.text = @"WRITE";
            self.wordControllerIdentifier = NSStringFromClass([EWCWordWriteViewController class]);
            break;
        }
        default:
        {
            self.titleLabel.text = @"LEARN";
            self.wordControllerIdentifier = NSStringFromClass([EWCWordLearnViewController class]);
            break;
        }
    }
    
    if (0 < self.words.count)
    {
        EWCWord* word = self.words[0];
        
        EWCWordViewController* controller = self.viewControllers[word.name];
        if(nil == controller)
        {
            controller = [self.storyboard instantiateViewControllerWithIdentifier:self.wordControllerIdentifier];
            controller.delegate = self;
            controller.word = word;
            [self.viewControllers setObject:controller forKey:word.name];
        }
        [self.pageController setViewControllers:@[controller] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    }
    [self.textField addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
}

-(NSMutableDictionary *)viewControllers
{
    if(nil == _viewControllers)
    {
        _viewControllers = [NSMutableDictionary dictionary];
    }
    return _viewControllers;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:EWCGamePageSegue])
    {
        self.pageController = segue.destinationViewController;
        self.pageController.delegate = self;
        self.pageController.dataSource = self;
    }
    else if([segue.identifier isEqualToString:EWCResultSegue])
    {
        EWCResultViewController* vc = segue.destinationViewController;
        CGFloat percentage = (CGFloat)self.correctWordsCount / (CGFloat)self.words.count;
        EWCResult result = resultFromPercentage(percentage);
        vc.result = result;
        vc.title = self.titleLabel.text;
    }
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(EWCWordViewController *)viewController
{
    return nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(EWCWordViewController *)viewController
{
    return nil;
}

-(void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if(completed)
    {
        for (EWCWordViewController* controller in previousViewControllers) {
            [controller completeWord];
        }
        for (EWCWordViewController* controller in pageViewController.viewControllers) {
            self.textField.text = controller.textFieldWord;
        }
    }
}



-(void)performNextViewControllerFromViewController:(EWCWordViewController*)viewController
{
    [viewController completeWord];
    if([self isGame] && [viewController isWordCorrect])
    {
        ++self.correctWordsCount;
    }
    NSInteger index = [self.words indexOfObject:viewController.word];
    if(NSNotFound == index)
    {
        index = 0;
    }
    index = (index+1+self.words.count)%self.words.count;
    if(0 == index && [self isGame])
    {
        [self performSegueWithIdentifier:EWCResultSegue sender:self];
        return;
    }
    EWCWord* word = nil;
    if(0 < self.words.count)
    {
        word = self.words[index];
    }
    if(nil != word)
    {
        EWCWordViewController* controller = self.viewControllers[word.name];
        if(nil == controller)
        {
            controller = [self.storyboard instantiateViewControllerWithIdentifier:self.wordControllerIdentifier];
            controller.delegate = self;
            controller.word = word;
            [self.viewControllers setObject:controller forKey:word.name];
        }
        [self.pageController setViewControllers:@[controller] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished) {
            self.textField.text = controller.textFieldWord;
        }];
    }
}

-(void)alertView:(EWCAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSString* title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:EWCSkipButtonTitle])
    {
        [self performNextViewControllerFromViewController:alertView.object];
    }
}

-(void)showNextViewControllerFromViewController:(EWCWordViewController *)viewController
{
    if(![viewController isWordCompleted])
    {
        EWCAlertView* alert = [[EWCAlertView alloc] initWithTitle:@"Message" message:@"Do you want to skip this word?" delegate:self cancelButtonTitle:EWCCancelButtonTitle otherButtonTitles:EWCSkipButtonTitle, nil];
        alert.object = viewController;
        [alert show];
    }
    else
    {
        [self performNextViewControllerFromViewController:viewController];
    }
}

-(void)showPreviousViewControllerFromViewContrller:(EWCWordViewController *)viewController
{
    NSInteger index = [self.words indexOfObject:viewController.word];
    if(NSNotFound == index)
    {
        index = 0;
    }
    index = (index-1+self.words.count)%self.words.count;
    EWCWord* word = nil;
    if(0 < self.words.count)
    {
        word = self.words[index];
    }
    if(nil != word)
    {
        EWCWordViewController* controller = self.viewControllers[word.name];
        if(nil == controller)
        {
            controller = [self.storyboard instantiateViewControllerWithIdentifier:self.wordControllerIdentifier];
            controller.delegate = self;
            controller.word = word;
            [self.viewControllers setObject:controller forKey:word.name];
        }
        [self.pageController setViewControllers:@[controller] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:^(BOOL finished) {
            self.textField.text = controller.textFieldWord;
        }];
    }
}

-(BOOL)shouldShowPreviousViewControllerFromViewController:(EWCWordViewController *)viewController
{
    NSInteger index = [self.words indexOfObject:viewController.word];
    return 0 < index && ![self isGame];
}

-(BOOL)shouldShowNextViewControllerFromViewController:(EWCWordViewController *)viewController
{
    NSInteger index = [self.words indexOfObject:viewController.word];
    return index < self.words.count-1 || [self isGame];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString* result = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if(result.length > 100)
    {
        return NO;
    }
    for (EWCWordViewController* viewController in self.pageController.viewControllers) {
        return ![viewController isWordCompleted] || [self isGame];
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    for (EWCWordViewController* viewController in self.pageController.viewControllers) {
        [self showNextViewControllerFromViewController:viewController];
        return YES;
    }

    return YES;
}

-(void)textChanged:(id)sender
{
    for (EWCWordViewController* viewController in self.pageController.viewControllers) {
        viewController.textFieldWord = self.textField.text;
        if([viewController isWordCompleted])
        {
            [viewController completeWord];
            if([viewController isWordCorrect])
            {
                [viewController playSound];
            }
            if(viewController.autoNext)
            {
                [self performSelector:@selector(showNextViewControllerFromViewController:) withObject:viewController afterDelay:1.5];
            }
        }
    }
}

-(BOOL)isGame
{
    return (self.gameType == EWCGameTypeTest || self.gameType == EWCGameTypeWrite);
}

@end
