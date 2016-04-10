//
//  EWCAboutViewController.m
//  engwords
//
//  Created by Konstantin on 23.01.14.
//
//

#import "EWCAboutViewController.h"

@interface EWCAboutViewController ()

-(IBAction)showAbout:(id)sender;

@end

@implementation EWCAboutViewController

-(void)showAbout:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.engwords.net"]];
}

@end
