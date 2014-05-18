//
//  ALWindowController.h
//  HttpTool
//
//  Created by Allen Zhong on 5/7/14.
//  Copyright (c) 2014 Allen Zhong. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ALRequest.h"
@interface ALWindowController : NSWindowController<NSTextDelegate,NSTextViewDelegate,NSComboBoxDataSource>


@property NSArray *headerNames;
@property NSDictionary *headerValues;

@property (weak) IBOutlet NSTextField *urlTextField;
@property (weak) IBOutlet NSComboBox *methodCombox;
@property (unsafe_unretained) IBOutlet NSTextView *resultTextView;
@property (weak) IBOutlet NSTabView *tabView;

@property (nonatomic,strong) NSArray *methodArray;

- (IBAction)makeRequest:(id)sender;
- (IBAction)addHeader:(id)sender;
- (IBAction)delHeader:(id)sender;
- (IBAction)addParameter:(id)sender;
- (IBAction)delParameter:(id)sender;



-(NSArray *)headerValuesArrayForKey:(NSString *)nameKey;
-(void) receiveNotification :(NSNotification*) aNotification;

@end
