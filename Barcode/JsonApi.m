//
//  JsonApi.m
//  Barcode
//
//  Created by Kevin Reid on 08/03/2018.
//  Copyright © 2018 Kevin Reid. All rights reserved.
//

#import "JsonApi.h"

@implementation JsonApi



-(void)lookUpProductByCode:(NSString *)barcode {
    
    NSString *api = @"https://api.upcitemdb.com/prod/trial/lookup?upc=";
    NSString *urlString = [NSString stringWithFormat:@"%@%@",api,barcode];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *data = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSError *theError = nil;
        
        if (data != nil) {
            
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&theError ];
            
            NSDictionary *jsonResult = nil;
            jsonResult = [json copy];
            
            Product *product = nil;
            product  = [[Product alloc]init];
            product.brand = jsonResult[@"items"][0][@"brand"];
            product.productDescription = jsonResult[@"items"][0][@"description"];
            product.ean = jsonResult[@"items"][0][@"ean"];
            product.elid= jsonResult[@"items"][0][@"elid"];
            product.title= jsonResult[@"items"][0][@"title"];
            NSLog(@"%@Count" , product.title);
            
            if ([[jsonResult valueForKey:@"code"] isEqualToString:@"OK"]) {
                [self.delegate didReceiveData:product];
            } else {
                
                [self.delegate didReceiveError: [jsonResult valueForKey:@"message"]];
            }
            
            
        }
        
    }];
    
    [data resume];
    
}




@end
