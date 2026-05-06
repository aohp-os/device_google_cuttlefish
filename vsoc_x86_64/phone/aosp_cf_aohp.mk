#
# Cuttlefish phone product with AOHP virtual-display policy and priv-app agent.
#

$(call inherit-product, device/google/cuttlefish/vsoc_x86_64/phone/aosp_cf.mk)

PRODUCT_NAME := aosp_cf_x86_64_phone_aohp

# Sparse F2FS userdata uses a code path that can require /dev/loop*; errno 13 (EACCES) is common if the
# build user is not in the "disk" group. Building a non-sparse userdata avoids that (full 8G file on disk).
TARGET_USERIMAGES_SPARSE_F2FS_DISABLED := true

# generic_system.mk registers a strict /system artifact path; AOHP adds these via Soong system image deps.
# Without an allow-list entry, artifact_path_requirements_verifier fails the build.
PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
    system/etc/permissions/privapp-permissions-aohp.xml \
    system/etc/permissions/privapp-permissions-aohp \
    system/priv-app/AOHPAgentDriver/AOHPAgentDriver.apk \
    system/priv-app/AohpSecurityConsent/AohpSecurityConsent.apk \
    system/app/MobileClawApp/MobileClawApp.apk \
    system/bin/aohp-containerd \
    system/etc/init/aohp-containerd.rc \
    system/etc/aohp/rootfs-templates/alpine.tar.gz \
    system/etc/aohp/cgroup.conf

# Soong-defined system image must list AOHP modules (see aosp_cf_aohp_system_image in generic/Android.bp).
PRODUCT_SOONG_DEFINED_SYSTEM_IMAGE := aosp_cf_aohp_system_image

# generic_system artifact-path rules: do not use PRODUCT_PROPERTY_OVERRIDES for ro.* (hits system);
# vendor default.prop is fine for read-only flags consumed by framework.
PRODUCT_VENDOR_PROPERTIES += ro.aohp.virtual_display_policy=true

# Kati install list must match Soong system image (file_list_diff).
PRODUCT_PACKAGES += \
    AOHPAgentDriver \
    AohpSecurityConsent \
    MobileClawApp \
    privapp-permissions-aohp \
    aohp-containerd \
    aohp-rootfs-alpine \
    aohp_cgroup_conf
