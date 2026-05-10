#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

# 修改默认 IP
sed -i 's/192.168.1.1/192.168.99.1/g' package/base-files/files/bin/config_generate

# 修改设备型号
sed -i 's/"Zbtlink ZBT-Z8103AX"/"TikTiok-803D"/' target/linux/mediatek/dts/mt7981b-zbtlink-zbt-z8103ax.dts

# 修正 UBI 分区大小
sed -i 's/0x580000 0x4000000/0x580000 0x7280000/' target/linux/mediatek/dts/mt7981b-zbtlink-zbt-z8103ax.dts

# ========== 新增修改 ==========

# 1. 修改主机名 (从 ImmortalWrt 改为 TikTiok)
sed -i 's/ImmortalWrt/TikTiok/g' package/base-files/files/bin/config_generate

# 2. 创建 uci-defaults 目录
mkdir -p files/etc/uci-defaults

# 3. 修改无线 SSID (2.4G & 5G)
cat > files/etc/uci-defaults/98-set-wifi-ssid <<'EOF'
#!/bin/sh
uci set wireless.@wifi-iface[0].ssid='TikTiok'
uci set wireless.@wifi-iface[1].ssid='TikTiok'
uci commit wireless
wifi reload
exit 0
EOF
chmod +x files/etc/uci-defaults/98-set-wifi-ssid

# 4. 修改 LuCI 页脚：精确替换第一个链接（Powered by LuCI...），保留 Argon 和固件版本
# 处理 argon 主题
ARGO_FOOTER="feeds/luci/themes/luci-theme-argon/luasrc/view/themes/argon/footer.htm"
if [ -f "$ARGO_FOOTER" ]; then
    # 匹配包含 'class="luci-link"' 的行，将第一个 <a>...</a> 整体替换为自定义链接
    sed -i '/class="luci-link"/ { s|<a class="luci-link"[^>]*>.*</a>|<a href="https://www.tiktiok.top/" target="_blank">TikTiok学堂 · 跨境电商免费资源</a>| }' "$ARGO_FOOTER"
fi

# 处理 bootstrap 主题（作为备用，如果存在）
BOOT_FOOTER="feeds/luci/themes/luci-theme-bootstrap/luasrc/view/themes/bootstrap/footer.htm"
if [ -f "$BOOT_FOOTER" ]; then
    sed -i '/class="luci-link"/ { s|<a class="luci-link"[^>]*>.*</a>|<a href="https://www.tiktiok.top/" target="_blank">TikTiok学堂 · 跨境电商免费资源</a>| }' "$BOOT_FOOTER"
fi
