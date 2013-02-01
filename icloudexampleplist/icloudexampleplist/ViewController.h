//
//  ViewController.h
//  icloudexampleplist
//
//  Created by Patrick Steiner on 01.02.13.
//  Copyright (c) 2013 Patrick Steiner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *iCloudDataLabel;
@property (weak, nonatomic) IBOutlet UITextField *inputDataField;

- (IBAction)storeButtonPressed:(id)sender;

@end
