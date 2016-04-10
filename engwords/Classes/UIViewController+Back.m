//
//  UIViewController+Back.m
//  engwords
//
//  Created by Konstantin on 15.12.13.
//
//

#import "UIViewController+Back.h"

@implementation UIViewController (Back)

-(void)backButtonTapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
