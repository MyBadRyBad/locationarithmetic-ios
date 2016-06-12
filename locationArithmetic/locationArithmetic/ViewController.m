//
//  ViewController.m
//  locationArithmetic
//
//  Created by Ryan Badilla on 6/12/16.
//  Copyright © 2016 rybad. All rights reserved.
//

#import "ViewController.h"
#import "LocationArithmeticManager.h"

#define ALPHA  @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
#define NUMERIC @"0123456789"

@interface ViewController () <UITextFieldDelegate>

@end

@implementation ViewController


#pragma mark -
#pragma mark - view controller lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [_locationNumeralTextField becomeFirstResponder];
}

#pragma mark -
#pragma mark - setup
- (void)setup {
    [self setupView];
    [self setupConstraints];
}

- (void)setupView {
    [self.view addSubview:[self abbreviatedLocationNumeralLabel]];
    [self.view addSubview:[self integerLabel]];
    [self.view addSubview:[self locationNumeralLabel]];
    
    [self.view addSubview:[self locationNumeralTextField]];
    [self.view addSubview:[self integerTextField]];
    [self.view addSubview:[self abbreviatedLocationNumeralTextField]];
}

- (void)setupConstraints {
    NSDictionary *viewsDictionary =  NSDictionaryOfVariableBindings(_abbreviatedLocationNumeralLabel, _integerLabel, _locationNumeralLabel, _locationNumeralTextField, _integerTextField, _abbreviatedLocationNumeralTextField);
    NSDictionary *metrics = @{@"vBuffer" : @(64),
                              @"vLabel" : @(20),
                              @"vTextField" : @(30)};
    
    
    // setup vertical constraints
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-vBuffer-[_abbreviatedLocationNumeralLabel(vLabel)][_abbreviatedLocationNumeralTextField(vTextField)]-[_locationNumeralLabel(vLabel)][_locationNumeralTextField(vTextField)]-[_integerLabel(vLabel)][_integerTextField(vTextField)]" options:0 metrics:metrics views:viewsDictionary]];
    
    // setup horizontal constraints
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_abbreviatedLocationNumeralLabel]-|" options:0 metrics:metrics views:viewsDictionary]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_abbreviatedLocationNumeralTextField]-|" options:0 metrics:metrics views:viewsDictionary]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_locationNumeralLabel]-|" options:0 metrics:metrics views:viewsDictionary]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_locationNumeralTextField]-|" options:0 metrics:metrics views:viewsDictionary]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_integerLabel]-|" options:0 metrics:metrics views:viewsDictionary]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_integerTextField]-|" options:0 metrics:metrics views:viewsDictionary]];
}


#pragma mark -
#pragma mark - didReceiveMemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - UITextField delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == _locationNumeralTextField) {
        
        return ([string rangeOfCharacterFromSet:[[NSCharacterSet characterSetWithCharactersInString:ALPHA] invertedSet]].location == NSNotFound);
        
    } else if (textField == _integerTextField) {
        
        return ([string rangeOfCharacterFromSet:[[NSCharacterSet characterSetWithCharactersInString:NUMERIC] invertedSet]].location == NSNotFound);
    }
    
    return YES;
}

- (void)textFieldDidChange:(UITextField *)textField {
    if (textField == _locationNumeralTextField) {
        LocationArithmeticManager *manager = [LocationArithmeticManager sharedManager];
        NSUInteger integerLocation = [manager integerFromLocationNumeral:_locationNumeralTextField.text];
        NSString *abbreviatedString = [manager locationStringFromInteger:integerLocation];
        
        _integerTextField.text = [NSString stringWithFormat:@"%lu", (unsigned long)integerLocation];
        _abbreviatedLocationNumeralTextField.text = abbreviatedString;
    } else if (textField == _integerTextField){
        LocationArithmeticManager *manager = [LocationArithmeticManager sharedManager];
        NSUInteger integerLocation = [_integerTextField.text integerValue];
        NSString *abbreviatedString = [manager locationStringFromInteger:integerLocation];
        
        _locationNumeralTextField.text = abbreviatedString;
        _abbreviatedLocationNumeralTextField.text = abbreviatedString;
    }
}


#pragma mark -
#pragma mark - getter methods
- (UILabel *)abbreviatedLocationNumeralLabel {
    if (!_abbreviatedLocationNumeralLabel) {
        _abbreviatedLocationNumeralLabel = [[UILabel alloc] init];
        _abbreviatedLocationNumeralLabel.translatesAutoresizingMaskIntoConstraints = NO;
        
        _abbreviatedLocationNumeralLabel.text = NSLocalizedString(@"Abbreviated Location", nil);
        _abbreviatedLocationNumeralLabel.font = [UIFont boldSystemFontOfSize:12.0f];
        _abbreviatedLocationNumeralLabel.textColor = [UIColor colorWithRed:41.0/255.0f green:128.0/255.0f blue:185.0/255.0f alpha:1.0f];
    }
    
    return _abbreviatedLocationNumeralLabel;
}

- (UILabel *)integerLabel {
    if (!_integerLabel) {
        _integerLabel = [[UILabel alloc] init];
        _integerLabel.translatesAutoresizingMaskIntoConstraints = NO;
        
        _integerLabel.text = NSLocalizedString(@"Integer", nil);
        _integerLabel.font = [UIFont boldSystemFontOfSize:12.0f];
        _integerLabel.textColor = [UIColor colorWithRed:41.0/255.0f green:128.0/255.0f blue:185.0/255.0f alpha:1.0f];
    }
    
    return _integerLabel;
}

- (UILabel *)locationNumeralLabel {
    if (!_locationNumeralLabel) {
        _locationNumeralLabel = [[UILabel alloc] init];
        _locationNumeralLabel.translatesAutoresizingMaskIntoConstraints = NO;
        
        _locationNumeralLabel.text = NSLocalizedString(@"Location Numeral", nil);
        _locationNumeralLabel.font = [UIFont boldSystemFontOfSize:12.0f];
        
        _locationNumeralLabel.textColor = [UIColor colorWithRed:41.0/255.0f green:128.0/255.0f blue:185.0/255.0f alpha:1.0f];
    }
    
    return _locationNumeralLabel;
}

- (UITextField *)locationNumeralTextField {
    if (!_locationNumeralTextField) {
        _locationNumeralTextField = [[UITextField alloc] init];
        _locationNumeralTextField.translatesAutoresizingMaskIntoConstraints = NO;
        
        _locationNumeralTextField.placeholder = NSLocalizedString(@"abcde", nil);
        _locationNumeralTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _locationNumeralTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        
        _locationNumeralTextField.delegate = self;
        [_locationNumeralTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    
    return _locationNumeralTextField;
}

- (UITextField *)integerTextField {
    if (!_integerTextField) {
        _integerTextField = [[UITextField alloc] init];
        _integerTextField.translatesAutoresizingMaskIntoConstraints = NO;
        
        _integerTextField.placeholder = NSLocalizedString(@"100000", nil);
        _integerTextField.keyboardType = UIKeyboardTypeNumberPad;
        _integerTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _integerTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        
        _integerTextField.delegate = self;
        [_integerTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    
    return _integerTextField;
}

- (UITextField *)abbreviatedLocationNumeralTextField {
    if (!_abbreviatedLocationNumeralTextField) {
        _abbreviatedLocationNumeralTextField = [[UITextField alloc] init];
        _abbreviatedLocationNumeralTextField.translatesAutoresizingMaskIntoConstraints = NO;
        
        _abbreviatedLocationNumeralTextField.userInteractionEnabled = NO;
        _abbreviatedLocationNumeralTextField.textColor = [UIColor colorWithRed:41.0/255.0f green:128.0/255.0f blue:185.0/255.0f alpha:1.0f];
    }
    
    return _abbreviatedLocationNumeralTextField;
}


@end
