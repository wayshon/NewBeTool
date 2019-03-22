//
//  Fetch.m
//  tools
//
//  Created by jike1 on 2019/3/21.
//  Copyright © 2019 王旭. All rights reserved.
//

#import "Fetch.h"
#import "OCGumbo.h"
#import "OCGumbo+Query.h"

static Fetch *singInstance = nil;

@implementation Fetch

+ (instancetype)sharedFetch {
    @synchronized(self){
        static dispatch_once_t predicate;
        dispatch_once(&predicate, ^{
            singInstance = [[[self class] alloc] init];
        });
    }
    
    return singInstance;
}

+ (id)allocWithZone:(NSZone *)zone{
    if (singInstance == nil) {
        
        singInstance = [super allocWithZone:zone];
        
    }
    return singInstance;
}

- (id)copyWithZone:(NSZone *)zone{
    return singInstance;
}

- (instancetype)init
{
    self = [super init];
    if ( self ) {
        self.list = [NSArray new];
        [self getData];
    }
    return self;
}

- (void)getData {
    NSString *urlString = @"https://www.2717.com/ent/meinvtupian/";
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask * dataTask =  [session dataTaskWithRequest:request completionHandler:^(NSData * __nullable data, NSURLResponse * __nullable response, NSError * __nullable error) {
        [self dealData:data];
    }];
    [dataTask resume];
}

- (void)dealData: (NSData *)data {
//    NSString *htmlString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSStringEncoding gbkEncodeing = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *htmlString = [[NSString alloc]initWithData:data encoding:gbkEncodeing];

    if (!htmlString || [htmlString isEqualToString:@""]) {
        return;
    }
    OCGumboDocument *document = [[OCGumboDocument alloc] initWithHTMLString:htmlString];
    NSArray *array = document.Query(@".MeinvTuPianBox").find(@"img");
    
    if ([array count] > 0) {
        NSMutableArray *mutableList = [NSMutableArray new];
        [array enumerateObjectsUsingBlock:^(OCGumboElement *ele, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *src = ele.attr(@"src");
            if (src && ![src isEqualToString:@""]) {
                [mutableList addObject:src];
            }
        }];
        if ([mutableList count] > 0) {
            self.list = [NSArray arrayWithArray:mutableList];
            if (_block) {
                _block(_list);
            }
        }
    }
    
}

@end
