//
//  Home.m
//  RealIM
//
//  Created by Subin Kurian on 4/18/15.
//  Copyright (c) 2015 Subin Kurian. All rights reserved.
//

#import "Home.h"

@interface Home ()

@end

@implementation Home

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title=@"RealIM";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)GoToChatRoom:(UIButton *)sender {
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"What is your name?"
                                                      message:Nil
                                                     delegate:self
                                            cancelButtonTitle:@"Dismiss"
                                            otherButtonTitles:@"Confirm", nil];
    
    [message setAlertViewStyle:UIAlertViewStylePlainTextInput];
    
    [message show];
    message.tag=11;
    

}





- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
   if(alertView.tag==11)
   {
    if (buttonIndex != 0) {
        UITextField *textField = [alertView textFieldAtIndex:0];
        NSLog(@"Plain text input: %@",textField.text);
        NSString* userName = textField.text;
        [[NSUserDefaults standardUserDefaults] setObject:userName forKey:@"chatName"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        if([userName length]!=0)
        {
            [self performSegueWithIdentifier:@"ChatSegue" sender:self];
        }
        
    }
   }
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
