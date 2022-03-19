//
//  JYDynamicColor.m
//  iOSToolsTest
//
//  Created by karthrine on 2022/3/10.
//

#import "JYDynamicColor.h"
#import "JYTraitCollection.h"
@interface JYDynamicColorProxy : NSProxy <NSCopying>

@property (nonatomic, readonly) UIColor * resolvedColor;

@property (nonatomic, strong) UIColor *(^dynamicProvider)(JYTraitCollection *);

@end


@implementation JYDynamicColorProxy

- (instancetype)initWithDynamicProvider:(UIColor * (^)(JYTraitCollection *traitCollection))dynamicProvider {
  self.dynamicProvider = dynamicProvider;
  return self;
}

- (UIColor *)resolvedColor {
  return [self resolvedColorWithTraitCollection:JYTraitCollection.overrideTraitCollection];
}

- (UIColor *)resolvedColorWithTraitCollection:(JYTraitCollection *)traitCollection {
    return self.dynamicProvider(traitCollection);
}

// MARK: UIColor
- (UIColor *)colorWithAlphaComponent:(CGFloat)alpha {
  return [JYDynamicColor colorWithDynamicProvider:^UIColor *(JYTraitCollection *traitCollection) {
    return [self.dynamicProvider(traitCollection) colorWithAlphaComponent:alpha];
  }];
}

- (CGColorRef)CGColor {
  return [[self resolvedColor] CGColor];
}

// MARK: Methods that do not need forwarding

- (UIColor *)lightColor {
  return [self resolvedColorWithTraitCollection:[JYTraitCollection traitCollectionWithUserInterfaceStyle:JYInterfaceStyleLight]];
}

- (UIColor *)darkColor {
  return [self resolvedColorWithTraitCollection:[JYTraitCollection traitCollectionWithUserInterfaceStyle:JYInterfaceStyleDark]];
}

- (UIColor *)jy_resolvedColorWithTraitCollection:(JYTraitCollection *)traitCollection {
  return [self resolvedColorWithTraitCollection:traitCollection];;
}

 

// MARK: NSProxy - 转发消息 将消息全部转发到 resolvedColor
- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
  return [self.resolvedColor methodSignatureForSelector:sel];
}

- (void)forwardInvocation:(NSInvocation *)invocation {
  [invocation invokeWithTarget:self.resolvedColor];
}

// MARK: NSObject

- (BOOL)isKindOfClass:(Class)aClass {
  static JYDynamicColor *dynamicColor = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    dynamicColor = [[JYDynamicColor alloc] init];
  });
  return [dynamicColor isKindOfClass:aClass];
}

// MARK: NSCopying

- (id)copy {
  return [self copyWithZone:nil];
}

- (id)copyWithZone:(NSZone *)zone {
  return [[JYDynamicColorProxy alloc] initWithDynamicProvider:[self.dynamicProvider copy]];
}

@end



@implementation JYDynamicColor

+ (UIColor *)colorWithLightColor:(UIColor *)lightColor darkColor:(UIColor *)darkColor {
  return [self colorWithDynamicProvider:^(JYTraitCollection *traitCollection){
    return traitCollection.userInterfaceStyle == JYInterfaceStyleDark ? darkColor : lightColor;
  }];
}

+ (UIColor *)colorWithDynamicProvider:(UIColor * _Nonnull (^)(JYTraitCollection * _Nonnull))dynamicProvider {
    
    return (JYDynamicColor *)[[JYDynamicColorProxy alloc] initWithDynamicProvider:dynamicProvider];
}

- (UIColor *)lightColor {
  NSAssert(NO, @"This should never be called");
  return nil;
}

- (UIColor *)darkColor {
  NSAssert(NO, @"This should never be called");
   return nil;
}

@end
    
