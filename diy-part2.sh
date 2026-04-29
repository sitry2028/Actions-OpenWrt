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

# 1. 修改主机名 (从 ImmortalWrt 改为 TikTiok)
sed -i 's/ImmortalWrt/TikTiok/g' package/base-files/files/etc/board.json
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

# 4. 设置默认 root 密码为 tiktiok（首次启动生效）
cat > files/etc/uci-defaults/99-set-password <<'EOF'
#!/bin/sh
echo 'tiktiok' | passwd root
rm -f /etc/uci-defaults/99-set-password
exit 0
EOF
chmod +x files/etc/uci-defaults/99-set-password

# 5. 修改 LuCI 页脚信息：替换版本字符串和链接
find feeds/luci -name "footer.htm" -exec sed -i 's|ImmortalWrt [0-9]\{2\}\.[0-9]\{2\}-SNAPSHOT [^<]*|https://www.tiktiok.top|g' {} \;
find feeds/luci -name "footer.htm" -exec sed -i 's|https://github.com/openwrt/luci|https://www.tiktiok.top|g' {} \;

# 6. 手动克隆 passwall2 源码（绕过 feed 更新失败）
if [ ! -d package/luci-app-passwall2 ]; then
    git clone --depth 1 https://github.com/xiaorouji/openwrt-passwall2.git package/luci-app-passwall2 || {
        echo "Failed to clone passwall2, trying mirror..."
        git clone --depth 1 https://gitclone.com/github.com/xiaorouji/openwrt-passwall2.git package/luci-app-passwall2
    }
fi
