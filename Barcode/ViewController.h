//
//  ViewController.h
//  Barcode
//
//  Created by Kevin Reid on 08/03/2018.
//  Copyright © 2018 Kevin Reid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JsonApi.h"


@interface ViewController : UIViewController<JsonAPIDelegate>

@property (weak, nonatomic) IBOutlet UITextField *barcodeTextField;

- (IBAction)search:(id)sender;

- (IBAction)scan:(id)sender;

@end

