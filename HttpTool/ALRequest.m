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
        self.url = [NSURL URLWithString:url];
        self.method = @"GET";
        self.request = [NSMutableURLRequest requestWithURL:self.url];
    }
    return self;
}


-(void)beginRequest{
    [self.request setURL:self.url];
    [self.request setCachePolicy:NSURLRequestUseProtocolCachePolicy];
    [self.request setTimeoutInterval:10];
    
    [NSURLConnection connectionWithRequest:self.request delegate:self];
}

-(void)beginRequestWithUrlString:(NSString *)urlString{
    self.url = [NSURL URLWithString:urlString];
    [self beginRequest];
    
}

- (void)connection:(NSURLConnection *)theConnection didReceiveResponse:(NSURLResponse *)response
{
    NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
    NSLog(@"response length=%lld  statecode %ld", [response expectedContentLength],(long)responseCode);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    NSString *html = [[NSString alloc]initWithData:data encoding:NSASCIIStringEncoding];
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
