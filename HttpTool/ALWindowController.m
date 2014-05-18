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

-(id)initWithWindowNibName:(NSString *)windowNibName{
    self = [super initWithWindowNibName:windowNibName];
    if (self) {
        // Initialization code here.
        _methodArray = [[NSArray alloc]initWithObjects:@"GET",@"POST",@"HEAD",@"PUT",@"DELETE", nil];
        NSString *filePath = [[NSBundle mainBundle]pathForResource:@"HeaderNames" ofType:@"plist"];
        self.headerNames = [NSArray arrayWithContentsOfFile:filePath];
        filePath = [[NSBundle mainBundle]pathForResource:@"HeaderValues" ofType:@"plist"];
        self.headerValues = [NSDictionary dictionaryWithContentsOfFile:filePath];
    }
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(receiveNotification:) name:@"httpResponse" object:nil];
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    [self.urlTextField setStringValue:@"http://www.qq.com"];
    self.methodCombox.dataSource = self;
    [self.methodCombox selectItemAtIndex:0];
    [self.resultTextView setTextColor:[NSColor whiteColor]];
    [self.resultTextView setString:@""];
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (IBAction)makeRequest:(id)sender {
    NSString *url = [self.urlTextField stringValue];
    NSString *method = [self.methodCombox stringValue];
    
    ALRequest *request = [[ALRequest alloc]initWithUrl:url];
    [request setMethod:method];
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

-(NSArray *)headerValuesArrayForKey:(NSString *)nameKey{
    NSString* key = [nameKey lowercaseString];
    return [self.headerValues objectForKey:key];
}

-(void) receiveNotification :(NSNotification*)aNotification{
    NSString *data = [[aNotification userInfo] objectForKey:@"html"];
    if(self.resultTextView){
        NSTextStorage *ts = [self.resultTextView textStorage];
        [ts replaceCharactersInRange:NSMakeRange([ts length], 0) withString:data];
        [ts setFont:[NSFont fontWithName:@"Helvetica Neue" size:14]];
        [self.resultTextView setTextColor:[NSColor whiteColor]];
        [self.tabView selectTabViewItemAtIndex:1];
    }
}
#pragma mark - ComboBox datasource
- (NSInteger)numberOfItemsInComboBox:(NSComboBox *)aComboBox{
    return [_methodArray count];
}
- (id)comboBox:(NSComboBox *)aComboBox objectValueForItemAtIndex:(NSInteger)index{
    return [_methodArray objectAtIndex:index];
}
- (NSUInteger)comboBox:(NSComboBox *)aComboBox indexOfItemWithStringValue:(NSString *)string{
    return [_methodArray indexOfObject:string];
}

@end
