//
//  PlistDataStore.m
//  icloudexampleplist
//
//  Created by Patrick Steiner on 01.02.13.
//  Copyright (c) 2013 Patrick Steiner. All rights reserved.
//

#import "PlistDataStore.h"

#define kDataKey @"dataKey"

@interface PlistDataStore ()
{
    NSURL *myUbiquityContainer;
}

- (void)storeDidChange:(NSNotification *)notification;

@end

@implementation PlistDataStore

- (id)init
{
    self = [super init];
    if (self) {
        [self setupiCloudAccess];
    }
    return self;
}

#pragma -
#pragma setup

- (void)setupiCloudAccess
{
    NSLog(@"Setup iCloud access");
    /// check if iCloud is available on this device
    NSUserDefaults *currentiCloudToken = [[NSFileManager defaultManager] ubiquityIdentityToken];
    
    if (currentiCloudToken) {
        NSLog(@"iCloud is available: %@", currentiCloudToken);
        
        //NSData *newTokenData = [NSKeyedArchiver archivedDataWithRootObject:currentiCloudToken];
        
        // save the data token
        //[[NSUserDefaults standardUserDefaults] setObject:newTokenData forKey:@"at.fhooe.mc.steiner.icloudexampleplist.UbiquityIdentityToken"];
    } else {
        NSLog(@"No iCloud access");
        
        // remove data token
        //[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"at.fhooe.mc.steiner.icloudexampleplist.UbiquityIdentityToken"];
    }
    
    // sync key/value store
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(storeDidChange:)
                                                 name:NSUbiquitousKeyValueStoreDidChangeExternallyNotification
                                               object:[NSUbiquitousKeyValueStore defaultStore]];
    
    // sync the store
    [[NSUbiquitousKeyValueStore defaultStore] synchronize];
}

#pragma -
#pragma notification handling

- (void)iCloudAccountAvailabilityChanged
{
    NSLog(@"DBG: iCloud account availability changed");
}

- (void)storeDidChange:(NSNotification *)notification
{
    NSLog(@"DBG: iCloud keyvalue-store data changed externally to:");
}


#pragma -
#pragma read / write

- (void)writeStringToStore:(NSString *)string
{
    [[NSUbiquitousKeyValueStore defaultStore] setString:string forKey:kDataKey];
}

- (NSString *)readStringFromStore
{
    return [[NSUbiquitousKeyValueStore defaultStore] valueForKey:kDataKey];
}

@end
