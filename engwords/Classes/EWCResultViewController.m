//
//  EWCResultViewController.m
//  engwords
//
//  Created by Konstantin on 15.01.14.
//
//

#import "EWCResultViewController.h"
#import "UIViewController+Back.h"
#import "EWCCategoriesViewController.h"

@interface EWCResultViewController ()

@property (nonatomic, weak) IBOutlet UILabel* titleLabel;
@property (nonatomic, weak) IBOutlet UIImageView* resultBackgroundView;

@end

@implementation EWCResultViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.resultBackgroundView.image = [UIImage imageNamed:[NSString stringWithFormat:@"result_%d.png",self.result]];
    self.titleLabel.text = self.title;
}

-(void)backButtonTapped:(id)sender
{
    UIViewController* controller = nil;
    for (UIViewController* vc in self.navigationController.viewControllers) {
        if([vc isKindOfClass:[EWCCategoriesViewController class]])
        {
            controller = vc;
            break;
        }
    }
    if(nil != controller)
    {
        [self.navigationController popToViewController:controller animated:YES];
    }
    else
    {
        [super backButtonTapped:sender];
    }
}

@end
