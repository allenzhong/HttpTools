//
//  ALWindowController.h
//  HttpTool
//
//  Created by Allen Zhong on 5/7/14.
//  Copyright (c) 2014 Allen Zhong. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ALRequest.h"
@interface ALWindowController : NSWindowController<NSComboBoxCellDataSource>

@property NSMutableArray *headers;
@property NSArray *headerNames;
@property NSDictionary *headerValues;

@property (weak) IBOutlet NSTextField *urlTextField;
@property (weak) IBOutlet NSComboBox *methodCombox;
@property NSTextView *resultTextView;
@property (weak) IBOutlet NSTabView *tabView;
@property (strong) IBOutlet NSArrayController *headersController;
@property (weak) IBOutlet NSTableView *headersTableView;
@property (weak) IBOutlet NSProgressIndicator *progressIndicator;
@property (weak) IBOutlet NSTextField *timeInterval;
@property (weak) IBOutlet NSTextField *bodyTextField;
@property (weak) IBOutlet NSScrollView *bodyScrollView;
@property (weak) IBOutlet NSScrollView *resultScrollView;

@property (nonatomic,strong) NSArray *methodArray;

- (IBAction)makeRequest:(id)sender;
- (IBAction)addHeader:(id)sender;
- (IBAction)delHeader:(id)sender;
- (IBAction)addParameter:(id)sender;
- (IBAction)delParameter:(id)sender;


-(void)clearTextView;
-(NSArray *)headerValuesArrayForKey:(NSString *)nameKey;
-(void) receiveNotification :(NSNotification*) aNotification;
-(void)setupData;
@end
