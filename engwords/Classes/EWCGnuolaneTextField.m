//
//  EWCGnuolaneTextField.m
//  engwords
//
//  Created by Konstantin on 22.12.13.
//
//

#import "EWCGnuolaneTextField.h"

@implementation EWCGnuolaneTextField

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.font = [UIFont fontWithName:@"Gnuolane Free Cyrillic" size:self.font.pointSize];
}

@end
