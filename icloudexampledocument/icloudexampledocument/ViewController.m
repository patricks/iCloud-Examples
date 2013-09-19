//
//  ViewController.m
//  icloudexampledocument
//
//  Created by Patrick Steiner on 03.02.13.
//  Copyright (c) 2013 Patrick Steiner. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

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
    _noteView.text = _note.content;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dataReloaded:(NSNotification *)notification
{
    _note = notification.object;
    _noteView.text = _note.content;
}

- (void)textViewDidChange:(UITextView *)textView
{
    _note.content = textView.text;
    [_note updateChangeCount:UIDocumentChangeDone];
}

@end
