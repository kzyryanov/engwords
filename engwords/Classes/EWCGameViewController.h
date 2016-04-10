//
//  EWCGameViewController.h
//  engwords
//
//  Created by Konstantin on 08.12.13.
//
//

#import <UIKit/UIKit.h>

typedef enum
{
    EWCGameTypeLearn,
    EWCGameTypeDictation,
    EWCGameTypeWrite,
    EWCGameTypeTest
} EWCGameType;

@interface EWCGameViewController : UIViewController

@property (nonatomic, assign) EWCGameType gameType;
@property (nonatomic, strong) NSArray* words;

@end
