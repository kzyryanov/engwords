//
//  EWCAudioPlayer.m
//  engwords
//
//  Created by Konstantin on 09.12.13.
//
//

#import "EWCAudioPlayer.h"
#import <AVFoundation/AVFoundation.h>

@interface EWCAudioPlayer ()

@property (nonatomic, copy) NSString* path;
@property (nonatomic, strong) AVAudioPlayer* player;

@end

@implementation EWCAudioPlayer

+(instancetype)sharedPlayer
{
    static dispatch_once_t pred;
    static id instance;
    dispatch_once(&pred, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

-(void)playSound:(NSString *)soundPath
{
    if(0 >= soundPath.length)
    {
        return;
    }
    NSData* data = [NSData dataWithContentsOfFile:soundPath];
    if(nil != data && ![self.path isEqualToString:soundPath])
    {
        self.path = soundPath;
        NSError* error = nil;
        self.player = [[AVAudioPlayer alloc] initWithData:data error:&error];
        if(nil != error)
        {
            NSLog(@"Player error: %@", error);
        }
    }
    [self.player play];
}

@end
