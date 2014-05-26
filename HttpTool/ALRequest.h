//
//  ALRequest.h
//  HttpTool
//
//  Created by Allen Zhong on 5/11/14.
//  Copyright (c) 2014 Allen Zhong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALHeader.h"
@interface ALRequest : NSObject<NSURLConnectionDelegate,NSURLConnectionDataDelegate>

@property NSMutableURLRequest *request;
@property NSHTTPURLResponse *response;
@property NSURL *url;
@property NSError *error;
@property NSMutableArray *headers;
@property (nonatomic,strong) NSString *method;
//@property (nonatomic,strong) NSDictionary *header;
@property (nonatomic,strong) NSDictionary *parameters;
@property (nonatomic,strong) NSMutableString *responseHtml;
@property (nonatomic,strong) NSMutableData *data;
@property NSStringEncoding textEncoding;
@property NSString *textEncodingName;
-(id) initWithUrl:(NSString *)url;
-(void)beginRequest;
-(void)beginRequestWithUrlString:(NSString *)urlString;

-(NSStringEncoding)getEncodingWithCodeName:(NSString *)encodingName;
//-(void)beginRequestWithUrl:(NSURL *)url;
//-(void)beginRequestWithUrlString:(NSString *)urlString;
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;

@end
