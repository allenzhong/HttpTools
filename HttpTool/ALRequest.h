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

@property (nonatomic,strong) NSMutableURLRequest *request;
@property (nonatomic,strong) NSURLSessionConfiguration *sessionConfig;
@property (nonatomic,strong) NSURLSession *session;
@property (nonatomic,strong) NSURLSessionDataTask *task;
@property (nonatomic,strong) NSHTTPURLResponse *response;
@property (nonatomic,strong) NSURL *url;
@property (nonatomic,strong) NSError *error;
@property (nonatomic,strong) NSMutableArray *headers;
@property (nonatomic,strong) NSString *method;
@property (nonatomic,strong) NSDictionary *parameters;
@property (nonatomic,strong) NSString   *body;
@property (nonatomic,strong) NSMutableString *responseHtml;
@property (nonatomic,strong) NSMutableData *data;
@property (nonatomic,strong) NSDate* beginDate;
@property NSStringEncoding textEncoding;
@property (nonatomic,strong) NSString *textEncodingName;
-(id) initWithUrl:(NSString *)url;
-(void)beginRequest;
-(void)beginRequestWithUrlString:(NSString *)urlString;

-(NSStringEncoding)getEncodingWithCodeName:(NSString *)encodingName;

- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(NSError *)error;
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data;
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error;
@end
