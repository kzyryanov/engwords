//
//  EWCAudioPlayer.h
//  engwords
//
//  Created by Konstantin on 09.12.13.
//
//

#import <Foundation/Foundation.h>

@interface EWCAudioPlayer : NSObject

+(instancetype)sharedPlayer;

-(void)playSound:(NSString*)soundPath;

@end
