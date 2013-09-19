//
//  Note.m
//  icloudexampledocument
//
//  Created by Patrick Steiner on 03.02.13.
//  Copyright (c) 2013 Patrick Steiner. All rights reserved.
//

#import "Note.h"

@implementation Note

/**
 * Called if the app reads the data:
 */
- (BOOL)loadFromContents:(id)contents ofType:(NSString *)typeName error:(NSError *__autoreleasing *)outError
{
    if ([contents length] > 0) {
        _content = [[NSString alloc] initWithBytes:[contents bytes]
                                           length:[contents length]
                                         encoding:NSUTF8StringEncoding];
    } else {
        // note is created, fill content
        _content = @"Empty";
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"noteMotified" object:self];
    
    return YES;
}

/**
 * Called if the app saves the data.
 */
- (id)contentsForType:(NSString *)typeName error:(NSError *__autoreleasing *)outError
{
    if ([_content length] <= 0) {
        _content = @"Empty";
    }
    
    return [NSData dataWithBytes:[_content UTF8String] length:[_content length]];
}

@end
