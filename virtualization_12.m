//
//  virtualization_12.m
//
//  Created by codehex.
//

#import "virtualization_12.h"

bool vmCanStop(void *machine, void *queue)
{
#ifdef INCLUDE_TARGET_OSX_12
    if (@available(macOS 12, *)) {
        __block BOOL result;
        dispatch_sync((dispatch_queue_t)queue, ^{
            result = ((VZVirtualMachine *)machine).canStop;
        });
        return (bool)result;
    }
#endif
    RAISE_UNSUPPORTED_MACOS_EXCEPTION();
}

void stopWithCompletionHandler(void *machine, void *queue, void *completionHandler)
{
#ifdef INCLUDE_TARGET_OSX_12
    if (@available(macOS 12, *)) {
        vm_completion_handler_t handler = makeVMCompletionHandler(completionHandler);
        dispatch_sync((dispatch_queue_t)queue, ^{
            [(VZVirtualMachine *)machine stopWithCompletionHandler:handler];
        });
        Block_release(handler);
        return;
    }
#endif
    RAISE_UNSUPPORTED_MACOS_EXCEPTION();
}

/*!
 @abstract The platform configuration for a generic Intel or ARM virtual machine.
*/
void *newVZGenericPlatformConfiguration()
{
#ifdef INCLUDE_TARGET_OSX_12
    if (@available(macOS 12, *)) {
        return [[VZGenericPlatformConfiguration alloc] init];
    }
#endif
    RAISE_UNSUPPORTED_MACOS_EXCEPTION();
}

/*!
 @abstract List of directory sharing devices. Empty by default.
 @see VZDirectorySharingDeviceConfiguration
 */
void setDirectorySharingDevicesVZVirtualMachineConfiguration(void *config, void *directorySharingDevices)
{
#ifdef INCLUDE_TARGET_OSX_12
    if (@available(macOS 12, *)) {
        [(VZVirtualMachineConfiguration *)config setDirectorySharingDevices:[(NSMutableArray *)directorySharingDevices copy]];
        return;
    }
#endif
    RAISE_UNSUPPORTED_MACOS_EXCEPTION();
}

/*!
 @abstract The hardware platform to use.
 @discussion
    Can be an instance of a VZGenericPlatformConfiguration or VZMacPlatformConfiguration. Defaults to VZGenericPlatformConfiguration.
 */
void setPlatformVZVirtualMachineConfiguration(void *config, void *platform)
{
#ifdef INCLUDE_TARGET_OSX_12
    if (@available(macOS 12, *)) {
        [(VZVirtualMachineConfiguration *)config setPlatform:(VZPlatformConfiguration *)platform];
        return;
    }
#endif
    RAISE_UNSUPPORTED_MACOS_EXCEPTION();
}

/*!
 @abstract List of graphics devices. Empty by default.
 @see VZMacGraphicsDeviceConfiguration
 */
void setGraphicsDevicesVZVirtualMachineConfiguration(void *config, void *graphicsDevices)
{
#ifdef INCLUDE_TARGET_OSX_12
    if (@available(macOS 12, *)) {
        [(VZVirtualMachineConfiguration *)config setGraphicsDevices:[(NSMutableArray *)graphicsDevices copy]];
        return;
    }
#endif
    RAISE_UNSUPPORTED_MACOS_EXCEPTION();
}

/*!
 @abstract List of pointing devices. Empty by default.
 @see VZUSBScreenCoordinatePointingDeviceConfiguration
 */
void setPointingDevicesVZVirtualMachineConfiguration(void *config, void *pointingDevices)
{
#ifdef INCLUDE_TARGET_OSX_12
    if (@available(macOS 12, *)) {
        [(VZVirtualMachineConfiguration *)config setPointingDevices:[(NSMutableArray *)pointingDevices copy]];
        return;
    }
#endif
    RAISE_UNSUPPORTED_MACOS_EXCEPTION();
}

/*!
 @abstract List of keyboards. Empty by default.
 @see VZUSBKeyboardConfiguration
 */
void setKeyboardsVZVirtualMachineConfiguration(void *config, void *keyboards)
{
#ifdef INCLUDE_TARGET_OSX_12
    if (@available(macOS 12, *)) {
        [(VZVirtualMachineConfiguration *)config setKeyboards:[(NSMutableArray *)keyboards copy]];
        return;
    }
#endif
    RAISE_UNSUPPORTED_MACOS_EXCEPTION();
}

/*!
 @abstract List of audio devices. Empty by default.
 @see VZVirtioSoundDeviceConfiguration
 */
void setAudioDevicesVZVirtualMachineConfiguration(void *config, void *audioDevices)
{
#ifdef INCLUDE_TARGET_OSX_12
    if (@available(macOS 12, *)) {
        [(VZVirtualMachineConfiguration *)config setAudioDevices:[(NSMutableArray *)audioDevices copy]];
        return;
    }
#endif
    RAISE_UNSUPPORTED_MACOS_EXCEPTION();
}

/*!
 @abstract Initialize a new Virtio Sound Device Configuration.
 @discussion The device exposes a source or destination of sound.
 */
void *newVZVirtioSoundDeviceConfiguration()
{
#ifdef INCLUDE_TARGET_OSX_12
    if (@available(macOS 12, *)) {
        return [[VZVirtioSoundDeviceConfiguration alloc] init];
    }
#endif
    RAISE_UNSUPPORTED_MACOS_EXCEPTION();
}

/*!
 @abstract Set the list of audio streams exposed by this device. Empty by default.
*/
void setStreamsVZVirtioSoundDeviceConfiguration(void *audioDeviceConfiguration, void *streams)
{
#ifdef INCLUDE_TARGET_OSX_12
    if (@available(macOS 12, *)) {
        [(VZVirtioSoundDeviceConfiguration *)audioDeviceConfiguration setStreams:[(NSMutableArray *)streams copy]];
        return;
    }
#endif
    RAISE_UNSUPPORTED_MACOS_EXCEPTION();
}

/*!
 @abstract Initialize a new Virtio Sound Device Input Stream Configuration.
 @discussion A PCM stream of input audio data, such as from a microphone.
 */
void *newVZVirtioSoundDeviceInputStreamConfiguration()
{
#ifdef INCLUDE_TARGET_OSX_12
    if (@available(macOS 12, *)) {
        return [[VZVirtioSoundDeviceInputStreamConfiguration alloc] init];
    }
#endif
    RAISE_UNSUPPORTED_MACOS_EXCEPTION();
}

/*!
 @abstract Initialize a new Virtio Sound Device Host Audio Input Stream Configuration.
 */
void *newVZVirtioSoundDeviceHostInputStreamConfiguration()
{
#ifdef INCLUDE_TARGET_OSX_12
    if (@available(macOS 12, *)) {
        VZVirtioSoundDeviceInputStreamConfiguration *inputStream = (VZVirtioSoundDeviceInputStreamConfiguration *)newVZVirtioSoundDeviceInputStreamConfiguration();
        [inputStream setSource:[[VZHostAudioInputStreamSource alloc] init]];
        return inputStream;
    }
#endif
    RAISE_UNSUPPORTED_MACOS_EXCEPTION();
}

/*!
 @abstract Initialize a new Virtio Sound Device Output Stream Configuration.
 @discussion A PCM stream of output audio data, such as to a speaker.
 */
void *newVZVirtioSoundDeviceOutputStreamConfiguration()
{
#ifdef INCLUDE_TARGET_OSX_12
    if (@available(macOS 12, *)) {
        return [[VZVirtioSoundDeviceOutputStreamConfiguration alloc] init];
    }
#endif
    RAISE_UNSUPPORTED_MACOS_EXCEPTION();
}

/*!
 @abstract Initialize a new Virtio Sound Device Host Audio Output Stream Configuration.
 */
void *newVZVirtioSoundDeviceHostOutputStreamConfiguration()
{
#ifdef INCLUDE_TARGET_OSX_12
    if (@available(macOS 12, *)) {
        VZVirtioSoundDeviceOutputStreamConfiguration *outputStream = (VZVirtioSoundDeviceOutputStreamConfiguration *)newVZVirtioSoundDeviceOutputStreamConfiguration();
        [outputStream setSink:[[VZHostAudioOutputStreamSink alloc] init]];
        return outputStream;
    }
#endif
    RAISE_UNSUPPORTED_MACOS_EXCEPTION();
}

/*!
 @abstract Initialize the attachment from a local file url.
 @param diskPath Local file path to the disk image in RAW format.
 @param readOnly If YES, the device attachment is read-only, otherwise the device can write data to the disk image.
 @param cacheMode The caching mode from one of the available VZDiskImageCachingMode options.
 @param syncMode How the disk image synchronizes with the underlying storage when the guest operating system flushes data, described by one of the available VZDiskImageSynchronizationMode modes.
 @param error If not nil, assigned with the error if the initialization failed.
 @return A VZDiskImageStorageDeviceAttachment on success. Nil otherwise and the error parameter is populated if set.
 */
void *newVZDiskImageStorageDeviceAttachmentWithCacheAndSyncMode(const char *diskPath, bool readOnly, int cacheMode, int syncMode, void **error)
{
#ifdef INCLUDE_TARGET_OSX_12
    if (@available(macOS 12, *)) {
        NSString *diskPathNSString = [NSString stringWithUTF8String:diskPath];
        NSURL *diskURL = [NSURL fileURLWithPath:diskPathNSString];
        return [[VZDiskImageStorageDeviceAttachment alloc]
                    initWithURL:diskURL
                       readOnly:(BOOL)readOnly
                    cachingMode:(VZDiskImageCachingMode)cacheMode
            synchronizationMode:(VZDiskImageSynchronizationMode)syncMode
                          error:(NSError *_Nullable *_Nullable)error];
    }
#endif
    RAISE_UNSUPPORTED_MACOS_EXCEPTION();
}

/*!
 @abstract Initialize the VZSharedDirectory from the directory path and read only option.
 @param dirPath
    The directory path that will be share.
 @param readOnly
    If the directory should be mounted read only.
 @return A VZSharedDirectory
 */
void *newVZSharedDirectory(const char *dirPath, bool readOnly)
{
#ifdef INCLUDE_TARGET_OSX_12
    if (@available(macOS 12, *)) {
        NSString *dirPathNSString = [NSString stringWithUTF8String:dirPath];
        NSURL *dirURL = [NSURL fileURLWithPath:dirPathNSString];
        return [[VZSharedDirectory alloc] initWithURL:dirURL readOnly:(BOOL)readOnly];
    }
#endif
    RAISE_UNSUPPORTED_MACOS_EXCEPTION();
}

/*!
 @abstract Initialize the VZSingleDirectoryShare from the shared directory.
 @param sharedDirectory
    The shared directory to use.
 @return A VZSingleDirectoryShare
 */
void *newVZSingleDirectoryShare(void *sharedDirectory)
{
#ifdef INCLUDE_TARGET_OSX_12
    if (@available(macOS 12, *)) {
        return [[VZSingleDirectoryShare alloc] initWithDirectory:(VZSharedDirectory *)sharedDirectory];
    }
#endif
    RAISE_UNSUPPORTED_MACOS_EXCEPTION();
}

/*!
 @abstract Initialize the VZMultipleDirectoryShare from the shared directories.
 @param sharedDirectories
    NSDictionary mapping names to shared directories.
 @return A VZMultipleDirectoryShare
 */
void *newVZMultipleDirectoryShare(void *sharedDirectories)
{
#ifdef INCLUDE_TARGET_OSX_12
    if (@available(macOS 12, *)) {
        return [[VZMultipleDirectoryShare alloc] initWithDirectories:(NSDictionary<NSString *, VZSharedDirectory *> *)sharedDirectories];
    }
#endif
    RAISE_UNSUPPORTED_MACOS_EXCEPTION();
}

/*!
 @abstract Initialize the VZVirtioFileSystemDeviceConfiguration from the fs tag.
 @param tag
    The tag to use for this device configuration.
 @return A VZVirtioFileSystemDeviceConfiguration
 */
void *newVZVirtioFileSystemDeviceConfiguration(const char *tag, void **error)
{
#ifdef INCLUDE_TARGET_OSX_12
    if (@available(macOS 12, *)) {
        NSString *tagNSString = [NSString stringWithUTF8String:tag];
        BOOL valid = [VZVirtioFileSystemDeviceConfiguration validateTag:tagNSString error:(NSError *_Nullable *_Nullable)error];
        if (!valid) {
            return nil;
        }
        return [[VZVirtioFileSystemDeviceConfiguration alloc] initWithTag:tagNSString];
    }
#endif
    RAISE_UNSUPPORTED_MACOS_EXCEPTION();
}

/*!
 @abstract Sets share associated with this configuration.
 */
void setVZVirtioFileSystemDeviceConfigurationShare(void *config, void *share)
{
#ifdef INCLUDE_TARGET_OSX_12
    if (@available(macOS 12, *)) {
        [(VZVirtioFileSystemDeviceConfiguration *)config setShare:(VZDirectoryShare *)share];
        return;
    }
#endif
    RAISE_UNSUPPORTED_MACOS_EXCEPTION();
}

/*!
 @abstract Initialize a new configuration for a USB pointing device that reports absolute coordinates.
 @discussion This device can be used by VZVirtualMachineView to send pointer events to the virtual machine.
 */
void *newVZUSBScreenCoordinatePointingDeviceConfiguration()
{
#ifdef INCLUDE_TARGET_OSX_12
    if (@available(macOS 12, *)) {
        return [[VZUSBScreenCoordinatePointingDeviceConfiguration alloc] init];
    }
#endif
    RAISE_UNSUPPORTED_MACOS_EXCEPTION();
}

/*!
 @abstract Initialize a new configuration for a USB keyboard.
 @discussion This device can be used by VZVirtualMachineView to send key events to the virtual machine.
 */
void *newVZUSBKeyboardConfiguration()
{
#ifdef INCLUDE_TARGET_OSX_12
    if (@available(macOS 12, *)) {
        return [[VZUSBKeyboardConfiguration alloc] init];
    }
#endif
    RAISE_UNSUPPORTED_MACOS_EXCEPTION();
}

void startVirtualMachineWindow(void *machine, double width, double height)
{
    // Create a shared app instance.
    // This will initialize the global variable
    // 'NSApp' with the application instance.
#ifdef INCLUDE_TARGET_OSX_12
    [VZApplication sharedApplication];
    if (@available(macOS 12, *)) {
        @autoreleasepool {
            AppDelegate *appDelegate = [[[AppDelegate alloc]
                initWithVirtualMachine:(VZVirtualMachine *)machine
                           windowWidth:(CGFloat)width
                          windowHeight:(CGFloat)height] autorelease];

            NSApp.delegate = appDelegate;
            [NSApp run];
            return;
        }
    }
#endif
    RAISE_UNSUPPORTED_MACOS_EXCEPTION();
}
