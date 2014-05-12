//
//  ALWindowController.h
//  HttpTool
//
//  Created by Allen Zhong on 5/7/14.
//  Copyright (c) 2014 Allen Zhong. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ALRequest.h"
@interface ALWindowController : NSWindowController<NSTextDelegate,NSTextViewDelegate>


@property (weak) IBOutlet NSTextField *urlTextField;
@property (weak) IBOutlet NSComboBox *methodCombox;
@property (unsafe_unretained) IBOutlet NSTextView *resultTextView;


- (IBAction)makeRequest:(id)sender;
- (IBAction)addHeader:(id)sender;
- (IBAction)delHeader:(id)sender;
- (IBAction)addParameter:(id)sender;
- (IBAction)delParameter:(id)sender;

-(void) receiveNotification :(NSNotification*)aNotification;

@end
