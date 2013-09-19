//
//  ViewController.m
//  icloudexampleplist
//
//  Created by Patrick Steiner on 01.02.13.
//  Copyright (c) 2013 Patrick Steiner. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

- (void)storeDidChange:(NSNotification *)notification;

@end

@implementation ViewController

@synthesize iCloudDataLabel;
@synthesize inputDataField;

/** The only key for the datastore. */
static NSString *kDataKey = @"dataKey";

- (void)viewDidLoad
{
    [super viewDidLoad];

    iCloudDataLabel.text = @"";
    
    [self setupiCloud];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

/** Setup the iCloud connection. */
- (void)setupiCloud
{
    NSUserDefaults *currentiCloudToken = [[NSFileManager defaultManager] ubiquityIdentityToken];
    
    // check if icloud services are available on this device
    if (currentiCloudToken) {
        NSLog(@"iCloud is available: %@", currentiCloudToken);
        
        // listen do icloud key/value store changes
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(storeDidChange:)
                                                     name:NSUbiquitousKeyValueStoreDidChangeExternallyNotification
                                                   object:[NSUbiquitousKeyValueStore defaultStore]];
        
        // start the initial sync
        [[NSUbiquitousKeyValueStore defaultStore] synchronize];
        
        iCloudDataLabel.text = [[NSUbiquitousKeyValueStore defaultStore] objectForKey:kDataKey];
    } else {
        NSLog(@"No iCloud access");
        
        iCloudDataLabel.text = @"No iCloud access";
    }
}

/** Gets called if there are changes in icloud kv-store. */
- (void)storeDidChange:(NSNotification *)notification
{
    NSLog(@"KV-Store did change");
    
    NSDictionary *userInfo = [notification userInfo];
    NSNumber* reasonForChange = userInfo[NSUbiquitousKeyValueStoreChangeReasonKey];
    
    if (reasonForChange) {
        NSInteger reason = [userInfo[NSUbiquitousKeyValueStoreChangeReasonKey] integerValue];
        
        // only update if data on server changes or there is a intial sync
        if (reason == NSUbiquitousKeyValueStoreServerChange || reason == NSUbiquitousKeyValueStoreInitialSyncChange) {
            iCloudDataLabel.text = [[NSUbiquitousKeyValueStore defaultStore] objectForKey:kDataKey];
        }
    }
}

/** Change the iCloud kv-store item. */
- (void)changeDataString:(NSString *)newDataString
{
    NSString *data = [NSString stringWithFormat:@"%@ from %@", newDataString, [[UIDevice currentDevice] name]];
    
    [[NSUbiquitousKeyValueStore defaultStore] setString:data forKey:kDataKey];
    iCloudDataLabel.text = data;
}

/** Gets calles if the button is pressed.
 * @param sender The sender button.
 */
- (IBAction)storeButtonPressed:(id)sender
{    
    // store the input from the textfield into the iCloud kv-store
    [self changeDataString: inputDataField.text];
}

@end
