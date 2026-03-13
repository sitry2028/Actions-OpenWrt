#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#
# Copyright (c) 2019-2024 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#

# Modify default IP
#sed -i 's/192.168.1.1/192.168.50.5/g' package/base-files/files/bin/config_generate

# Modify default theme
#sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile

# Modify hostname
#sed -i 's/OpenWrt/P3TERX-Router/g' package/base-files/files/bin/config_generate
# 修改默认 IP 为 192.168.99.1
sed -i 's/192.168.1.1/192.168.99.1/g' package/base-files/files/bin/config_generate

# 修改设备型号为 TikTok-803（修改设备树中的 model 字段）
sed -i 's/"Zbtlink ZBT-Z8103AX"/"TikTok-803"/' target/linux/mediatek/dts/mt7981b-zbtlink-zbt-z8103ax.dts

# 修改 UBI 分区大小为障眼法值（之前已添加，但确保存在）
sed -i 's/0x580000 0x4000000/0x580000 0x20000000/' target/linux/mediatek/dts/mt7981b-zbtlink-zbt-z8103ax.dts

