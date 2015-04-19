
#import "NSBubbleData.h"
#import <QuartzCore/QuartzCore.h>

@implementation NSBubbleData

#pragma mark - Properties

@synthesize date = _date;
@synthesize type = _type;
@synthesize view = _view;
@synthesize insets = _insets;
@synthesize avatar = _avatar;
@synthesize userName=_userName;

#pragma mark - Lifecycle

#if !__has_feature(objc_arc)
- (void)dealloc
{
    [_date release];
	_date = nil;
    [_view release];
    _view = nil;
    
    self.avatar = nil;

    [super dealloc];
}
#endif

#pragma mark - Text bubble

const UIEdgeInsets textInsetsMine = {5, 10, 11, 17};
const UIEdgeInsets textInsetsSomeone = {5, 15, 11, 10};

+ (instancetype)dataWithText:(NSString *)text date:(NSDate *)date type:(NSBubbleType)type name:(NSString*)name
{
#if !__has_feature(objc_arc)
    return [[[NSBubbleData alloc] initWithText:text date:date type:type name:name] autorelease];
#else
    return [[NSBubbleData alloc] initWithText:text date:date type:type name:name];
#endif    
}

- (instancetype)initWithText:(NSString *)text date:(NSDate *)date type:(NSBubbleType)type name:(NSString*)name
{
    UIFont *font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
     CGSize size = [self frameForText:text sizeWithFont:font constrainedToSize:CGSizeMake(220,9999) lineBreakMode:NSLineBreakByWordWrapping ];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.text = (text ? text : @"");
    label.font = font;
    label.backgroundColor = [UIColor clearColor];
    
#if !__has_feature(objc_arc)
    [label autorelease];
#endif
    
    UIEdgeInsets insets = (type == BubbleTypeMine ? textInsetsMine : textInsetsSomeone);
    return [self initWithView:label date:date type:type insets:insets name:name];
}
-(CGSize)frameForText:(NSString*)text sizeWithFont:(UIFont*)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode  {
    
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = lineBreakMode;
    
    NSDictionary * attributes = @{NSFontAttributeName:font,
                                  NSParagraphStyleAttributeName:paragraphStyle
                                  };
    
    
    CGRect textRect = [text boundingRectWithSize:size
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:attributes
                                         context:nil];
    
    //Contains both width & height ... Needed: The height
    return textRect.size;
}


#pragma mark - Image bubble

const UIEdgeInsets imageInsetsMine = {11, 13, 16, 22};
const UIEdgeInsets imageInsetsSomeone = {11, 18, 16, 14};

+ (instancetype)dataWithImage:(UIImage *)image date:(NSDate *)date type:(NSBubbleType)type name:(NSString*)name
{
#if !__has_feature(objc_arc)
    return [[[NSBubbleData alloc] initWithImage:image date:date type:type name:name] autorelease];
#else
    return [[NSBubbleData alloc] initWithImage:image date:date type:type name:name];
#endif    
}

- (instancetype)initWithImage:(UIImage *)image date:(NSDate *)date type:(NSBubbleType)type name:(NSString*)name
{
    CGSize size = image.size;
    if (size.width > 150)
    {
        size.height /= (size.width / 150);
        size.width = 150;
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    imageView.image = image;
    imageView.layer.cornerRadius = 5.0;
    imageView.layer.masksToBounds = YES;

    
#if !__has_feature(objc_arc)
    [imageView autorelease];
#endif
    
    UIEdgeInsets insets = (type == BubbleTypeMine ? imageInsetsMine : imageInsetsSomeone);
    return [self initWithView:imageView date:date type:type insets:insets name:name];
}

#pragma mark - Custom view bubble

+ (instancetype)dataWithView:(UIView *)view date:(NSDate *)date type:(NSBubbleType)type insets:(UIEdgeInsets)insets name:(NSString*)name
{
#if !__has_feature(objc_arc)
    return [[[NSBubbleData alloc] initWithView:view date:date type:type insets:insets name:name] autorelease];
#else
    return [[NSBubbleData alloc] initWithView:view date:date type:type insets:insets name:name];
#endif    
}

- (instancetype)initWithView:(UIView *)view date:(NSDate *)date type:(NSBubbleType)type insets:(UIEdgeInsets)insets name:(NSString*)name
{
    self = [super init];
    if (self)
    {
#if !__has_feature(objc_arc)
        _view = [view retain];
        _date = [date retain];
        _userName=[name retain];
#else
        _view = view;
        _date = date;
        _userName=name;
#endif
        _type = type;
        _insets = insets;
    }
    return self;
}

@end
