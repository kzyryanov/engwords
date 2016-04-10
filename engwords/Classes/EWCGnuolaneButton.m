//
//  EWCGnuolaneButton.m
//  engwords
//
//  Created by Konstantin on 15.12.13.
//
//

#import "EWCGnuolaneButton.h"

@implementation EWCGnuolaneButton

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.titleLabel.font = [UIFont fontWithName:@"Gnuolane Free Cyrillic" size:self.titleLabel.font.pointSize];
}

@end
