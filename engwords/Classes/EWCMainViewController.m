//
//  EWCViewController.m
//  engwords
//
//  Created by Konstantin on 23.11.13.
//
//

#import "EWCMainViewController.h"
#import "EWCModel.h"

@interface EWCMainViewController ()

@end

@implementation EWCMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[EWCModel sharedModel] dictionaries];
}

@end
