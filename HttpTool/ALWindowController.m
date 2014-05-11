//
//  ALWindowController.m
//  HttpTool
//
//  Created by Allen Zhong on 5/7/14.
//  Copyright (c) 2014 Allen Zhong. All rights reserved.
//

#import "ALWindowController.h"

@interface ALWindowController ()

@end

@implementation ALWindowController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (IBAction)makeRequest:(id)sender {
    NSString *url = [self.urlTextField stringValue];
    NSLog(@"Test %@",url);
    ALRequest *request = [[ALRequest alloc]initWithUrl:url];
    [request beginRequest];
}

- (IBAction)addHeader:(id)sender {
}

- (IBAction)delHeader:(id)sender {
}

- (IBAction)addParameter:(id)sender {
}

- (IBAction)delParameter:(id)sender {
}


@end
