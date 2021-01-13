//
//  ProductViewController.m
//  Barcode
//
//  Created by Kevin Reid on 08/03/2018.
//  Copyright © 2018 Kevin Reid. All rights reserved.
//

#import "ProductViewController.h"
#import "ViewController.h"

@interface ProductViewController ()

@end

@implementation ProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    self.titleLabel.text = self.product.title;
    self.brandLabel.text = self.product.brand;
    self.eanLabel.text = self.product.ean;
    self.elidLabel.text = self.product.elid;
    self.descriptionTextView.text = self.product.productDescription;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)done:(id)sender {
    ViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeView"];
    [self presentViewController:vc animated:YES completion:nil];
}
@end
