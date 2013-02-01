//
//  PlistDataStore.h
//  icloudexampleplist
//
//  Created by Patrick Steiner on 01.02.13.
//  Copyright (c) 2013 Patrick Steiner. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlistDataStore : NSObject

- (void)writeStringToStore:(NSString *)string;
- (NSString *)readStringFromStore;

@end
