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

@interface Fetch()
@property (nonatomic, strong) NSString *nextPage;

@end

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
    NSString *urlString = [[NSString stringWithFormat:@"%@%@", HOST, PATH] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20];
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
    NSArray *array = document.Query(@".MeinvTuPianBox").find(@"li");
    
    if ([array count] > 0) {
        NSMutableArray *mutableList = [NSMutableArray new];
        [array enumerateObjectsUsingBlock:^(OCGumboElement *ele, NSUInteger idx, BOOL * _Nonnull stop) {
            OCGumboNode *a = ele.Query(@"a").first();
            NSString *href = a.attr(@"href");
            NSString *title = a.attr(@"title");
            NSString *src = ele.Query(@"img").first().attr(@"src");
            if (src && ![src isEqualToString:@""]) {
                [mutableList addObject:@{
                                         @"title": title,
                                         @"href": [NSString stringWithFormat:@"%@%@", HOST, href],
                                         @"src": src
                                         }];
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

/************ 以上为老版本处理 **************/

- (void)refresh:(FetchBlock)block {
    self.list = [NSArray new];
    [self getRoute:@"/" block:block];
}

- (void)loadMore:(FetchBlock)block {
    if (!_nextPage) {
        block(@[]);
    } else {
        [self getRoute:[NSString stringWithFormat:@"/%@", _nextPage] block:block];
    }
}

- (void)getRoute: (NSString *)route block:(FetchBlock)block {
    NSString *urlString = [[NSString stringWithFormat:@"%@%@%@", HOST, PATH, route] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20];
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask * dataTask =  [session dataTaskWithRequest:request completionHandler:^(NSData * __nullable data, NSURLResponse * __nullable response, NSError * __nullable error) {
        [self dealFetchData:data block:block];
    }];
    [dataTask resume];
}

- (void)dealFetchData:(NSData *)data block: (FetchBlock)block {
    NSStringEncoding gbkEncodeing = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *htmlString = [[NSString alloc]initWithData:data encoding:gbkEncodeing];
    
    if (!htmlString || [htmlString isEqualToString:@""]) {
        return;
    }
    OCGumboDocument *document = [[OCGumboDocument alloc] initWithHTMLString:htmlString];
    NSArray *array = document.Query(@".MeinvTuPianBox").find(@"li");
    
    NSMutableArray *mutableList = [NSMutableArray new];
    [array enumerateObjectsUsingBlock:^(OCGumboElement *ele, NSUInteger idx, BOOL * _Nonnull stop) {
        OCGumboNode *a = ele.Query(@"a").first();
        NSString *href = a.attr(@"href");
        NSString *title = a.attr(@"title");
        NSString *src = ele.Query(@"img").first().attr(@"src");
        if (src && ![src isEqualToString:@""]) {
            [mutableList addObject:@{
                                     @"title": title,
                                     @"href": [NSString stringWithFormat:@"%@%@", HOST, href],
                                     @"src": src
                                     }];
        }
    }];
    self.list = [NSArray arrayWithArray:[_list arrayByAddingObjectsFromArray:mutableList]];
    
    OCGumboNode *newPages = document.Query(@".NewPages").first();
    NSArray *lis = newPages.Query(@"li");
    [lis enumerateObjectsUsingBlock:^(OCGumboElement *ele, NSUInteger idx, BOOL * _Nonnull stop) {
        OCGumboNode *a = ele.Query(@"a").first();
        NSString *href = a.attr(@"href");
        if (href && ![href isEqualToString:@""]) {
            self.nextPage = href;
            *stop = YES;
        } else {
            self.nextPage = @"";
        }
    }];
    
    block(_list);
}

@end
