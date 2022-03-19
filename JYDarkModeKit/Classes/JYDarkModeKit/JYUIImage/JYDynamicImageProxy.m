//
//  JYDynamicImage.m
//  iOSToolsTest
//
//  Created by karthrine on 2022/3/13.
//

#import "JYDynamicImageProxy.h"
#import "JYTraitCollection.h"

@interface JYDynamicImageProxy ()
@property (nonatomic, strong) UIImage *lightImage;
@property (nonatomic, strong) UIImage *darkImage;

@end

@implementation JYDynamicImageProxy

- (instancetype)initWithLightImage:(UIImage *)lightImage darkImage:(UIImage *)darkImage {
  self.lightImage = lightImage;
  self.darkImage = darkImage;
  return self;
}

- (UIImage *)resolvedImage {
  if (JYTraitCollection.currentTraitCollection.userInterfaceStyle == JYInterfaceStyleDark) {
    return self.darkImage;
  }
  return self.lightImage;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
  return [self.resolvedImage methodSignatureForSelector:sel];
}

- (void)forwardInvocation:(NSInvocation *)invocation {
  [invocation invokeWithTarget:self.resolvedImage];
}

#pragma mark - Public Methods

- (UIImage *)resizableImageWithCapInsets:(UIEdgeInsets)capInsets {
  return (UIImage *)[[JYDynamicImageProxy alloc] initWithLightImage:[self.lightImage resizableImageWithCapInsets:capInsets]
                                                          darkImage:[self.darkImage resizableImageWithCapInsets:capInsets]];
}

- (UIImage *)resizableImageWithCapInsets:(UIEdgeInsets)capInsets resizingMode:(UIImageResizingMode)resizingMode {
  UIImage *lightImage = [self.lightImage resizableImageWithCapInsets:capInsets resizingMode:resizingMode];
  UIImage *darkImage = [self.darkImage resizableImageWithCapInsets:capInsets resizingMode:resizingMode];
  return (UIImage *)[[JYDynamicImageProxy alloc] initWithLightImage:lightImage darkImage:darkImage];
}

- (UIImage *)imageWithAlignmentRectInsets:(UIEdgeInsets)alignmentInsets {
  return (UIImage *)[[JYDynamicImageProxy alloc] initWithLightImage:[self.lightImage imageWithAlignmentRectInsets:alignmentInsets]
                                                          darkImage:[self.darkImage imageWithAlignmentRectInsets:alignmentInsets]];
}

- (UIImage *)imageWithRenderingMode:(UIImageRenderingMode)renderingMode {
  return (UIImage *)[[JYDynamicImageProxy alloc] initWithLightImage:[self.lightImage imageWithRenderingMode:renderingMode]
                                                          darkImage:[self.darkImage imageWithRenderingMode:renderingMode]];
}

- (UIImage *)imageFlippedForRightToLeftLayoutDirection {
  return (UIImage *)[[JYDynamicImageProxy alloc] initWithLightImage:[self.lightImage imageFlippedForRightToLeftLayoutDirection]
                                                          darkImage:[self.darkImage imageFlippedForRightToLeftLayoutDirection]];
}

- (UIImage *)imageWithHorizontallyFlippedOrientation {
  return (UIImage *)[[JYDynamicImageProxy alloc] initWithLightImage:[self.lightImage imageWithHorizontallyFlippedOrientation]
                                                          darkImage:[self.darkImage imageWithHorizontallyFlippedOrientation]];
}

- (UIImage *)imageWithConfiguration:(UIImageConfiguration *)configuration API_AVAILABLE(ios(13.0)) {
  if (configuration.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
    return [_darkImage imageWithConfiguration:configuration];
  }
  return [_lightImage imageWithConfiguration:configuration];
}

- (id)copy {
  return [self copyWithZone:nil];
}

- (id)copyWithZone:(NSZone *)zone {
  return [[JYDynamicImageProxy alloc] initWithLightImage:self.lightImage darkImage:self.darkImage];
}

@end

