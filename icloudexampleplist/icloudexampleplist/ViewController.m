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

static NSString *kDataKey = @"dataKey";

- (void)viewDidLoad
{
    [super viewDidLoad];

    iCloudDataLabel.text = @"";
    
    [self setupiCloud];
}

- (void)setupiCloud
{
    NSUserDefaults *currentiCloudToken = [[NSFileManager defaultManager] ubiquityIdentityToken];
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)storeDidChange:(NSNotification *)notification {
    NSLog(@"KV-Store did change");
    
    NSDictionary *userInfo = [notification userInfo];
    NSNumber* reasonForChange = [userInfo objectForKey:NSUbiquitousKeyValueStoreChangeReasonKey];
    
    if (reasonForChange) {
        NSInteger reason = [[userInfo objectForKey:NSUbiquitousKeyValueStoreChangeReasonKey] integerValue];
        
        if (reason == NSUbiquitousKeyValueStoreServerChange || reason == NSUbiquitousKeyValueStoreInitialSyncChange) {
            iCloudDataLabel.text = [[NSUbiquitousKeyValueStore defaultStore] objectForKey:kDataKey];
        }
    }
}

- (void)changeDataString:(NSString *)newDataString
{
    NSString *data = [NSString stringWithFormat:@"%@ from %@", newDataString, [[UIDevice currentDevice] name]];
    
    [[NSUbiquitousKeyValueStore defaultStore] setString:data forKey:kDataKey];
    iCloudDataLabel.text = data;
}

- (IBAction)storeButtonPressed:(id)sender {
    [self changeDataString: inputDataField.text];
}

@end
