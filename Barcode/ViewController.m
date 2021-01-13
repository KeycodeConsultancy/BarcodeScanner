//
//  ViewController.m
//  Barcode
//
//  Created by Kevin Reid on 08/03/2018.
//  Copyright © 2018 Kevin Reid. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "ViewController.h"
#import "JsonApi.h"
#import "Product.h"
#import "ProductViewController.h"

@interface ViewController () <AVCaptureMetadataOutputObjectsDelegate> {
    AVCaptureSession *_session;
    AVCaptureDevice *_device;
    AVCaptureDeviceInput *_input;
    AVCaptureMetadataOutput *_output;
    AVCaptureVideoPreviewLayer *_prevLayer;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)setupBarcodeScanner {
    
    _session = [[AVCaptureSession alloc] init];
     //setup camera and media type.
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    
     //Configure video capture, when no video or camera then display error
    _input = [AVCaptureDeviceInput deviceInputWithDevice:_device error:&error];
    if (_input) {
        [_session addInput:_input];
    } else {
        NSLog(@"Error: %@", error);
    }
    
    _output = [[AVCaptureMetadataOutput alloc] init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [_session addOutput:_output];
    
    _output.metadataObjectTypes = [_output availableMetadataObjectTypes];
    
    _prevLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    _prevLayer.frame = self.view.bounds;
    _prevLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:_prevLayer];
    
    //starts the capture session for the camera
    [_session startRunning];
    
}


- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    CGRect highlightViewRect = CGRectZero;
    AVMetadataMachineReadableCodeObject *barCodeObject;
    NSString *detectionString = nil;
      //Barcodes types that will work with this application
    NSArray *barCodeTypes = @[AVMetadataObjectTypeUPCECode, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode39Mod43Code,
                              AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeCode128Code,
                              AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeQRCode, AVMetadataObjectTypeAztecCode];
    
    //get all scanned in values, ie the bar code
    for (AVMetadataObject *metadata in metadataObjects) {
        for (NSString *type in barCodeTypes) {
            if ([metadata.type isEqualToString:type])
            {
                barCodeObject = (AVMetadataMachineReadableCodeObject *)[_prevLayer transformedMetadataObjectForMetadataObject:(AVMetadataMachineReadableCodeObject *)metadata];
                highlightViewRect = barCodeObject.bounds;
                detectionString = [(AVMetadataMachineReadableCodeObject *)metadata stringValue];
                break;
            }
        }
        
        if (detectionString != nil) {
            [_session stopRunning];
            //look up the barcode using the api
            [self lookupBarcode:detectionString];
            break;
        }
    }
}




-(void)didReceiveData:(Product *)product {
    if (product != nil) {
        NSLog(@"Brand: %@", product.brand);
        NSLog(@"Description %@", product.productDescription);
        NSLog(@"EAN: %@", product.ean);
        NSLog(@"Elid: %@", product.elid);
        
       
        
        dispatch_sync(dispatch_get_main_queue(),^{
            
            ProductViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ProductView"];
            vc.product = product;
            
            [self presentViewController:vc animated:YES completion:nil];
        });
        
    }
}


-(void)didReceiveError:(NSString *)error {
    NSLog(@"Error: %@", error);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)search:(id)sender {
    [self lookupBarcode:self.barcodeTextField.text];
}

- (IBAction)scan:(id)sender {
    [self setupBarcodeScanner];
}

-(void)lookupBarcode:(NSString *)barcode {
    JsonApi *jsonApi = [[JsonApi alloc]init];
    jsonApi.delegate = self;
    [jsonApi lookUpProductByCode:barcode];
}








@end
