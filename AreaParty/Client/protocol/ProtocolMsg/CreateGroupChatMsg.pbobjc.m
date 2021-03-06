// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: CreateGroupChatMsg.proto

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

 #import "CreateGroupChatMsg.pbobjc.h"
 #import "ChatData.pbobjc.h"
// @@protoc_insertion_point(imports)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

#pragma mark - CreateGroupChatMsgRoot

@implementation CreateGroupChatMsgRoot

// No extensions in the file and none of the imports (direct or indirect)
// defined extensions, so no need to generate +extensionRegistry.

@end

#pragma mark - CreateGroupChatMsgRoot_FileDescriptor

static GPBFileDescriptor *CreateGroupChatMsgRoot_FileDescriptor(void) {
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

#pragma mark - CreateGroupChatReq

@implementation CreateGroupChatReq

@dynamic userIdArray, userIdArray_Count;
@dynamic hasGroupName, groupName;

typedef struct CreateGroupChatReq__storage_ {
  uint32_t _has_storage_[1];
  NSMutableArray *userIdArray;
  NSString *groupName;
} CreateGroupChatReq__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "userIdArray",
        .dataTypeSpecific.className = NULL,
        .number = CreateGroupChatReq_FieldNumber_UserIdArray,
        .hasIndex = GPBNoHasBit,
        .offset = (uint32_t)offsetof(CreateGroupChatReq__storage_, userIdArray),
        .flags = (GPBFieldFlags)(GPBFieldRepeated | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeString,
      },
      {
        .name = "groupName",
        .dataTypeSpecific.className = NULL,
        .number = CreateGroupChatReq_FieldNumber_GroupName,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(CreateGroupChatReq__storage_, groupName),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeString,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[CreateGroupChatReq class]
                                     rootClass:[CreateGroupChatMsgRoot class]
                                          file:CreateGroupChatMsgRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(CreateGroupChatReq__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
#if !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    static const char *extraTextFormatInfo =
        "\002\001\000userId\000\002\t\000";
    [localDescriptor setupExtraTextInfo:extraTextFormatInfo];
#endif  // !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - CreateGroupChatRsp

@implementation CreateGroupChatRsp

@dynamic hasResultCode, resultCode;
@dynamic hasGroupChatId, groupChatId;
@dynamic hasGroupName, groupName;

typedef struct CreateGroupChatRsp__storage_ {
  uint32_t _has_storage_[1];
  CreateGroupChatRsp_ResultCode resultCode;
  int32_t groupChatId;
  NSString *groupName;
} CreateGroupChatRsp__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "resultCode",
        .dataTypeSpecific.enumDescFunc = CreateGroupChatRsp_ResultCode_EnumDescriptor,
        .number = CreateGroupChatRsp_FieldNumber_ResultCode,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(CreateGroupChatRsp__storage_, resultCode),
        .flags = (GPBFieldFlags)(GPBFieldRequired | GPBFieldTextFormatNameCustom | GPBFieldHasEnumDescriptor),
        .dataType = GPBDataTypeEnum,
      },
      {
        .name = "groupChatId",
        .dataTypeSpecific.className = NULL,
        .number = CreateGroupChatRsp_FieldNumber_GroupChatId,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(CreateGroupChatRsp__storage_, groupChatId),
        .flags = (GPBFieldFlags)(GPBFieldRequired | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeInt32,
      },
      {
        .name = "groupName",
        .dataTypeSpecific.className = NULL,
        .number = CreateGroupChatRsp_FieldNumber_GroupName,
        .hasIndex = 2,
        .offset = (uint32_t)offsetof(CreateGroupChatRsp__storage_, groupName),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeString,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[CreateGroupChatRsp class]
                                     rootClass:[CreateGroupChatMsgRoot class]
                                          file:CreateGroupChatMsgRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(CreateGroupChatRsp__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
#if !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    static const char *extraTextFormatInfo =
        "\003\001\n\000\002\013\000\003\t\000";
    [localDescriptor setupExtraTextInfo:extraTextFormatInfo];
#endif  // !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - Enum CreateGroupChatRsp_ResultCode

GPBEnumDescriptor *CreateGroupChatRsp_ResultCode_EnumDescriptor(void) {
  static GPBEnumDescriptor *descriptor = NULL;
  if (!descriptor) {
    static const char *valueNames =
        "Success\000Fail\000";
    static const int32_t values[] = {
        CreateGroupChatRsp_ResultCode_Success,
        CreateGroupChatRsp_ResultCode_Fail,
    };
    GPBEnumDescriptor *worker =
        [GPBEnumDescriptor allocDescriptorForName:GPBNSStringifySymbol(CreateGroupChatRsp_ResultCode)
                                       valueNames:valueNames
                                           values:values
                                            count:(uint32_t)(sizeof(values) / sizeof(int32_t))
                                     enumVerifier:CreateGroupChatRsp_ResultCode_IsValidValue];
    if (!OSAtomicCompareAndSwapPtrBarrier(nil, worker, (void * volatile *)&descriptor)) {
      [worker release];
    }
  }
  return descriptor;
}

BOOL CreateGroupChatRsp_ResultCode_IsValidValue(int32_t value__) {
  switch (value__) {
    case CreateGroupChatRsp_ResultCode_Success:
    case CreateGroupChatRsp_ResultCode_Fail:
      return YES;
    default:
      return NO;
  }
}


#pragma clang diagnostic pop

// @@protoc_insertion_point(global_scope)
