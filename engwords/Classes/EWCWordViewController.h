//
//  EWCWordViewController.h
//  engwords
//
//  Created by Konstantin on 09.12.13.
//
//

#import <UIKit/UIKit.h>

@class EWCWord;
@class EWCWordViewController;

@protocol EWCWordViewControllerDelegate <NSObject>
-(void)showPreviousViewControllerFromViewContrller:(EWCWordViewController*)viewController;
-(void)showNextViewControllerFromViewController:(EWCWordViewController*)viewController;
-(BOOL)shouldShowPreviousViewControllerFromViewController:(EWCWordViewController*)viewController;
-(BOOL)shouldShowNextViewControllerFromViewController:(EWCWordViewController*)viewController;
@end

@interface EWCWordViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIButton* prevButton;
@property (nonatomic, weak) IBOutlet UIButton* nextButton;

@property (nonatomic, strong) EWCWord* word;

@property (nonatomic, weak) id<EWCWordViewControllerDelegate> delegate;

@property (nonatomic, strong) NSString* textFieldWord;
@property (nonatomic, assign) BOOL autoPlay;
@property (nonatomic, assign) BOOL autoNext;

-(void)playSound;

-(IBAction)repeatButtonTapped:(id)sender;
-(IBAction)nextButtonTapped:(id)sender;
-(IBAction)prevButtonTapped:(id)sender;

-(void)updateNextPrevButton;

-(BOOL)isWordCompleted;
-(void)completeWord;
-(BOOL)isWordCorrect;

@end
