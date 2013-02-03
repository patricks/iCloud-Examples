//
//  Note.m
//  icloudexampledocument
//
//  Created by Patrick Steiner on 03.02.13.
//  Copyright (c) 2013 Patrick Steiner. All rights reserved.
//

#import "Note.h"

@implementation Note

@synthesize content;

/**
 * Called if the app reads the data:
 */
- (BOOL)loadFromContents:(id)contents ofType:(NSString *)typeName error:(NSError *__autoreleasing *)outError
{
    if ([contents length] > 0) {
        content = [[NSString alloc] initWithBytes:[contents bytes]
                                           length:[contents length]
                                         encoding:NSUTF8StringEncoding];
    } else {
        // note is created, fill content
        content = @"Empty";
    }
    
    return YES;
}

/**
 * Called if the app saves the data.
 */
- (id)contentsForType:(NSString *)typeName error:(NSError *__autoreleasing *)outError
{
    if ([content length] <= 0) {
        self.content = @"Empty";
    }
    
    return [NSData dataWithBytes:[content UTF8String] length:[content length]];
}

@end
