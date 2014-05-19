//
//  ALWindowController.m
//  HttpTool
//
//  Created by Allen Zhong on 5/7/14.
//  Copyright (c) 2014 Allen Zhong. All rights reserved.
//

#import "ALWindowController.h"
#import "ALHeader.h"
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
        [self setupData];
    }
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(receiveNotification:) name:@"httpResponse" object:nil];
    return self;
}

-(void)setupData{
    
    self.headers = [[NSMutableArray alloc]init];
//    //    [self.headersController setContent:self.headers];
//    NSString *name = [self.headerNames objectAtIndex:0];
//    NSString *value = [[self headerValuesArrayForKey:name] objectAtIndex:0];
//    ALHeader *head = [[ALHeader alloc]init];
//    head.name = name;
//    head.value = value;
//    [self willChangeValueForKey:@"headers"];
//    [self.headers addObject:head];
//    [self didChangeValueForKey:@"headers"];
}
- (void)windowDidLoad
{
    [super windowDidLoad];
    [self.urlTextField setStringValue:@"http://www.qq.com"];
    [self.methodCombox selectItemAtIndex:0];
    [self.resultTextView setTextColor:[NSColor whiteColor]];
    [self.resultTextView setString:@""];
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.

    //    [self.headersController addObject:aDic];
//    [self willChangeValueForKey:@"headers"];
//    [self.headers addObject:aDic];
//    [self didChangeValueForKey:@"headers"];
    
}

- (IBAction)makeRequest:(id)sender {
    NSString *url = [self.urlTextField stringValue];
    NSString *method = [self.methodCombox stringValue];
    [self clearTextView];
    ALRequest *request = [[ALRequest alloc]initWithUrl:url];
    [request setMethod:method];
    [request setHeaders:self.headers];
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

-(void)clearTextView{
    if(self.resultTextView){
        [self.resultTextView setString:@""];
//        NSTextStorage *ts = [self.resultTextView textStorage];
//        [ts replaceCharactersInRange:NSMakeRange([ts length], 0) withString:@""];
//        [ts setFont:[NSFont fontWithName:@"Helvetica Neue" size:14]];
//        [self.resultTextView setTextColor:[NSColor whiteColor]];
//        [self.tabView selectTabViewItemAtIndex:1];
    }
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
#pragma mark - Request Method ComboBox datasource
- (NSInteger)numberOfItemsInComboBox:(NSComboBox *)aComboBox{
    return [_methodArray count];
}
- (id)comboBox:(NSComboBox *)aComboBox objectValueForItemAtIndex:(NSInteger)index{
    return [_methodArray objectAtIndex:index];
}
- (NSUInteger)comboBox:(NSComboBox *)aComboBox indexOfItemWithStringValue:(NSString *)string{
    return [_methodArray indexOfObject:string];
}


#pragma mark - ComboBoxCell Datasource
- (NSInteger)numberOfItemsInComboBoxCell:(NSComboBoxCell *)comboBoxCell{
    if([self.headers count]==0)
        return 0;

    NSInteger tag = comboBoxCell.tag;
    if(tag==0){
        return [self.headerNames count];
    }else{
        NSInteger selectedRow = [self.headersTableView selectedRow];
        if (selectedRow == -1) {
            selectedRow = 0;
        }
        ALHeader *selectedHeader = [self.headers objectAtIndex:selectedRow];
        NSArray *values = [self headerValuesArrayForKey:selectedHeader.name];
        if (values == nil) {
            return 1;
        }
        return [values count];
    }
}

- (id)comboBoxCell:(NSComboBoxCell *)aComboBoxCell objectValueForItemAtIndex:(NSInteger)index{
    if([self.headers count]==0)
        return nil;
    NSInteger tag = aComboBoxCell.tag;
    if(tag==0){
        return [self.headerNames objectAtIndex:index];
    }else{
        NSInteger selectedRow = [self.headersTableView selectedRow];
        if (selectedRow == -1) {
            selectedRow = 0;
        }
        
        ALHeader *selectedHeader = [self.headers objectAtIndex:selectedRow];
        NSArray *values = [self headerValuesArrayForKey:selectedHeader.name];
        if (values == nil) {
            return @"-";
        }
        return [values objectAtIndex:index];
    }
}

@end
