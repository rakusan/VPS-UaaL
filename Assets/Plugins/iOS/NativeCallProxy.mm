#import <Foundation/Foundation.h>
#import "NativeCallProxy.h"


@implementation FrameworkLibAPI

id<NativeCallsProtocol> api = NULL;
+(void) registerAPIforNativeCalls:(id<NativeCallsProtocol>) aApi
{
    api = aApi;
}

@end


extern "C" {
void updateInfoText(const char* infoText)
{
    return [api updateInfoText:[NSString stringWithUTF8String:infoText]];
}

void updateLocation(double latitude, double longitude)
{
    return [api updateLocation:latitude :longitude];
}

void updateSnackBarText(const char* snackBarText)
{
    return [api updateSnackBarText:[NSString stringWithUTF8String:snackBarText]];
}

void updateDebugText(const char* debugText)
{
    return [api updateDebugText:[NSString stringWithUTF8String:debugText]];
}

void clearAllButtonSetActive(bool active)
{
    return [api clearAllButtonSetActive:active];
}

void setAnchorButtonSetActive(bool active)
{
    return [api setAnchorButtonSetActive:active];
}

void debugTextSetActive(bool active) {
    return [api debugTextSetActive:active];
}

}
