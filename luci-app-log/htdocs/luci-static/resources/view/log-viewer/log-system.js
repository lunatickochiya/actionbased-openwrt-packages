'use strict';
'require baseclass';
'require fs';
'require view.log-viewer.log-widget as widget';

return baseclass.extend({
	view: widget.view.extend({
		enableAutoRefresh: true,

		/**
		 * Pattern for picking application-specific entries from the log.
		 *
		 * @property {string} appPattern
		 */
		appPattern       : '^',

		/**
		 * Enable "tail" option for the logread (logread -l).
		 * Must be disabled for application-specific log.
		 *
		 * @property {bool} loggerTail
		 */
		loggerTail       : false,

		logdRegexp       : new RegExp(/^([^\s]{3}\s+[^\s]{3}\s+\d{1,2}\s+\d{1,2}:\d{1,2}:\d{1,2}\s+\d{4})\s+([a-z0-9]+)\.([a-z]+)\s+(.*)$/),

		syslog_ngRegexp  : new RegExp(/^([^\s]{3}\s+\d{1,2}\s+\d{1,2}:\d{1,2}:\d{1,2})\s+([^\s]+)\s+(.*)$/),

		entryRegexp      : null,

		loggerChecked    : false,

		entriesHandler   : null,

		logger           : null,

		getLogHash() {
			return this.getLogData(1, true).then(data => {
				return data || '';
			});
		},

		// logd
		logdHandler(strArray, lineNum) {
			return [
				lineNum,                               // #         (Number)
				strArray[1],                           // Timestamp (String)
				null,                                  // Host      (String)
				strArray[2],                           // Facility  (String)
				strArray[3],                           // Level     (String)
				this.htmlEntities(strArray[4]) || ' ', // Message   (String)
			];
		},

		// syslog-ng
		syslog_ngHandler(strArray, lineNum) {
			if(!(strArray[2] in this.logHosts)) {
				this.logHosts[strArray[2]] = this.makeLogHostsDropdownItem(strArray[2]);
			};
			return [
				lineNum,                               // #         (Number)
				strArray[1],                           // Timestamp (String)
				strArray[2],                           // Host      (String)
				null,                                  // Facility  (String)
				null,                                  // Level     (String)
				this.htmlEntities(strArray[3]) || ' ', // Message   (String)
			];
		},

		// unsupported log handler
		unsupportedLogHandler(line, lineNum) {
			return [
				lineNum,                        // #         (Number)
				null,                           // Timestamp (String)
				null,                           // Host      (String)
				null,                           // Facility  (String)
				null,                           // Level     (String)
				this.htmlEntities(line) || ' ', // Message   (String)
			];
		},

		checkLogread() {
			return Promise.all([
				L.resolveDefault(fs.stat('/sbin/logread'), null),
				L.resolveDefault(fs.stat('/usr/sbin/logread'), null),
			]).then(stat => {
				let logger = (stat[0]) ? stat[0].path : (stat[1]) ? stat[1].path : null;
				if(logger) {
					this.logger = logger;
				} else {
					throw new Error(_('Logread not found'));
				};
			});
		},

		async getLogData(tail, extraTstamp=false) {
			if(!this.logger) {
				await this.checkLogread();
			};
			let loggerArgs = [];
			if(this.loggerTail && tail) {
				loggerArgs.push('-l', String(tail));
			};
			loggerArgs.push('-e', this.appPattern);
			if(extraTstamp) {
				loggerArgs.push('-t');
			};
			return fs.exec_direct(this.logger, loggerArgs, 'text').catch(err => {
				throw new Error(_('Unable to load log data:') + ' ' + err.message);
			});
		},

		parseLogData(logdata, tail) {
			if(!logdata) {
				return [];
			};

			let strings = logdata.trim().split(/\n/);

			if(!this.loggerTail && tail && tail > 0 && strings) {
				strings = strings.slice(-tail);
			};

			this.totalLogLines = strings.length;

			let entriesArray = strings.map((e, i) => {
				if(!this.loggerChecked) {
					if(this.logdRegexp.test(e)) {
						this.entryRegexp       = this.logdRegexp;
						this.logTimestampFlag  = true;
						this.logFacilitiesFlag = true;
						this.logLevelsFlag     = true;
						this.logHostsFlag      = false;
						this.logHosts          = {};
						this.entriesHandler    = this.logdHandler;
						this.logCols           = [
							'#',
							_('Timestamp'),
							null,
							_('Facility'),
							_('Level'),
							_('Message'),
						];
						this.loggerChecked = true;
					}
					else if(this.syslog_ngRegexp.test(e)) {
						this.entryRegexp       = this.syslog_ngRegexp;
						this.logTimestampFlag  = true;
						this.logFacilitiesFlag = false;
						this.logLevelsFlag     = false;
						this.logHostsFlag      = true;
						this.logFacilities     = {};
						this.logLevels         = {};
						this.entriesHandler    = this.syslog_ngHandler;
						this.logCols           = [
							'#',
							_('Timestamp'),
							_('Host'),
							null,
							null,
							_('Message'),
						];
						this.loggerChecked = true;
					} else {
						return this.unsupportedLogHandler(e, i + 1);
					};
				};

				let strArray = e.match(this.entryRegexp);
				if(strArray) {
					return this.entriesHandler(strArray, i + 1);
				} else {
					return this.unsupportedLogHandler(e, i + 1);
				};
			});

			if(this.logSortingValue == 'desc') {
				entriesArray.reverse();
			};
			return entriesArray;
		},
	}),
});
