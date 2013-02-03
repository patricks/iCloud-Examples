//
//  AppDelegate.m
//  icloudexampledocument
//
//  Created by Patrick Steiner on 03.02.13.
//  Copyright (c) 2013 Patrick Steiner. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"

// The default filename for the note
#define kFilename @"mynote.note"

@implementation AppDelegate

@synthesize note;
@synthesize query;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.viewController = [[ViewController alloc] initWithNibName:@"ViewController_iPhone" bundle:nil];
    } else {
        self.viewController = [[ViewController alloc] initWithNibName:@"ViewController_iPad" bundle:nil];
    }
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
    
    // check if iCloud is available
    NSUserDefaults *currentiCloudToken = [[NSFileManager defaultManager] ubiquityIdentityToken];
    
    // check if icloud services are available on this device
    if (currentiCloudToken) {
        NSLog(@"iCloud is available: %@", currentiCloudToken);
        
        // load the note
        [self loadNote];
    } else {
        NSLog(@"No iCloud access");
    }
    
    return YES;
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

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)loadNote
{
    NSMetadataQuery *newQuery = [[NSMetadataQuery alloc] init];
    query = newQuery;
    [newQuery setSearchScopes:[NSArray arrayWithObject:NSMetadataQueryUbiquitousDocumentsScope]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", NSMetadataItemFSNameKey, kFilename];
    [newQuery setPredicate:predicate];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(queryDidFinishGathering:)
                                                 name:NSMetadataQueryDidFinishGatheringNotification
                                               object:newQuery];
    [newQuery startQuery];
}

- (void)queryDidFinishGathering:(NSNotification *)notification
{
    NSMetadataQuery *newQuery = [notification object];
    [newQuery disableUpdates];
    [newQuery stopQuery];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSMetadataQueryDidFinishGatheringNotification
                                                  object:newQuery];
    
    query = nil;
    
    [self loadData:newQuery];
}

- (void)loadData:(NSMetadataQuery *)newQuery
{
    if ([newQuery resultCount] == 1) {
        NSMetadataItem *item = [newQuery resultAtIndex:0];
        NSURL *url = [item valueForAttribute:NSMetadataItemURLKey];
        Note *newNote = [[Note alloc] initWithFileURL:url];
        note = newNote;
        
        [note openWithCompletionHandler:^(BOOL success){
            if (success) {
                NSLog(@"iCloud note opened");
            } else {
                NSLog(@"Failed to open iCloud note");
            }
        }];
    } else { // add a new sample document
        NSURL *ubiq = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
        NSURL *ubiquitousPackage = [[ubiq URLByAppendingPathComponent:@"Documents"] URLByAppendingPathComponent:kFilename];
        
        Note *newNote = [[Note alloc] initWithFileURL:ubiquitousPackage];
        note = newNote;
        
        [newNote saveToURL:[newNote fileURL] forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
            if (success) {
                [newNote openWithCompletionHandler:^(BOOL success) {
                    NSLog(@"New Note opened from iCloud");
                }];
            }
        }];
    }
}


@end
