//
//  ALRequest.h
//  HttpTool
//
//  Created by Allen Zhong on 5/11/14.
//  Copyright (c) 2014 Allen Zhong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ALRequest : NSObject

@property NSMutableURLRequest *request;
@property NSHTTPURLResponse *response;
@property NSURL *url;
@property NSError *error;

@property (nonatomic,strong) NSString *method;
@property (nonatomic,strong) NSDictionary *header;
@property (nonatomic,strong) NSDictionary *parameters;
@property (nonatomic,strong) NSString *responseHtml;

@end
