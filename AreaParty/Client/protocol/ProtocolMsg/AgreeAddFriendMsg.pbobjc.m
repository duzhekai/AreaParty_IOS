// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: AgreeAddFriendMsg.proto

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

 #import "AgreeAddFriendMsg.pbobjc.h"
// @@protoc_insertion_point(imports)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

#pragma mark - AgreeAddFriendMsgRoot

@implementation AgreeAddFriendMsgRoot

// No extensions in the file and no imports, so no need to generate
// +extensionRegistry.

@end

#pragma mark - AgreeAddFriendMsgRoot_FileDescriptor

static GPBFileDescriptor *AgreeAddFriendMsgRoot_FileDescriptor(void) {
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

#pragma mark - AgreeAddFriendReq

@implementation AgreeAddFriendReq

@dynamic hasFriendUserId, friendUserId;

typedef struct AgreeAddFriendReq__storage_ {
  uint32_t _has_storage_[1];
  NSString *friendUserId;
} AgreeAddFriendReq__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "friendUserId",
        .dataTypeSpecific.className = NULL,
        .number = AgreeAddFriendReq_FieldNumber_FriendUserId,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(AgreeAddFriendReq__storage_, friendUserId),
        .flags = (GPBFieldFlags)(GPBFieldRequired | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeString,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[AgreeAddFriendReq class]
                                     rootClass:[AgreeAddFriendMsgRoot class]
                                          file:AgreeAddFriendMsgRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(AgreeAddFriendReq__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
#if !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    static const char *extraTextFormatInfo =
        "\001\001\014\000";
    [localDescriptor setupExtraTextInfo:extraTextFormatInfo];
#endif  // !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - AgreeAddFriendRsp

@implementation AgreeAddFriendRsp

@dynamic hasResultCode, resultCode;

typedef struct AgreeAddFriendRsp__storage_ {
  uint32_t _has_storage_[1];
  AgreeAddFriendRsp_ResultCode resultCode;
} AgreeAddFriendRsp__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "resultCode",
        .dataTypeSpecific.enumDescFunc = AgreeAddFriendRsp_ResultCode_EnumDescriptor,
        .number = AgreeAddFriendRsp_FieldNumber_ResultCode,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(AgreeAddFriendRsp__storage_, resultCode),
        .flags = (GPBFieldFlags)(GPBFieldRequired | GPBFieldTextFormatNameCustom | GPBFieldHasEnumDescriptor),
        .dataType = GPBDataTypeEnum,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[AgreeAddFriendRsp class]
                                     rootClass:[AgreeAddFriendMsgRoot class]
                                          file:AgreeAddFriendMsgRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(AgreeAddFriendRsp__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
#if !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    static const char *extraTextFormatInfo =
        "\001\001\n\000";
    [localDescriptor setupExtraTextInfo:extraTextFormatInfo];
#endif  // !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - Enum AgreeAddFriendRsp_ResultCode

GPBEnumDescriptor *AgreeAddFriendRsp_ResultCode_EnumDescriptor(void) {
  static GPBEnumDescriptor *descriptor = NULL;
  if (!descriptor) {
    static const char *valueNames =
        "Success\000Fail\000";
    static const int32_t values[] = {
        AgreeAddFriendRsp_ResultCode_Success,
        AgreeAddFriendRsp_ResultCode_Fail,
    };
    GPBEnumDescriptor *worker =
        [GPBEnumDescriptor allocDescriptorForName:GPBNSStringifySymbol(AgreeAddFriendRsp_ResultCode)
                                       valueNames:valueNames
                                           values:values
                                            count:(uint32_t)(sizeof(values) / sizeof(int32_t))
                                     enumVerifier:AgreeAddFriendRsp_ResultCode_IsValidValue];
    if (!OSAtomicCompareAndSwapPtrBarrier(nil, worker, (void * volatile *)&descriptor)) {
      [worker release];
    }
  }
  return descriptor;
}

BOOL AgreeAddFriendRsp_ResultCode_IsValidValue(int32_t value__) {
  switch (value__) {
    case AgreeAddFriendRsp_ResultCode_Success:
    case AgreeAddFriendRsp_ResultCode_Fail:
      return YES;
    default:
      return NO;
  }
}


#pragma clang diagnostic pop

// @@protoc_insertion_point(global_scope)