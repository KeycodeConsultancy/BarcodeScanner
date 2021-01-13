//
//  ProductViewController.h
//  Barcode
//
//  Created by Kevin Reid on 08/03/2018.
//  Copyright © 2018 Kevin Reid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Product.h"

@interface ProductViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *brandLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *elidLabel;
@property (weak, nonatomic) IBOutlet UILabel *eanLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;

@property (strong, nonatomic) Product *product;
- (IBAction)done:(id)sender;

@end
