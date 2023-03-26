#pragma once

#import <Availability.h>
#import <Foundation/Foundation.h>

NSDictionary *dumpProcessinfo();

#define RAISE_REASON_MESSAGE                                                                               \
    "This may possibly be a bug due to library handling errors.\n"                                         \
    "I would appreciate it if you could report it to https://github.com/Code-Hex/vz/issues/new/choose\n\n" \
    "Information: %@\n"

#define RAISE_UNSUPPORTED_MACOS_EXCEPTION()                   \
    do {                                                      \
        [NSException                                          \
             raise:@"UnhandledAvailabilityException"          \
            format:@RAISE_REASON_MESSAGE, dumpProcessinfo()]; \
        __builtin_unreachable();                              \
    } while (0)

// for macOS 12 API
#if __MAC_OS_X_VERSION_MAX_ALLOWED >= 120000
#define INCLUDE_TARGET_OSX_12 1
#else
#pragma message("macOS 12 API has been disabled")
#endif

// for macOS 12.3 API
#if __MAC_OS_X_VERSION_MAX_ALLOWED >= 120300
#define INCLUDE_TARGET_OSX_12_3 1
#else
#pragma message("macOS 12.3 API has been disabled")
#endif

// for macOS 13 API
#if __MAC_OS_X_VERSION_MAX_ALLOWED >= 130000
#define INCLUDE_TARGET_OSX_13 1
#else
#pragma message("macOS 13 API has been disabled")
#endif

static inline int mac_os_x_version_max_allowed()
{
#ifdef __MAC_OS_X_VERSION_MAX_ALLOWED
    return __MAC_OS_X_VERSION_MAX_ALLOWED;
#else
    return 0;
#endif
}

typedef struct nbyteslice {
    void *ptr;
    int len;
} nbyteslice;

/* exported from cgo */
void virtualMachineCompletionHandler(void *cgoHandler, void *errPtr);

typedef void (^vm_completion_handler_t)(NSError *);

static inline vm_completion_handler_t makeVMCompletionHandler(void *completionHandler)
{
    return Block_copy(^(NSError *err) {
        virtualMachineCompletionHandler(completionHandler, err);
    });
}
