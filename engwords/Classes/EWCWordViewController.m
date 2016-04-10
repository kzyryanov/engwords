//
//  EWCWordViewController.m
//  engwords
//
//  Created by Konstantin on 09.12.13.
//
//

#import "EWCWordViewController.h"
#import "EWCWord.h"
#import "EWCAudioPlayer.h"
#import <Appirater/Appirater.h>

@interface EWCWordViewController ()<UITextFieldDelegate, AppiraterDelegate>

@property (nonatomic, weak) IBOutlet UIImageView* wordImageView;
@property (nonatomic, strong) IBOutlet UIGestureRecognizer* recognizer;

-(IBAction)tapOnImage:(id)sender;

@property (nonatomic, strong) NSMutableDictionary* images;
@property (nonatomic, assign) NSInteger currentImageIndex;

@end

@implementation EWCWordViewController

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if(nil == (self = [super initWithCoder:aDecoder]))
    {
        return nil;
    }
    
    self.autoNext = NO;
    self.currentImageIndex = 0;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setCurrentImageIndex:self.currentImageIndex];
    [self updateNextPrevButton];
}

-(void)updateNextPrevButton
{
    self.nextButton.hidden = ![self.delegate shouldShowNextViewControllerFromViewController:self];
    self.prevButton.hidden = ![self.delegate shouldShowPreviousViewControllerFromViewController:self];
}

-(void)playSound
{
    [[EWCAudioPlayer sharedPlayer] playSound:self.word.sound];
}

-(void)repeatButtonTapped:(id)sender
{
    [self playSound];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateNextPrevButton];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(self.autoPlay)
    {
        [self playSound];
    }
}

-(NSMutableDictionary *)images
{
    if(nil == _images)
    {
        _images = [NSMutableDictionary dictionary];
    }
    return _images;
}

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    self.images = nil;
}

-(void)setCurrentImageIndex:(NSInteger)currentImageIndex
{
    _currentImageIndex = MIN(self.word.images.count, MAX(0, currentImageIndex));
    
    if(0 < self.word.images.count)
    {
        UIImage* image = self.images[@(self.currentImageIndex)];
        if(nil == image)
        {
            image = [UIImage imageWithContentsOfFile:self.word.images[self.currentImageIndex]];
        }
        self.wordImageView.image = image;
        
    }
}

-(void)tapOnImage:(id)sender
{
    if(UIGestureRecognizerStateEnded == [sender state])
    {
        NSInteger imageIndex = (self.currentImageIndex+1)%self.word.images.count;
        if(imageIndex != self.currentImageIndex)
        {
            self.currentImageIndex = imageIndex;
        }
    }
}

-(void)nextButtonTapped:(id)sender
{
    [self.delegate showNextViewControllerFromViewController:self];
    [self updateNextPrevButton];
}

-(void)prevButtonTapped:(id)sender
{
    [self.delegate showPreviousViewControllerFromViewContrller:self];
    [self updateNextPrevButton];
}

-(BOOL)isWordCompleted
{
    return NO;
}

-(void)completeWord
{
    NSInteger rateNumber = [[[NSUserDefaults standardUserDefaults] valueForKey:kEWCRateAppNumber] integerValue];
    if(0 > rateNumber)
    {
        return;
    }
    ++rateNumber;
    if(EWCRateNumber > rateNumber)
    {
        [[NSUserDefaults standardUserDefaults] setValue:@(rateNumber) forKey:kEWCRateAppNumber];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else
    {
        [Appirater showPrompt];
        [[NSUserDefaults standardUserDefaults] setValue:@(-1) forKey:kEWCRateAppNumber];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

-(BOOL)isWordCorrect
{
    return NO;
}

@end
