//
//  Chat.m
//  PostJob
//
//  Created by Subin Kurian on 1/28/15.
//  Copyright (c) 2015 antonyouseph. All rights reserved.
//

#import "Chat.h"
#import "UIBubbleTableView.h"
#import "UIBubbleTableViewDataSource.h"
#import "NSBubbleData.h"
#define MAX_ENTRIES_LOADED 25
@interface Chat ()<UIActionSheetDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
	NSTimer *timer;
    NSString *chatRoom;
    BOOL isLoading;
}
@end

@implementation Chat

- (void)viewDidLoad {
    
        self.navigationItem.title=@"RealIM";
    UIBarButtonItem *barItm=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(imageSelection:)];
    self.navigationItem.rightBarButtonItem=barItm;
    
    chatRoom=[NSString stringWithFormat:@"ChatRoom"];
    [super viewDidLoad];
    bubbleData = [[NSMutableArray alloc] init];
    bubbleTable.bubbleDataSource = self;

    bubbleTable.snapInterval = 120;

    bubbleTable.showAvatars = YES;
    //bubbleTable.typingBubble = NSBubbleTypingTypeSomebody;
    
    [self loadMessages];
    
   // [bubbleTable reloadData];
    
    // Keyboard events
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];

    
    containerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 40, self.view.frame.size.width, 40)];
    
    textView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(6, 3, self.view.frame.size.width-80, 40)];
    textView.isScrollable = NO;
    textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    
    textView.minNumberOfLines = 1;
    textView.maxNumberOfLines = 6;
    // you can also set the maximum height in points with maxHeight
    // textView.maxHeight = 200.0f;
    textView.font = [UIFont systemFontOfSize:15.0f];
    textView.delegate = self;
    textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    textView.backgroundColor = [UIColor whiteColor];
    textView.placeholder = @"Type your message!";
    
    // textView.text = @"test\n\ntest";
    // textView.animateHeightChange = NO; //turns off animation
    
    [self.view addSubview:containerView];
    
    UIImage *rawEntryBackground = [UIImage imageNamed:@"MessageEntryInputField.png"];
    UIImage *entryBackground = [rawEntryBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
    UIImageView *entryImageView = [[UIImageView alloc] initWithImage:entryBackground];
    entryImageView.frame = CGRectMake(5, 0, self.view.frame.size.width-72, 40);
    entryImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    UIImage *rawBackground = [UIImage imageNamed:@"MessageEntryBackground.png"];
    UIImage *background = [rawBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:background];
    imageView.frame = CGRectMake(0, 0, containerView.frame.size.width, containerView.frame.size.height);
    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    // view hierachy
    [containerView addSubview:imageView];
    [containerView addSubview:textView];
    [containerView addSubview:entryImageView];
    
    UIImage *sendBtnBackground = [[UIImage imageNamed:@"MessageEntrySendButton.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:0];
    UIImage *selectedSendBtnBackground = [[UIImage imageNamed:@"MessageEntrySendButton.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:0];
    
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    doneBtn.frame = CGRectMake(containerView.frame.size.width - 69, 8, 63, 27);
    doneBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    [doneBtn setTitle:@"Send" forState:UIControlStateNormal];
    
    [doneBtn setTitleShadowColor:[UIColor colorWithWhite:0 alpha:0.4] forState:UIControlStateNormal];
    doneBtn.titleLabel.shadowOffset = CGSizeMake (0.0, -1.0);
    doneBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    
    [doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(sayPressed:) forControlEvents:UIControlEventTouchUpInside];
    [doneBtn setBackgroundImage:sendBtnBackground forState:UIControlStateNormal];
    [doneBtn setBackgroundImage:selectedSendBtnBackground forState:UIControlStateSelected];
    [containerView addSubview:doneBtn];
    containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    

    

    
}
- (void)viewDidAppear:(BOOL)animated

{
    [super viewDidAppear:animated];
   
    timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(loadMessages) userInfo:nil repeats:YES];
}


- (void)viewWillDisappear:(BOOL)animated

{
 
    [timer invalidate];
}
#pragma mark - Parse


- (void)loadMessages

{
    if (isLoading == NO)
    {
        isLoading = YES;
        NSBubbleData *message_last = [bubbleData lastObject];
        PFQuery *query = [PFQuery queryWithClassName:chatRoom];
        if (message_last != nil) [query whereKey:@"date" greaterThan:message_last.date];
      
        [query orderByDescending:@"createdAt"];
        [query setLimit:50];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
         {
             if (error == nil)
             {
                
              
                 for (PFObject *object in [objects reverseObjectEnumerator])
                 {
                     
                     NSString * message=[NSString stringWithFormat:@"%@", [object objectForKey:@"text"]];
                     NSDate * date=[object objectForKey:@"date"];
                     NSString * senderName=[NSString stringWithFormat:@"%@",[object objectForKey:@"username"]];
                     PFFile *file=[object objectForKey:@"image"];
                     if(nil!=file)
                     {
                         [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                             if (!error) {
                                  NSBubbleData *sayBubbleImage;
                                 
                                 UIImage *image = [UIImage imageWithData:data];
                                 
                                 if([[[NSUserDefaults standardUserDefaults] objectForKey:@"chatName"]  isEqualToString:senderName])
                                     sayBubbleImage = [NSBubbleData dataWithImage:image date:date type:BubbleTypeMine name:senderName];
                                 else
                                     sayBubbleImage = [NSBubbleData dataWithImage:image date:date type:BubbleTypeSomeoneElse name:senderName];
                                 
                                  [bubbleData addObject:sayBubbleImage];
                                 
                             }
                             
                        
                             
                         }];
                         
                       
                         
                        
                     }
                     else
                     {
                        NSBubbleData *sayBubble;
                    
                     if([[[NSUserDefaults standardUserDefaults] objectForKey:@"chatName"]  isEqualToString:senderName])
                      sayBubble= [NSBubbleData dataWithText:message date:date type:BubbleTypeMine name:senderName];
                     else
                        sayBubble= [NSBubbleData dataWithText:message date:date type:BubbleTypeSomeoneElse name:senderName];
                    
                     
                     [bubbleData addObject:sayBubble];
                     }
                 }
                 if ([objects count] != 0)
                 {
                     [bubbleTable reloadData];
                     [self performSelectorInBackground:@selector(scrollToBottom) withObject:nil];
                 }
                
             }
            
             isLoading = NO;
         }];
    }
}

- (void)scrollToBottom
{
    CGFloat yOffset = 0;
    
    if (bubbleTable.contentSize.height > bubbleTable.bounds.size.height) {
        yOffset = bubbleTable.contentSize.height - bubbleTable.bounds.size.height;
    }
    
    [bubbleTable setContentOffset:CGPointMake(0, yOffset) animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIBubbleTableViewDataSource implementation

- (NSInteger)rowsForBubbleTable:(UIBubbleTableView *)tableView
{
    return (NSInteger)[bubbleData count];
}

- (NSBubbleData *)bubbleTableView:(UIBubbleTableView *)tableView dataForRow:(NSInteger)row
{
    return [bubbleData objectAtIndex:row];
}

#pragma mark - Keyboard events

- (void)keyboardWasShown:(NSNotification*)note
{
    
    
   dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
    
    
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
    // get a rect for the textView frame
    CGRect containerFrame = containerView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height);
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
         containerView.frame = containerFrame;
     bubbleTable.frame = CGRectMake(0, 0, self.view.frame.size.width, containerFrame.origin.y);
     
 
    // set views with new info
        // commit animations
    [UIView commitAnimations];
       
  
 
    if (bubbleTable.contentSize.height > (bubbleTable.frame.size.height-40))
     {
            CGPoint offset = CGPointMake(0, bubbleTable.contentSize.height - (bubbleTable.frame.size.height-5));
            [bubbleTable setContentOffset:offset animated:NO];
     }
     

     
     
 });
    
}

- (void)keyboardWillBeHidden:(NSNotification*)note
{
    
    
    
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // get a rect for the textView frame
    CGRect containerFrame = containerView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - containerFrame.size.height;
    
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    // set views with new info
    containerView.frame = containerFrame;
    bubbleTable.frame = CGRectMake(0, 0, self.view.frame.size.width, containerFrame.origin.y);
    
    // commit animations
    [UIView commitAnimations];
    
}

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
    
    CGRect r = containerView.frame;
    r.size.height -= diff;
    r.origin.y += diff;
    containerView.frame = r;
}


#pragma mark - Actions

- (IBAction)sayPressed:(id)sender
{
    if([textView.text length]!=0)
    {
        bubbleTable.typingBubble = NSBubbleTypingTypeNobody;
        NSDate*date=[NSDate dateWithTimeIntervalSinceNow:0];
        NSString *name=[[NSUserDefaults standardUserDefaults] objectForKey:@"chatName"];
        NSBubbleData *sayBubble = [NSBubbleData dataWithText:textView.text date:date type:BubbleTypeMine name:name];
        
        [bubbleData addObject:sayBubble];
        
        [bubbleTable reloadData];

        
        PFObject *newMessage = [PFObject objectWithClassName:@"ChatRoom"];
        [newMessage setObject:textView.text forKey:@"text"];
        [newMessage setObject:name forKey:@"username"];
        [newMessage setObject:date forKey:@"date"];
        [newMessage saveInBackground];
       
             textView.text = @"";
        
    }
    [textView resignFirstResponder];
}
-(IBAction)imageSelection:(id)sender
{
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"Select Image Source:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                            @"Camera",
                            @"Gallery",
                            nil];
    popup.tag = 1;
    [popup showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (popup.tag) {
        case 1: {
            switch (buttonIndex) {
                case 0:
                    [self camera];
                    break;
                case 1:
                    [self gallery];
                    break;
               
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
}
-(void)camera
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
}
-(void)gallery
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    NSData *imageData = UIImageJPEGRepresentation(chosenImage, 0.25);
    PFFile *imageFile = [PFFile fileWithName:@"chat.jpg" data:imageData];
    
    bubbleTable.typingBubble = NSBubbleTypingTypeNobody;
    NSDate*date=[NSDate dateWithTimeIntervalSinceNow:0];
    NSString *name=[[NSUserDefaults standardUserDefaults] objectForKey:@"chatName"];
    NSBubbleData *sayBubble = [NSBubbleData dataWithImage:chosenImage date:date type:BubbleTypeMine name:name];
    
    [bubbleData addObject:sayBubble];
    
    [bubbleTable reloadData];

    PFObject *newMessage = [PFObject objectWithClassName:@"ChatRoom"];
    [newMessage setObject:textView.text forKey:@"text"];
    [newMessage setObject:name forKey:@"username"];
    [newMessage setObject:date forKey:@"date"];
    [newMessage setObject:imageFile forKey:@"image"];
    [newMessage saveInBackground];
    
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

@end
