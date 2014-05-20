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
    [self.request setHTTPMethod:self.method];
    [self.request setURL:self.url];
    [self.request setCachePolicy:NSURLRequestUseProtocolCachePolicy];
    [self.request setTimeoutInterval:10];
    
    if(self.headers){
        for(ALHeader *h in self.headers){
            [self.request setValue:h.value forHTTPHeaderField:h.name];
        }
    }
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

-(NSString *)findEncodingNameWithHtml:(NSString*)muStrHTMLContent{
    NSError *error;
    NSString* html = [muStrHTMLContent copy];
    
    NSString *strRegex = @"charset\\s?=\\s?\"?\'?(.\\w+-?\\w)";
//    NSRange myrange=[html rangeOfString:strRegex];
//    NSLog(@"%ld,%ld,%@",myrange.location,myrange.length,[html substringWithRange:myrange]);
    NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:strRegex options:NSRegularExpressionCaseInsensitive error:&error];
    //无视大小写.
    __block NSUInteger count = 0;
    [reg enumerateMatchesInString:html options:NSMatchingReportCompletion range:NSMakeRange(0, [html length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
        
            NSRange matchRange = [match rangeAtIndex:1];
            NSLog(@"%ld,%ld,%@",matchRange.location,matchRange.length,[html substringWithRange:matchRange]);
            if(matchRange.length>0)
                self.textEncodingName = [html substringWithRange:matchRange];
        
        if (++count >= 100) *stop = YES;
    }];
    return nil;
}
- (void)connection:(NSURLConnection *)theConnection didReceiveResponse:(NSURLResponse *)response
{
    
    NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
    NSString *textEncodingName = [(NSHTTPURLResponse *)response textEncodingName];
    self.textEncoding = [self getEncodingWithCodeName:textEncodingName];
    NSLog(@"response length=%lld  statecode %ld Encoding Name: %@", [response expectedContentLength],(long)responseCode,textEncodingName);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    NSString *html = [[NSString alloc]initWithData:data encoding:NSASCIIStringEncoding];
    [self findEncodingNameWithHtml:html];
    html = [[NSString alloc]initWithData:data encoding:[self getEncodingWithCodeName:self.textEncodingName]];
    //        NSString *errDesc = [error localizedDescription];
//    NSLog(@"Html -> %@",html);
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    NSDictionary *message = [NSDictionary dictionaryWithObject:html forKey:@"html"];
    [center postNotificationName:@"httpResponse" object:self userInfo:message];
}

- (void)connection:(NSURLConnection *)theConnection didFailWithError:(NSError *)error
{
    NSLog(@"response error%@", [error localizedFailureReason]);
}



@end
