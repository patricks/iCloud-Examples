//
//  ViewController.m
//  icloudexampledocument
//
//  Created by Patrick Steiner on 03.02.13.
//  Copyright (c) 2013 Patrick Steiner. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize note;
@synthesize noteView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dataReloaded:)
                                                 name:@"noteMotified"
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    noteView.text = note.content;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dataReloaded:(NSNotification *)notification
{
    note = notification.object;
    noteView.text = note.content;
}

- (void)textViewDidChange:(UITextView *)textView
{
    note.content = textView.text;
    [note updateChangeCount:UIDocumentChangeDone];
}

@end
