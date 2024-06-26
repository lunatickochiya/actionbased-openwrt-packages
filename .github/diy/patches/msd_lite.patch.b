From 31dfd43de0797db6002b01d31260e4c053eeeb65 Mon Sep 17 00:00:00 2001
From: lunatickochiya <125438787@qq.com>
Date: Sat, 9 Mar 2024 14:02:41 +0800
Subject: [PATCH] update msd_lite

---
 msd_lite/Makefile                             |   6 +-
 ...ugly-hack-to-allow-send-IGMP-MLD-lea.patch | 190 ------------------
 2 files changed, 3 insertions(+), 193 deletions(-)
 delete mode 100644 msd_lite/patches/010-Add-rejoin-option-as-ugly-hack-to-allow-send-IGMP-MLD-lea.patch

diff --git a/msd_lite/Makefile b/msd_lite/Makefile
index 5c901d19..791d3a7c 100644
--- a/msd_lite/Makefile
+++ b/msd_lite/Makefile
@@ -5,13 +5,13 @@
 include $(TOPDIR)/rules.mk
 
 PKG_NAME:=msd_lite
-PKG_RELEASE:=3
+PKG_RELEASE:=3
 
 PKG_SOURCE_PROTO:=git
 PKG_SOURCE_URL:=https://github.com/rozhuk-im/msd_lite.git
-PKG_SOURCE_DATE:=2023-02-17
+PKG_SOURCE_DATE:=2024-03-09
 PKG_SOURCE_VERSION:=744d2ef91797471e26b3b117e7aa0ffebbb91106
-PKG_MIRROR_HASH:=f4e8e3571fda1be758d7fedd10926badea661ca86477e0835b544b5174dc1dae
+PKG_MIRROR_HASH:=f4e8e3571fda1be758d7fedd10926badea661ca86477e0835b544b5174dc1dae
 
 PKG_MAINTAINER:=Tianling Shen <cnsztl@immrotalwrt.org>
 PKG_LICENSE:=BSD-2-Clause
diff --git a/msd_lite/patches/010-Add-rejoin-option-as-ugly-hack-to-allow-send-IGMP-MLD-lea.patch b/msd_lite/patches/010-Add-rejoin-option-as-ugly-hack-to-allow-send-IGMP-MLD-lea.patch
deleted file mode 100644
index 1e94d648..00000000
--- a/msd_lite/patches/010-Add-rejoin-option-as-ugly-hack-to-allow-send-IGMP-MLD-lea.patch
+++ /dev/null
@@ -1,190 +0,0 @@
-From afbe2d12e927973957d6d8dda50220014086934e Mon Sep 17 00:00:00 2001
-From: Rozhuk Ivan <rozhuk.im@gmail.com>
-Date: Thu, 9 Feb 2023 00:44:14 +0200
-Subject: [PATCH] Add rejoin option as ugly hack to allow send IGMP/MLD
- leave+join every X seconds
-
----
- README.md          |  2 +-
- conf/msd_lite.conf |  1 +
- src/msd_lite.c     | 35 +++++++++++++++++++++++++++++------
- src/stream_sys.c   | 15 ++++++++++++++-
- src/stream_sys.h   |  4 +++-
- 5 files changed, 48 insertions(+), 9 deletions(-)
-
---- a/README.md
-+++ b/README.md
-@@ -4,7 +4,7 @@
- [![Build-Ubuntu-latest Actions Status](https://github.com/rozhuk-im/msd_lite/workflows/build-ubuntu-latest/badge.svg)](https://github.com/rozhuk-im/msd_lite/actions)
- 
- 
--Rozhuk Ivan <rozhuk.im@gmail.com> 2011 - 2021
-+Rozhuk Ivan <rozhuk.im@gmail.com> 2011 - 2023
- 
- msd_lite - Multi stream daemon lite.
- This lightweight version of Multi Stream daemon (msd)
---- a/conf/msd_lite.conf
-+++ b/conf/msd_lite.conf
-@@ -73,6 +73,7 @@ available.
- 			</skt>
- 			<multicast> <!-- For: multicast-udp and multicast-udp-rtp. -->
- 				<ifName>vlan777</ifName> <!-- For multicast receive. -->
-+				<rejoinTime>0</rejoinTime> <!-- Do IGMP/MLD leave+join every X seconds. -->
- 			</multicast>
- 		</sourceProfile>
- 	</sourceProfileList>
---- a/src/msd_lite.c
-+++ b/src/msd_lite.c
-@@ -1,5 +1,5 @@
- /*-
-- * Copyright (c) 2012 - 2021 Rozhuk Ivan <rozhuk.im@gmail.com>
-+ * Copyright (c) 2012-2023 Rozhuk Ivan <rozhuk.im@gmail.com>
-  * All rights reserved.
-  *
-  * Redistribution and use in source and binary forms, with or without
-@@ -115,7 +115,8 @@ int		msd_http_srv_hub_attach(http_srv_cl
- 		    uint8_t *hub_name, size_t hub_name_size,
- 		    str_src_conn_params_p src_conn_params);
- uint32_t	msd_http_req_url_parse(http_srv_req_p req,
--		    struct sockaddr_storage *ssaddr, uint32_t *if_index,
-+		    struct sockaddr_storage *ssaddr,
-+		    uint32_t *if_index, uint32_t *rejoin_time,
- 		    uint8_t *hub_name, size_t hub_name_size,
- 		    size_t *hub_name_size_ret);
- 
-@@ -264,6 +265,9 @@ msd_src_conn_profile_load(const uint8_t
- 		if_name[MIN(IFNAMSIZ, tm)] = 0;
- 		((str_src_conn_mc_p)conn)->if_index = if_nametoindex(if_name);
- 	}
-+	xml_get_val_uint32_args(data, data_size, NULL,
-+	    &((str_src_conn_mc_p)conn)->rejoin_time,
-+	    (const uint8_t*)"multicast", "rejoinTime", NULL);
- 
- 	return (0);
- }
-@@ -521,11 +525,11 @@ msd_http_srv_hub_attach(http_srv_cli_p c
- 
- uint32_t
- msd_http_req_url_parse(http_srv_req_p req, struct sockaddr_storage *ssaddr,
--    uint32_t *if_index,
-+    uint32_t *if_index, uint32_t *rejoin_time,
-     uint8_t *hub_name, size_t hub_name_size, size_t *hub_name_size_ret) {
- 	const uint8_t *ptm;
- 	size_t tm;
--	uint32_t ifindex;
-+	uint32_t ifindex, rejointime;
- 	char straddr[STR_ADDR_LEN], ifname[(IFNAMSIZ + 1)];
- 	struct sockaddr_storage ss;
- 
-@@ -562,6 +566,19 @@ msd_http_req_url_parse(http_srv_req_p re
- 		if_indextoname(ifindex, ifname);
- 	}
- 
-+	/* rejoin_time. */
-+	if (0 == http_query_val_get(req->line.query, 
-+	    req->line.query_size, (const uint8_t*)"rejoin_time", 11,
-+	    &ptm, &tm)) {
-+		rejointime = ustr2u32(ptm, tm);
-+	} else { /* Default value. */
-+		if (NULL != if_index) {
-+			rejointime = (*rejoin_time);
-+		} else {
-+			rejointime = 0;
-+		}
-+	}
-+
- 	if (0 != sa_addr_port_to_str(&ss, straddr, sizeof(straddr), NULL))
- 		return (400);
- 	tm = (size_t)snprintf((char*)hub_name, hub_name_size,
-@@ -572,6 +589,9 @@ msd_http_req_url_parse(http_srv_req_p re
- 	if (NULL != if_index) {
- 		(*if_index) = ifindex;
- 	}
-+	if (NULL != rejoin_time) {
-+		(*rejoin_time) = rejointime;
-+	}
- 	if (NULL != hub_name_size_ret) {
- 		(*hub_name_size_ret) = tm;
- 	}
-@@ -641,8 +661,11 @@ msd_http_srv_on_req_rcv_cb(http_srv_cli_
- 		/* Default value. */
- 		memcpy(&src_conn_params, &g_data.src_conn_params, sizeof(str_src_conn_mc_t));
- 		/* Get multicast address, ifindex, hub name. */
--		resp->status_code = msd_http_req_url_parse(req, &src_conn_params.udp.addr,
--		    &src_conn_params.mc.if_index, buf, sizeof(buf), &buf_size);
-+		resp->status_code = msd_http_req_url_parse(req,
-+		    &src_conn_params.udp.addr,
-+		    &src_conn_params.mc.if_index,
-+		    &src_conn_params.mc.rejoin_time,
-+		    buf, sizeof(buf), &buf_size);
- 		if (200 != resp->status_code)
- 			return (HTTP_SRV_CB_CONTINUE);
- 		if (HTTP_REQ_METHOD_HEAD == req->line.method_code) {
---- a/src/stream_sys.c
-+++ b/src/stream_sys.c
-@@ -1,5 +1,5 @@
- /*-
-- * Copyright (c) 2012 - 2021 Rozhuk Ivan <rozhuk.im@gmail.com>
-+ * Copyright (c) 2012-2023 Rozhuk Ivan <rozhuk.im@gmail.com>
-  * All rights reserved.
-  *
-  * Redistribution and use in source and binary forms, with or without
-@@ -168,6 +168,7 @@ str_src_conn_def(str_src_conn_params_p s
- 		return;
- 	mem_bzero(src_conn_params, sizeof(str_src_conn_params_t));
- 	src_conn_params->mc.if_index = STR_SRC_CONN_DEF_IFINDEX;
-+	src_conn_params->mc.rejoin_time = 0;
- }
- 
- 
-@@ -376,6 +377,7 @@ str_hubs_bckt_stat_summary(str_hubs_bckt
- void
- str_hubs_bckt_timer_service(str_hubs_bckt_p shbskt, str_hub_p str_hub,
-     str_hubs_stat_p stat) {
-+	int error;
- 	str_src_settings_p src_params = &shbskt->src_params;
- 	struct timespec *tp = &shbskt->tp_last_tmr_next;
- 	uint64_t tm64;
-@@ -415,6 +417,17 @@ str_hubs_bckt_timer_service(str_hubs_bck
- 			return;
- 		}
- 	}
-+	/* Re join multicast group timer. */
-+	if (0 != str_hub->src_conn_params.mc.rejoin_time &&
-+	    str_hub->next_rejoin_time < tp->tv_sec) {
-+		str_hub->next_rejoin_time = (tp->tv_sec + (time_t)str_hub->src_conn_params.mc.rejoin_time);
-+		for (int join = 0; join < 2; join ++) {
-+		    error = skt_mc_join(tp_task_ident_get(str_hub->tptask), join,
-+			str_hub->src_conn_params.mc.if_index,
-+			&str_hub->src_conn_params.mc.udp.addr);
-+		    LOG_ERR(error, "skt_mc_join()");
-+		}
-+	}
- }
- static void
- str_hubs_bckt_timer_msg_cb(tpt_p tpt, void *udata) {
---- a/src/stream_sys.h
-+++ b/src/stream_sys.h
-@@ -1,5 +1,5 @@
- /*-
-- * Copyright (c) 2012 - 2021 Rozhuk Ivan <rozhuk.im@gmail.com>
-+ * Copyright (c) 2012-2023 Rozhuk Ivan <rozhuk.im@gmail.com>
-  * All rights reserved.
-  *
-  * Redistribution and use in source and binary forms, with or without
-@@ -114,6 +114,7 @@ typedef struct str_src_conn_udp_s {
- typedef struct str_src_conn_mc_s {
- 	str_src_conn_udp_t udp;
- 	uint32_t	if_index;
-+	uint32_t	rejoin_time;
- } str_src_conn_mc_t, *str_src_conn_mc_p;
- #define STR_SRC_CONN_DEF_IFINDEX	((uint32_t)-1)
- 
-@@ -160,6 +161,7 @@ typedef struct str_hub_s {
- #ifdef __linux__ /* Linux specific code. */
- 	size_t		r_buf_rcvd;	/* Ring buf LOWAT emulator. */
- #endif /* Linux specific code. */
-+	time_t		next_rejoin_time; /* Next time to send leave+join. */
- 
- 	tpt_p		tpt;		/* Thread data for all IO operations. */
- 	str_src_conn_params_t src_conn_params;	/* Point to str_src_conn_XXX */
-- 
2.34.1

