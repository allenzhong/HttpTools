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
    if([@"POST" isEqualToString:self.method]){
        [self.request setHTTPBody:[self.body dataUsingEncoding:NSUTF8StringEncoding]];
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
    _beginDate = [NSDate date];
    NSURLSessionTask *task = [self.session dataTaskWithRequest:self.request];
    [task resume];
}



-(NSMutableString *)responseHtml{
    if(_responseHtml == nil){
        _responseHtml = [[NSMutableString alloc]init];
    }
    return _responseHtml;
}

-(NSString *)textEncodingName{
    if(_textEncodingName == nil){
        _textEncodingName = [[NSString alloc]init];
    }
    return _textEncodingName;
}

- (NSURLSessionConfiguration *)sessionConfig
{
    if (_sessionConfig == nil)
    {
        _sessionConfig = [NSURLSessionConfiguration ephemeralSessionConfiguration];
//        [_sessionConfig setHTTPAdditionalHeaders:@{@"Accept": @"application/json"}];
        _sessionConfig.timeoutIntervalForRequest = 60.0;
        _sessionConfig.timeoutIntervalForResource = 120.0;
        _sessionConfig.HTTPMaximumConnectionsPerHost = 1;
    }
    
    return _sessionConfig;
}


-(NSURLSession *)session{
    if (_session == nil)
    {
        _session = [NSURLSession
                    sessionWithConfiguration:self.sessionConfig
                    delegate:self
                    delegateQueue:[NSOperationQueue mainQueue]];
    }
    
    return _session;
}

-(NSMutableData *)data{
    if(_data == nil){
        _data = [[NSMutableData alloc]init];
    }
    return _data;
}


-(void)beginRequestWithUrlString:(NSString *)urlString{
    self.url = [NSURL URLWithString:urlString];
    [self beginRequest];
}


#pragma mark - Encodine Response String
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

#pragma mark - NSURLSessionDataDelegate
- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(NSError *)error{
    NSLog(@"error %@",error.description);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data{
    [self.data appendData:data];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    NSTimeInterval delta = [NSDate timeIntervalSinceReferenceDate] - [self.beginDate timeIntervalSinceReferenceDate];
    NSString *after_html;
    if(error){
        after_html = [[NSString alloc]initWithFormat:@"%@",[error localizedDescription]];
    }else{
        NSString *html = [[NSString alloc]initWithData:self.data encoding:NSASCIIStringEncoding];
        [self findEncodingNameWithHtml:html];
        NSStringEncoding encode = [self getEncodingWithCodeName:self.textEncodingName];
        after_html = [[NSString alloc]initWithData:self.data
                                          encoding:encode];
    }
    
    if(after_html){
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        NSMutableDictionary *message = [[NSMutableDictionary alloc]init];
        [message setValue:after_html forKey:@"html"];
        //        [NSDictionary dictionaryWithObject:after_html forKey:@"html"];
        [message setValue:[NSString stringWithFormat:@"%f s",delta] forKey:@"delta"];
        [center postNotificationName:@"httpResponse" object:self userInfo:message];
    }
}

@end
