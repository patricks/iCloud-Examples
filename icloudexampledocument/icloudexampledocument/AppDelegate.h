//
//  AppDelegate.h
//  icloudexampledocument
//
//  Created by Patrick Steiner on 03.02.13.
//  Copyright (c) 2013 Patrick Steiner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Note.h"

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ViewController *viewController;

@property (strong) Note *note;
@property NSMetadataQuery *query;

- (void)loadNote;

@end
