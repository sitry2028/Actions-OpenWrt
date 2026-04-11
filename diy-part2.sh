#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#
# Modify default IP
sed -i 's/192.168.1.1/192.168.99.1/g' package/base-files/files/bin/config_generate

# Modify device model
sed -i 's/"Zbtlink ZBT-Z8103AX"/"TikTok-803"/' target/linux/mediatek/dts/mt7981b-zbtlink-zbt-z8103ax.dts

# Fix UBI partition size (use 0x7280000)
sed -i 's/0x580000 0x4000000/0x580000 0x7280000/' target/linux/mediatek/dts/mt7981b-zbtlink-zbt-z8103ax.dts

# 替换页脚链接为 OpenWrt 官网
find feeds/luci -type f -name "*.htm" -o -name "*.lua" | xargs sed -i 's|https://p3terx.com|https://www.tiktiok.top|g'
find feeds/luci -type f -name "*.htm" -o -name "*.lua" | xargs sed -i 's|P3TERX|OpenWrt|g'
