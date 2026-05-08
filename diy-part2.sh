#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

# 修改默认 IP
sed -i 's/192.168.1.1/192.168.99.1/g' package/base-files/files/bin/config_generate

# 修改设备型号
sed -i 's/"Zbtlink ZBT-Z8103AX"/"TikTiok-803"/' target/linux/mediatek/dts/mt7981b-zbtlink-zbt-z8103ax.dts

# 修正 UBI 分区大小
sed -i 's/0x580000 0x4000000/0x580000 0x7280000/' target/linux/mediatek/dts/mt7981b-zbtlink-zbt-z8103ax.dts

# ========== 新增修改 ==========

# 1. 修改主机名 (从 ImmortalWrt 改为 TikTiok) – 只修改 config_generate 即可
sed -i 's/ImmortalWrt/TikTiok/g' package/base-files/files/bin/config_generate

# 2. 创建 uci-defaults 目录
mkdir -p files/etc/uci-defaults

# 3. 修改无线 SSID (2.4G & 5G) – 首次启动时自动设置
cat > files/etc/uci-defaults/98-set-wifi-ssid <<'EOF'
#!/bin/sh
uci set wireless.@wifi-iface[0].ssid='TikTiok'
uci set wireless.@wifi-iface[1].ssid='TikTiok'
uci commit wireless
wifi reload
exit 0
EOF
chmod +x files/etc/uci-defaults/98-set-wifi-ssid

# 4. 修改 LuCI 页脚：替换为自定义链接（直接覆盖 footer 文件）
find feeds/luci -path "*/themes/*/footer.htm" -exec sh -c 'echo "<a href=\"https://www.tiktiok.top/\" target=\"_blank\">TikTiok学堂免费资源</a>" > $0' {} \;
