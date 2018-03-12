// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: AccreditMsg.proto

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

 #import "AccreditMsg.pbobjc.h"
 #import "ChatData.pbobjc.h"
// @@protoc_insertion_point(imports)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

#pragma mark - AccreditMsgRoot

@implementation AccreditMsgRoot

// No extensions in the file and none of the imports (direct or indirect)
// defined extensions, so no need to generate +extensionRegistry.

@end

#pragma mark - AccreditMsgRoot_FileDescriptor

static GPBFileDescriptor *AccreditMsgRoot_FileDescriptor(void) {
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

#pragma mark - AccreditReq

@implementation AccreditReq

@dynamic hasAccreditCode, accreditCode;
@dynamic hasAccreditMac, accreditMac;
@dynamic hasType, type;
@dynamic hasUserId, userId;
@dynamic hasDeviceType, deviceType;

typedef struct AccreditReq__storage_ {
  uint32_t _has_storage_[1];
  AccreditReq_Type type;
  AccreditReq_DeviceType deviceType;
  NSString *accreditCode;
  NSString *accreditMac;
  NSString *userId;
} AccreditReq__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "accreditCode",
        .dataTypeSpecific.className = NULL,
        .number = AccreditReq_FieldNumber_AccreditCode,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(AccreditReq__storage_, accreditCode),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeString,
      },
      {
        .name = "accreditMac",
        .dataTypeSpecific.className = NULL,
        .number = AccreditReq_FieldNumber_AccreditMac,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(AccreditReq__storage_, accreditMac),
        .flags = (GPBFieldFlags)(GPBFieldRequired | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeString,
      },
      {
        .name = "type",
        .dataTypeSpecific.enumDescFunc = AccreditReq_Type_EnumDescriptor,
        .number = AccreditReq_FieldNumber_Type,
        .hasIndex = 2,
        .offset = (uint32_t)offsetof(AccreditReq__storage_, type),
        .flags = (GPBFieldFlags)(GPBFieldRequired | GPBFieldHasEnumDescriptor),
        .dataType = GPBDataTypeEnum,
      },
      {
        .name = "userId",
        .dataTypeSpecific.className = NULL,
        .number = AccreditReq_FieldNumber_UserId,
        .hasIndex = 3,
        .offset = (uint32_t)offsetof(AccreditReq__storage_, userId),
        .flags = (GPBFieldFlags)(GPBFieldRequired | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeString,
      },
      {
        .name = "deviceType",
        .dataTypeSpecific.enumDescFunc = AccreditReq_DeviceType_EnumDescriptor,
        .number = AccreditReq_FieldNumber_DeviceType,
        .hasIndex = 4,
        .offset = (uint32_t)offsetof(AccreditReq__storage_, deviceType),
        .flags = (GPBFieldFlags)(GPBFieldRequired | GPBFieldTextFormatNameCustom | GPBFieldHasEnumDescriptor),
        .dataType = GPBDataTypeEnum,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[AccreditReq class]
                                     rootClass:[AccreditMsgRoot class]
                                          file:AccreditMsgRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(AccreditReq__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
#if !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    static const char *extraTextFormatInfo =
        "\004\001\014\000\002\013\000\004\006\000\005\n\000";
    [localDescriptor setupExtraTextInfo:extraTextFormatInfo];
#endif  // !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - Enum AccreditReq_Type

GPBEnumDescriptor *AccreditReq_Type_EnumDescriptor(void) {
  static GPBEnumDescriptor *descriptor = NULL;
  if (!descriptor) {
    static const char *valueNames =
        "Agree\000Disagree\000Require\000Onlyonetime\000";
    static const int32_t values[] = {
        AccreditReq_Type_Agree,
        AccreditReq_Type_Disagree,
        AccreditReq_Type_Require,
        AccreditReq_Type_Onlyonetime,
    };
    GPBEnumDescriptor *worker =
        [GPBEnumDescriptor allocDescriptorForName:GPBNSStringifySymbol(AccreditReq_Type)
                                       valueNames:valueNames
                                           values:values
                                            count:(uint32_t)(sizeof(values) / sizeof(int32_t))
                                     enumVerifier:AccreditReq_Type_IsValidValue];
    if (!OSAtomicCompareAndSwapPtrBarrier(nil, worker, (void * volatile *)&descriptor)) {
      [worker release];
    }
  }
  return descriptor;
}

BOOL AccreditReq_Type_IsValidValue(int32_t value__) {
  switch (value__) {
    case AccreditReq_Type_Agree:
    case AccreditReq_Type_Disagree:
    case AccreditReq_Type_Require:
    case AccreditReq_Type_Onlyonetime:
      return YES;
    default:
      return NO;
  }
}

#pragma mark - Enum AccreditReq_DeviceType

GPBEnumDescriptor *AccreditReq_DeviceType_EnumDescriptor(void) {
  static GPBEnumDescriptor *descriptor = NULL;
  if (!descriptor) {
    static const char *valueNames =
        "Mobile\000Pc\000";
    static const int32_t values[] = {
        AccreditReq_DeviceType_Mobile,
        AccreditReq_DeviceType_Pc,
    };
    GPBEnumDescriptor *worker =
        [GPBEnumDescriptor allocDescriptorForName:GPBNSStringifySymbol(AccreditReq_DeviceType)
                                       valueNames:valueNames
                                           values:values
                                            count:(uint32_t)(sizeof(values) / sizeof(int32_t))
                                     enumVerifier:AccreditReq_DeviceType_IsValidValue];
    if (!OSAtomicCompareAndSwapPtrBarrier(nil, worker, (void * volatile *)&descriptor)) {
      [worker release];
    }
  }
  return descriptor;
}

BOOL AccreditReq_DeviceType_IsValidValue(int32_t value__) {
  switch (value__) {
    case AccreditReq_DeviceType_Mobile:
    case AccreditReq_DeviceType_Pc:
      return YES;
    default:
      return NO;
  }
}

#pragma mark - AccreditRsp

@implementation AccreditRsp

@dynamic hasResultCode, resultCode;

typedef struct AccreditRsp__storage_ {
  uint32_t _has_storage_[1];
  AccreditRsp_ResultCode resultCode;
} AccreditRsp__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "resultCode",
        .dataTypeSpecific.enumDescFunc = AccreditRsp_ResultCode_EnumDescriptor,
        .number = AccreditRsp_FieldNumber_ResultCode,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(AccreditRsp__storage_, resultCode),
        .flags = (GPBFieldFlags)(GPBFieldRequired | GPBFieldTextFormatNameCustom | GPBFieldHasEnumDescriptor),
        .dataType = GPBDataTypeEnum,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[AccreditRsp class]
                                     rootClass:[AccreditMsgRoot class]
                                          file:AccreditMsgRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(AccreditRsp__storage_)
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

#pragma mark - Enum AccreditRsp_ResultCode

GPBEnumDescriptor *AccreditRsp_ResultCode_EnumDescriptor(void) {
  static GPBEnumDescriptor *descriptor = NULL;
  if (!descriptor) {
    static const char *valueNames =
        "Success\000Fail\000Responscode\000Canlogin\000";
    static const int32_t values[] = {
        AccreditRsp_ResultCode_Success,
        AccreditRsp_ResultCode_Fail,
        AccreditRsp_ResultCode_Responscode,
        AccreditRsp_ResultCode_Canlogin,
    };
    GPBEnumDescriptor *worker =
        [GPBEnumDescriptor allocDescriptorForName:GPBNSStringifySymbol(AccreditRsp_ResultCode)
                                       valueNames:valueNames
                                           values:values
                                            count:(uint32_t)(sizeof(values) / sizeof(int32_t))
                                     enumVerifier:AccreditRsp_ResultCode_IsValidValue];
    if (!OSAtomicCompareAndSwapPtrBarrier(nil, worker, (void * volatile *)&descriptor)) {
      [worker release];
    }
  }
  return descriptor;
}

BOOL AccreditRsp_ResultCode_IsValidValue(int32_t value__) {
  switch (value__) {
    case AccreditRsp_ResultCode_Success:
    case AccreditRsp_ResultCode_Fail:
    case AccreditRsp_ResultCode_Responscode:
    case AccreditRsp_ResultCode_Canlogin:
      return YES;
    default:
      return NO;
  }
}


#pragma clang diagnostic pop

// @@protoc_insertion_point(global_scope)
