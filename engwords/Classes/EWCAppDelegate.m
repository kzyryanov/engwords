//
//  EWCAppDelegate.m
//  engwords
//
//  Created by Konstantin on 23.11.13.
//
//

#import "EWCAppDelegate.h"
#import "EWCModel.h"
#import <CoreData+MagicalRecord.h>
#import "MagicalRecord+Options.h"
#import <Appirater/Appirater.h>

@interface EWCAppDelegate ()<AppiraterDelegate>

@property (nonatomic, strong, readonly) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, strong, readonly) NSManagedObjectModel* managedObjectModel;
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator* persistentStoreCoordinator;

-(void)saveContext;
-(NSURL*)applicationDocumentsDirectory;

@end

@implementation EWCAppDelegate
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    UIPasteboard* pasteboard = [UIPasteboard pasteboardWithName:@"com.nemotelecom.common" create:NO];
    pasteboard.persistent = YES;
    NSData* data = [pasteboard valueForPasteboardType:@"com.nemotelecom.common.uuid"];
    NSString* str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@", str);
    
    [MagicalRecord setupCoreDataStackWithStoreNamed:@"model.sqlite"];
    [[EWCModel sharedModel] dictionaries];
    
    [Appirater setAppId:@"782466894"];    // Change for your "Your APP ID"
    [Appirater setDaysUntilPrompt:0];     // Days from first entered the app until prompt
    [Appirater setUsesUntilPrompt:5];     // Number of uses until prompt
    [Appirater setTimeBeforeReminding:2]; // Days until reminding if the user taps "remind me"
//    [Appirater setDebug:YES];           // If you set this to YES it will display all the time
    [Appirater setDelegate:self];
    [Appirater appLaunched:YES];
    
    return YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application{
    [Appirater appEnteredForeground:YES];
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [self saveContext];
    [MagicalRecord cleanUp];
}

#pragma mark - Appirater

-(void)appiraterDidOptToRate:(Appirater *)appirater
{
    [[NSUserDefaults standardUserDefaults] setValue:@(EWCRateNumber) forKey:kEWCRateAppNumber];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)appiraterDidOptToRemindLater:(Appirater *)appirater
{
    [[NSUserDefaults standardUserDefaults] setValue:@(0) forKey:kEWCRateAppNumber];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)appiraterDidDeclineToRate:(Appirater *)appirater
{
    [[NSUserDefaults standardUserDefaults] setValue:@(-1) forKey:kEWCRateAppNumber];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Core Data stack

-(NSManagedObjectContext *)managedObjectContext
{
    if(nil != _managedObjectContext)
    {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator* coordinator = [self persistentStoreCoordinator];
    if(nil != coordinator)
    {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

-(NSManagedObjectModel *)managedObjectModel
{
    if(nil != _managedObjectModel)
    {
        return _managedObjectModel;
    }
    
    NSURL* modelURL = [[NSBundle mainBundle] URLForResource:@"model" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

-(NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if(nil != _persistentStoreCoordinator)
    {
        return _persistentStoreCoordinator;
    }
    
    NSURL* storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"model.sqlite"];
    NSError* error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    if(![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        NSLog(@"Unresolved error: %@, %@", [error description], [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

-(NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

-(void)saveContext
{
    NSError* error = nil;
    NSManagedObjectContext* context = [self managedObjectContext];
    if(nil != context)
    {
        if([context hasChanges] && ![context save:&error])
        {
            NSLog(@"Unresolved error: %@, %@", [error description], [error userInfo]);
            abort();
        }
    }
}

@end
