//
//  ViewController.m
//  KhaltiCheckoutOjbectiveC
//
//  Created by Mac on 7/4/24.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

#import "ViewController.h"
#import <KhaltiCheckout/KhaltiCheckout-Swift.h>

@interface ViewController ()

@property (nonatomic, strong) Khalti *khalti;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupKhalti];
    
    // Create the button
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"Pay" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor lightGrayColor];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.frame = CGRectMake(100, 100, 200, 50);
    
    // Add target for button action
    [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    // Add button to the view
    [self.view addSubview:button];
    
    // Set button constraints
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [button.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [button.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
        [button.widthAnchor constraintEqualToConstant:200],
        [button.heightAnchor constraintEqualToConstant:50]
    ]];
}

- (void)setupKhalti {
    // Khalti Configuration
    
    
    KhaltiPayConfig *config = [[KhaltiPayConfig alloc] initWithPublicKey:@"4aa1b684f4de4860968552558fc8487d" pIdx:@"ycMpVrifXFWGT3TBgsVW62" openInKhalti:false environment:EnvironmentTEST];
    
    __weak typeof(self) weakSelf = self;
    
    
    // Initialize Khalti
    self.khalti = [[Khalti alloc] initWithConfig:config
                                 onPaymentResult:^(PaymentResult *paymentResult, Khalti *khalti) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        NSLog(@"Demo | onPaymentResult: %@", paymentResult);
        [khalti close];
        
        
        [strongSelf showSuccessAlertWithTitle:@"Success" message:paymentResult.getMessage ?: @"Success"];
        
    } onMessage:^(OnMessagePayload *onMessageResult, Khalti *khalti) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        // Handle onMessage callback here
        // if needsPaymentConfiramtion true then verify payment status
        [strongSelf showSuccessAlertWithTitle:@"" message:onMessageResult.getMessage];
        
        BOOL shouldVerify = onMessageResult.getNeedsPaymentConfirmation;
        
        if (shouldVerify) {
            [khalti verify];
        } else {
            [khalti close];
        }
        
    } onReturn:^(Khalti *khalti) {
        // Called when payment is success
    }];
}

// Action method for button tap
- (void)buttonTapped:(UIButton *)sender {
    
    [self.khalti openWithViewController:self];
}

- (void)showSuccessAlertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil];
    
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
