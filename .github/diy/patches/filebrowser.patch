diff --git a/filebrowser/Makefile b/filebrowser/Makefile
index 7b6612c5..a81352ac 100644
--- a/filebrowser/Makefile
+++ b/filebrowser/Makefile
@@ -19,11 +19,12 @@ PKG_MAINTAINER:=Tianling Shen <cnsztl@immortalwrt.org>
 PKG_BUILD_DEPENDS:=golang/host node/host
 PKG_BUILD_PARALLEL:=1
 PKG_BUILD_FLAGS:=no-mips16
+PKG_USE_MIPS16:=0
 
-GO_PKG:=github.com/filebrowser/filebrowser/v2
+GO_PKG:=github.com/filebrowser/filebrowser
 GO_PKG_LDFLAGS_X:= \
-	$(GO_PKG)/version.CommitSHA=$(PKG_VERSION) \
-	$(GO_PKG)/version.Version=v$(PKG_VERSION)
+	$(GO_PKG)/v2/version.CommitSHA=$(PKG_VERSION) \
+	$(GO_PKG)/v2/version.Version=v$(PKG_VERSION)
 
 include $(INCLUDE_DIR)/package.mk
 include ../../lang/golang/golang-package.mk
@@ -52,7 +53,8 @@ define Build/Compile
 	( \
 		pushd "$(PKG_BUILD_DIR)/frontend" ; \
 		npm ci; \
-		NODE_OPTIONS=--openssl-legacy-provider npm run build ; \
+		npm run lint ; \
+		npm run build ; \
 		popd ; \
 		$(call GoPackage/Build/Compile) ; \
 	)
