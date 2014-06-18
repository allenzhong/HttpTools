//
//  ALAppDelegate.m
//  HttpTool
//
//  Created by Allen Zhong on 5/7/14.
//  Copyright (c) 2014 Allen Zhong. All rights reserved.
//

#import "ALAppDelegate.h"

@implementation ALAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    if(mainWindowController == nil){
        mainWindowController = [[ALWindowController alloc]initWithWindowNibName:@"ALWindowController"];
    }
    [mainWindowController showWindow:self];
}

- (IBAction)newWindow:(id)sender {
    mainWindowController = [[ALWindowController alloc]initWithWindowNibName:@"ALWindowController"];
    [mainWindowController showWindow:nil];
}
@end
