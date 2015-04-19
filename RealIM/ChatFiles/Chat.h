//
//  Chat.h
//  PostJob
//
//  Created by Subin Kurian on 1/28/15.
//  Copyright (c) 2015 antonyouseph. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIBubbleTableViewDataSource.h"
#import "HPGrowingTextView.h"
#import <Parse/PFQuery.h>
#import <Parse/PFFile.h>
#import <ParseUI/PFImageView.h>
@interface Chat : UIViewController<UIBubbleTableViewDataSource,HPGrowingTextViewDelegate>
{
    UIView *containerView;
    HPGrowingTextView *textView;
    IBOutlet UIBubbleTableView *bubbleTable;
    IBOutlet UIView *textInputView;
    IBOutlet UITextField *textField;
    NSMutableArray *bubbleData;

}


@end
