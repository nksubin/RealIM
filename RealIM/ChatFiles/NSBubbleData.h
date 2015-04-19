
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef enum _NSBubbleType
{
    BubbleTypeMine = 0,
    BubbleTypeSomeoneElse = 1
} NSBubbleType;

@interface NSBubbleData : NSObject

@property (readonly, nonatomic, strong) NSDate *date;
@property (readonly, nonatomic) NSBubbleType type;
@property (readonly, nonatomic, strong) UIView *view;
@property (readonly, nonatomic) UIEdgeInsets insets;
@property (nonatomic, strong) UIImage *avatar;
@property(nonatomic,strong)NSString *userName;

- (instancetype)initWithText:(NSString *)text date:(NSDate *)date type:(NSBubbleType)type name:(NSString*)name;
+ (instancetype)dataWithText:(NSString *)text date:(NSDate *)date type:(NSBubbleType)type name:(NSString*)name;
- (instancetype)initWithImage:(UIImage *)image date:(NSDate *)date type:(NSBubbleType)type name:(NSString*)name;
+ (instancetype)dataWithImage:(UIImage *)image date:(NSDate *)date type:(NSBubbleType)type name:(NSString*)name;
- (instancetype)initWithView:(UIView *)view date:(NSDate *)date type:(NSBubbleType)type insets:(UIEdgeInsets)insets name:(NSString*)name NS_DESIGNATED_INITIALIZER;
+ (instancetype)dataWithView:(UIView *)view date:(NSDate *)date type:(NSBubbleType)type insets:(UIEdgeInsets)insets name:(NSString*)name;

@end
