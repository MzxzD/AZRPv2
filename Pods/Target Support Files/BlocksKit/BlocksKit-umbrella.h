#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "A2BlockInvocation.h"
#import "A2DynamicDelegate.h"
#import "NSObject+A2BlockDelegate.h"
#import "NSObject+A2DynamicDelegate.h"
#import "NSCache+BlocksKit.h"
#import "NSURLConnection+BlocksKit.h"

FOUNDATION_EXPORT double BlocksKitVersionNumber;
FOUNDATION_EXPORT const unsigned char BlocksKitVersionString[];

