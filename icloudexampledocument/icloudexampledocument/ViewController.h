//
//  ViewController.h
//  icloudexampledocument
//
//  Created by Patrick Steiner on 03.02.13.
//  Copyright (c) 2013 Patrick Steiner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Note.h"

@interface ViewController : UIViewController <UITextViewDelegate>

@property (strong) Note *note;
@property (weak) IBOutlet UITextView *noteView;

@end
