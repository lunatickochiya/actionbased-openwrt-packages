diff --git a/luci-app-argon-config/htdocs/luci-static/resources/view/argon-config.js b/luci-app-argon-config/htdocs/luci-static/resources/view/argon-config.js
index e5c2d201..bc275745 100644
--- a/luci-app-argon-config/htdocs/luci-static/resources/view/argon-config.js
+++ b/luci-app-argon-config/htdocs/luci-static/resources/view/argon-config.js
@@ -52,6 +52,7 @@ return view.extend({
 		o = s.option(form.ListValue, 'online_wallpaper', _('Wallpaper source'));
 		o.value('none', _('Built-in'));
 		o.value('bing', _('Bing'));
+		o.value('ghser', _('ACG'));
 		o.value('unsplash', _('Unsplash'));
 		o.value('wallhaven', _('Wallhaven'));
 		o.default = 'bing';
diff --git a/luci-theme-argon/root/usr/libexec/argon/online_wallpaper b/luci-theme-argon/root/usr/libexec/argon/online_wallpaper
index 01bcae23..2309b03a 100755
--- a/luci-theme-argon/root/usr/libexec/argon/online_wallpaper
+++ b/luci-theme-argon/root/usr/libexec/argon/online_wallpaper
@@ -20,6 +20,9 @@ fetch_pic_url() {
             jsonfilter -qe '@.images[0].url')
         [ -n "${picpath}" ] && echo "//www.bing.com${picpath}"
         ;;
+	ghser)
+		echo "https://api.vvhan.com/api/wallpaper/acg"
+		;;
     unsplash)
         if [ -z "$API_KEY" ]; then
             curl -fks --max-time 3 \
