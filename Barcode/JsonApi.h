//
//  JsonApi.h
//  Barcode
//
//  Created by Kevin Reid on 08/03/2018.
//  Copyright © 2018 Kevin Reid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Product.h"


@protocol JsonAPIDelegate

- (void)didReceiveData:(Product *)product;
- (void)didReceiveError:(NSError *)error;

@end

@interface JsonApi : NSObject

@property (nonatomic, weak) id <JsonAPIDelegate> delegate;
-(void)lookUpProductByCode:(NSString *)barcode;

@end






