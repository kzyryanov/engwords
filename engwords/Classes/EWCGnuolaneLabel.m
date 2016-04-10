//
//  EWCGnuolaneLabel.m
//  engwords
//
//  Created by Konstantin on 15.12.13.
//
//

#import "EWCGnuolaneLabel.h"

@implementation EWCGnuolaneLabel

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.font = [UIFont fontWithName:@"Gnuolane Free Cyrillic" size:self.font.pointSize];
}

@end
