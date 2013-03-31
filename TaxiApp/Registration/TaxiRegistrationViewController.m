//
//  TaxiRegistrationViewController.m
//  TaxiApp
//
//  Created by Arslan Ilyas on 4/1/13.
//  Copyright (c) 2013 Rapidzz. All rights reserved.
//

#import "TaxiRegistrationViewController.h"
#import "LQSession.h"
#import "LQTracker.h"

@interface TaxiRegistrationViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *txtUsername;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
- (IBAction)btnRegister_Tapped:(id)sender;

@end

@implementation TaxiRegistrationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(authenticationDidSucceed:)
                                                 name:LQAuthenticationSucceededNotification
                                               object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnRegister_Tapped:(id)sender {
    if (self.txtUsername.text.length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Taxi App" message:@"Username can't be empty." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if (self.txtPassword.text.length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Taxi App" message:@"Password can't be empty." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    [LQSession createAccountWithUsername:self.txtUsername.text
                                password:self.txtPassword.text
                                   extra:nil
                              completion:^(LQSession *session, NSError *error) {
                                  
                                  if(session.accessToken) {
                                      NSLog(@"Logged in successfully! %@", session.accessToken);
                                      
                                      // Save the session so it will be restored next time
                                      [LQSession setSavedSession:session];
                                      
                                      // Register for push notifications which will show the prompt now
                                      //[self registerForPushNotifications];
                                      
                                      // Start tracking location in "adaptive" mode, which will show the location prompt
                                      [[LQTracker sharedTracker] setProfile:LQTrackerProfileAdaptive];
                                      
                                      // Post a notification so your UI can show the appropriate view
                                      [[NSNotificationCenter defaultCenter] postNotificationName:LQAuthenticationSucceededNotification
                                                                                          object:nil
                                                                                        userInfo:nil];
                                  } else {
                                      // Failed login
                                      NSLog(@"Error logging in %@", error);
                                      [[[UIAlertView alloc] initWithTitle:@"Error" message:[error.userInfo objectForKey:@"error_description"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
                                  }
                              }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)authenticationDidSucceed:(NSNotificationCenter *)notification
{
    [self performSegueWithIdentifier:RegisterToMapSegueIdentifier sender:self];
    // You can dismiss your login screen here, or have some other indication the login was successful
    // ...
}

- (void)viewDidDisappear:(BOOL)animated
{

}


@end
