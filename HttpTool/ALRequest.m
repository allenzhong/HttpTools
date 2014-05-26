//
//  ALRequest.m
//  HttpTool
//
//  Created by Allen Zhong on 5/11/14.
//  Copyright (c) 2014 Allen Zhong. All rights reserved.
//

#import "ALRequest.h"

@implementation ALRequest

-(id) initWithUrl:(NSString *)url{
    if(self=[super init]){
        self.url = [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        self.method = @"GET";
        self.request = [NSMutableURLRequest requestWithURL:self.url];
    }
    return self;
}


-(void)beginRequest{
    self.beginDate = [[NSDate alloc]init];
    NSLog(@"%@",self.beginDate);
    if([@"POST" isEqualToString:self.method]){
        [self.request setHTTPBody:[self.body dataUsingEncoding:0]];
    }
    
    [self.request setHTTPMethod:self.method];
    [self.request setURL:self.url];
    [self.request setCachePolicy:NSURLRequestUseProtocolCachePolicy];
    [self.request setTimeoutInterval:10];
    
    if(self.headers){
        for(ALHeader *h in self.headers){
            [self.request setValue:h.value forHTTPHeaderField:h.name];
        }
    }
    self.responseHtml = [[NSMutableString alloc]init];
    self.textEncodingName = [[NSString alloc]init];
    self.data = [[NSMutableData alloc]init];
    [NSURLConnection connectionWithRequest:self.request delegate:self];
}


-(void)beginRequestWithUrlString:(NSString *)urlString{
    self.url = [NSURL URLWithString:urlString];
    [self beginRequest];
}


-(NSStringEncoding)getEncodingWithCodeName:(NSString *)encodingName{
    
    NSStringEncoding result;
    if([@"gb2312" isEqualToString:[encodingName lowercaseString]]){
        result = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    }
    else if([@"gbk" isEqualToString:[encodingName lowercaseString]]){
        result = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    }
    else if([@"utf-8" isEqualToString:[encodingName lowercaseString]]){
        result =  NSUTF8StringEncoding;
    }
    else{
        result =  NSASCIIStringEncoding;
    }
    
    return result;
}

-(void)findEncodingNameWithHtml:(NSString*)muStrHTMLContent{
    if (![self.textEncodingName isEqualToString:@""]) {
        return;
    }
    NSError *error;
    NSString* html = [muStrHTMLContent copy];
    
    NSString *strRegex = @"charset\\s?=\\s?\"?\'?(.\\w+-?\\w)";
    NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:strRegex options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *array = [reg matchesInString:html options:NSMatchingWithoutAnchoringBounds range:NSMakeRange(0, [html length])];

    for(NSTextCheckingResult *result in array){
        NSRange matchRange = [result rangeAtIndex:1];
        if(matchRange.length >0){
            NSLog(@"%ld,%ld,%@",matchRange.location,matchRange.length,[html substringWithRange:matchRange]);
            self.textEncodingName = [html substringWithRange:matchRange];
            break;
        }
    }
}

#pragma mark - NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)theConnection didReceiveResponse:(NSURLResponse *)response
{
    
    NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
    NSString *textEncodingName = [(NSHTTPURLResponse *)response textEncodingName];
    self.textEncoding = [self getEncodingWithCodeName:textEncodingName];
    NSLog(@"response length=%lld  statecode %ld Encoding Name: %@", [response expectedContentLength],(long)responseCode,textEncodingName);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [self.data appendData:data];

}

- (void)connection:(NSURLConnection *)theConnection didFailWithError:(NSError *)error
{
    NSLog(@"response error%@", [error localizedFailureReason]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSLog(@"Finished");
    NSDate *now = [[NSDate alloc]init];
    NSTimeInterval it = [now timeIntervalSinceDate:self.beginDate];
    
    NSLog(@"Time interval %f",it);
    NSString *html = [[NSString alloc]initWithData:self.data
                                          encoding:NSASCIIStringEncoding];
    [self findEncodingNameWithHtml:html];
    NSStringEncoding encode = [self getEncodingWithCodeName:self.textEncodingName];
    NSString *after_html = [[NSString alloc]initWithData:self.data
                                                encoding:encode];
    if(after_html){
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        NSMutableDictionary *message = [[NSMutableDictionary alloc]init];
        [message setValue:after_html forKey:@"html"];
//        [NSDictionary dictionaryWithObject:after_html forKey:@"html"];
        [message setValue:[NSString stringWithFormat:@"%f s",it] forKey:@"delta"];
        [center postNotificationName:@"httpResponse" object:self userInfo:message];
    }

}

@end
