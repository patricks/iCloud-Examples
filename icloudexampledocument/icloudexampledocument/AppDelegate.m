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

/** setup the iCloud connection and start querying for new data. */
- (void)loadNote
{
    // create now query object
    NSMetadataQuery *newQuery = [[NSMetadataQuery alloc] init];
    _query = newQuery;
    
    // set the search scope for the object
    [newQuery setSearchScopes:@[NSMetadataQueryUbiquitousDocumentsScope]];
    
    // set the predefined filename
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", NSMetadataItemFSNameKey, kFilename];
    [newQuery setPredicate:predicate];
    
    // register app for system notifications of the type NSMetadataQueryDidFinishGatheringNotification
    // and call queryDidFinishGathering: if such a notification arrives
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(queryDidFinishGathering:)
                                                 name:NSMetadataQueryDidFinishGatheringNotification
                                               object:newQuery];
    
    // start the query
    [newQuery startQuery];
}

/** gets called if a query finishes */
- (void)queryDidFinishGathering:(NSNotification *)notification
{
    // disable and stop query
    NSMetadataQuery *newQuery = [notification object];
    [newQuery disableUpdates];
    [newQuery stopQuery];
    
    // do not listen to system notifications anymore
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSMetadataQueryDidFinishGatheringNotification
                                                  object:newQuery];
    
    _query = nil;

    // load the new data
    [self loadData:newQuery];
}

/** load queried data into a note object */
- (void)loadData:(NSMetadataQuery *)newQuery
{
    // if query found a document, load it.
    if ([newQuery resultCount] == 1) {
        // get url from the queried document and set it to the new note
        NSMetadataItem *item = [newQuery resultAtIndex:0];
        NSURL *url = [item valueForAttribute:NSMetadataItemURLKey];
        Note *newNote = [[Note alloc] initWithFileURL:url];
        _note = newNote;
        
        // open the the document using block syntax
        [_note openWithCompletionHandler:^(BOOL success){
            if (success) {
                NSLog(@"iCloud note opened");
            } else {
                NSLog(@"Failed to open iCloud note");
            }
        }];
    } else { // query didn´t find a note, so create a new one.
        // create a url for the new file. store it into the Documents folder and use the predefined filename
        NSURL *ubiq = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
        NSURL *ubiquitousPackage = [[ubiq URLByAppendingPathComponent:@"Documents"] URLByAppendingPathComponent:kFilename];
        
        // create a new note with the url created above
        Note *newNote = [[Note alloc] initWithFileURL:ubiquitousPackage];
        _note = newNote;
        
        // save the note into iCloud using block syntax
        [newNote saveToURL:[newNote fileURL] forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
            if (success) {
                [newNote openWithCompletionHandler:^(BOOL success) {
                    NSLog(@"New note opened from iCloud");
                }];
            }
        }];
    }
}

@end
