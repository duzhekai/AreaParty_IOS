// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: OffLineMsg.proto

// This CPP symbol can be defined to use imports that match up to the framework
// imports needed when using CocoaPods.
#if !defined(GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS)
 #define GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS 0
#endif

#if GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS
 #import <Protobuf/GPBProtocolBuffers_RuntimeSupport.h>
#else
 #import "GPBProtocolBuffers_RuntimeSupport.h"
#endif

 #import "OffLineMsg.pbobjc.h"
// @@protoc_insertion_point(imports)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

#pragma mark - OffLineMsgRoot

@implementation OffLineMsgRoot

// No extensions in the file and no imports, so no need to generate
// +extensionRegistry.

@end

#pragma mark - OffLineMsgRoot_FileDescriptor

static GPBFileDescriptor *OffLineMsgRoot_FileDescriptor(void) {
  // This is called by +initialize so there is no need to worry
  // about thread safety of the singleton.
  static GPBFileDescriptor *descriptor = NULL;
  if (!descriptor) {
    GPB_DEBUG_CHECK_RUNTIME_VERSIONS();
    descriptor = [[GPBFileDescriptor alloc] initWithPackage:@"protocol"
                                                     syntax:GPBFileSyntaxProto2];
  }
  return descriptor;
}

#pragma mark - OffLineSync

@implementation OffLineSync

@dynamic hasCauseCode, causeCode;

typedef struct OffLineSync__storage_ {
  uint32_t _has_storage_[1];
  OffLineSync_CauseCode causeCode;
} OffLineSync__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "causeCode",
        .dataTypeSpecific.enumDescFunc = OffLineSync_CauseCode_EnumDescriptor,
        .number = OffLineSync_FieldNumber_CauseCode,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(OffLineSync__storage_, causeCode),
        .flags = (GPBFieldFlags)(GPBFieldRequired | GPBFieldTextFormatNameCustom | GPBFieldHasEnumDescriptor),
        .dataType = GPBDataTypeEnum,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[OffLineSync class]
                                     rootClass:[OffLineMsgRoot class]
                                          file:OffLineMsgRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(OffLineSync__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
#if !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    static const char *extraTextFormatInfo =
        "\001\001\t\000";
    [localDescriptor setupExtraTextInfo:extraTextFormatInfo];
#endif  // !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - Enum OffLineSync_CauseCode

GPBEnumDescriptor *OffLineSync_CauseCode_EnumDescriptor(void) {
  static GPBEnumDescriptor *descriptor = NULL;
  if (!descriptor) {
    static const char *valueNames =
        "ChangePassword\000AnotherLogin\000KeepAliveFal"
        "se\000";
    static const int32_t values[] = {
        OffLineSync_CauseCode_ChangePassword,
        OffLineSync_CauseCode_AnotherLogin,
        OffLineSync_CauseCode_KeepAliveFalse,
    };
    GPBEnumDescriptor *worker =
        [GPBEnumDescriptor allocDescriptorForName:GPBNSStringifySymbol(OffLineSync_CauseCode)
                                       valueNames:valueNames
                                           values:values
                                            count:(uint32_t)(sizeof(values) / sizeof(int32_t))
                                     enumVerifier:OffLineSync_CauseCode_IsValidValue];
    if (!OSAtomicCompareAndSwapPtrBarrier(nil, worker, (void * volatile *)&descriptor)) {
      [worker release];
    }
  }
  return descriptor;
}

BOOL OffLineSync_CauseCode_IsValidValue(int32_t value__) {
  switch (value__) {
    case OffLineSync_CauseCode_ChangePassword:
    case OffLineSync_CauseCode_AnotherLogin:
    case OffLineSync_CauseCode_KeepAliveFalse:
      return YES;
    default:
      return NO;
  }
}


#pragma clang diagnostic pop

// @@protoc_insertion_point(global_scope)
