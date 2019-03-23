//
//  FetchDetail.m
//  tools
//
//  Created by 王旭 on 2019/3/23.
//  Copyright © 2019 王旭. All rights reserved.
//

#import "FetchDetail.h"
#import "OCGumbo.h"
#import "OCGumbo+Query.h"

@implementation FetchDetail

+ (void)fetchData: (NSString *)path Block:(FetchDetailBlock)block {
    NSMutableArray *array = [NSMutableArray new];
    [self fetchList:path Block:block Result:array];
}

+ (void)fetchList: (NSString *)path Block:(FetchDetailBlock)block Result: (NSMutableArray *)result {
    NSString *urlString = [path stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20];
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask * dataTask =  [session dataTaskWithRequest:request completionHandler:^(NSData * __nullable data, NSURLResponse * __nullable response, NSError * __nullable error) {
        [self dealData:data Block:block Result:result Path:(NSString *)path];
    }];
    [dataTask resume];
}

+ (void)dealData: (NSData *)data Block:(FetchDetailBlock)block Result: (NSMutableArray *)result Path:(NSString *)path {
    NSStringEncoding gbkEncodeing = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *htmlString = [[NSString alloc]initWithData:data encoding:gbkEncodeing];
    
    if (!htmlString || [htmlString isEqualToString:@""]) {
        return;
    }
    OCGumboDocument *document = [[OCGumboDocument alloc] initWithHTMLString:htmlString];
    OCGumboNode *p = document.Query(@"#picBody").find(@"p").first();
    OCGumboNode *a = p.Query(@"a").first();
    OCGumboNode *img = p.Query(@"img").first();
    
    if (img) {
        NSString *src = img.attr(@"src");
        [result addObject:src];
    }
    
    if (a) {
        NSString *href = a.attr(@"href");
        
        NSString *url = [NSString stringWithString:path];
        NSMutableArray *urlItems = [NSMutableArray arrayWithArray:[url componentsSeparatedByString:@"/"]];
        urlItems[[urlItems count] - 1] = href;
        NSString *nextPath = [urlItems componentsJoinedByString:@"/"];
        [self fetchList:nextPath Block:block Result:result];
    } else {
        block(result);
    }
}

@end
