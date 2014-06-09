//
//  ALRequest.h
//  HttpTool
//
//  Created by Allen Zhong on 5/11/14.
//  Copyright (c) 2014 Allen Zhong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALHeader.h"
@interface ALRequest : NSObject<NSURLSessionDelegate,NSURLSessionDataDelegate>

@property NSMutableURLRequest *request;
@property NSURLSessionConfiguration *sessionConfig;
@property NSURLSession *session;
@property NSURLSessionDataTask *task;
@property NSHTTPURLResponse *response;
@property NSURL *url;
@property NSError *error;
@property NSMutableArray *headers;
@property (nonatomic,strong) NSString *method;
@property (nonatomic,strong) NSDictionary *parameters;
@property (nonatomic,strong) NSString   *body;
@property (nonatomic,strong) NSMutableString *responseHtml;
@property (nonatomic,strong) NSMutableData *data;
@property (nonatomic,strong) NSDate* beginDate;
@property NSStringEncoding textEncoding;
@property NSString *textEncodingName;
-(id) initWithUrl:(NSString *)url;
-(void)beginRequest;
-(void)beginRequestWithUrlString:(NSString *)urlString;

-(NSStringEncoding)getEncodingWithCodeName:(NSString *)encodingName;

- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(NSError *)error;
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data;
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error;
@end
