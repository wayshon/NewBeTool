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
    [self fetchList:path Block:block];
}

+ (void)fetchList: (NSString *)path Block:(FetchDetailBlock)block {
    NSString *urlString = [path stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20];
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask * dataTask =  [session dataTaskWithRequest:request completionHandler:^(NSData * __nullable data, NSURLResponse * __nullable response, NSError * __nullable error) {
        [self dealData:data Block:block];
    }];
    [dataTask resume];
}

+ (void)dealData: (NSData *)data Block:(FetchDetailBlock)block {
    NSStringEncoding gbkEncodeing = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *htmlString = [[NSString alloc]initWithData:data encoding:gbkEncodeing];
    
    if (!htmlString || [htmlString isEqualToString:@""]) {
        return;
    }
    
    OCGumboDocument *document = [[OCGumboDocument alloc] initWithHTMLString:htmlString];
    OCGumboNode *p = document.Query(@"#picBody").find(@"p").first();
    OCGumboNode *img = p.Query(@"img").first();
    NSString *src = img.attr(@"src");
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:[src componentsSeparatedByString:@"/"]];
    [tempArray removeLastObject];
    NSString *baseSrc = [tempArray componentsJoinedByString:@"/"];
    
    NSString *pageinfo = document.Query(@"#pageinfo").first().attr(@"pageinfo");
    int pageCount = [pageinfo intValue];
    
    NSMutableArray *srcArray = [NSMutableArray new];
    for (int i = 0; i < pageCount; i++) {
        NSString *src = [NSString stringWithFormat:@"%@/%d.jpg", baseSrc, i+1];
        [srcArray addObject:src];
    }
    block(srcArray);
}

@end
