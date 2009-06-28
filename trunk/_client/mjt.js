/*
 *  mjt.js - a metaweb javascript template engine
 *
 */

if (typeof mjt == 'undefined')
    mjt = {};

mjt.NAME = 'mjt';
mjt.VERSION = '0.5.1';
// mjt.WEBSITE = 'http://mjtemplate.org';
mjt.LICENSE =
"========================================================================\n"+
"Copyright (c) 2007, Metaweb Technologies, Inc.\n"+
"All rights reserved.\n"+
"\n"+
"Redistribution and use in source and binary forms, with or without\n"+
"modification, are permitted provided that the following conditions\n"+
"are met:\n"+
"    * Redistributions of source code must retain the above copyright\n"+
"      notice, this list of conditions and the following disclaimer.\n"+
"    * Redistributions in binary form must reproduce the above\n"+
"      copyright notice, this list of conditions and the following\n"+
"      disclaimer in the documentation and/or other materials provided\n"+
"      with the distribution.\n"+
"\n"+
"THIS SOFTWARE IS PROVIDED BY METAWEB TECHNOLOGIES ``AS IS'' AND ANY\n"+
"EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE\n"+
"IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR\n"+
"PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL METAWEB TECHNOLOGIES BE\n"+
"LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR\n"+
"CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF\n"+
"SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR\n"+
"BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,\n"+
"WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE\n"+
"OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN\n"+
"IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.\n"+
"========================================================================\n";

/**
 * url of the freebase service
 */
mjt.default_service_url = 'http://www.freebase.com';
/**
 * the service we're using.  this can be set using
 *  mjt.server=localhost
 *  (or whatever) in the url query
 */
mjt.service_url = mjt.default_service_url;
/**
 * this can be set using
 *  mjt.debug=1
 * in the url query
 */
mjt.debug = 0;

/**
 * unique object passed to the callback to indicate timeout failure
 */
mjt._timeout_token = '***mjt_timeout***';
/**
 * this is used as a dispatch mechanism both for
 *  <script src=""> callbacks and for dom event
 *  handlers.
 */
mjt._cb = {};

mjt._timeouts = {};

mjt._elements = null;
/**
 * this is used to generate temporary variables
 */
mjt.next_unique_id = {};
mjt.uniqueid = function (prefix) {
    var id = mjt.next_unique_id[prefix];
    if (typeof id !== 'number')
        id = 1;
    mjt.next_unique_id[prefix] = id + 1;

    return '_' + prefix + '__' + id;
};

//////////////////////////////////////////////////////////////////////
//
//  debug output functions
//
//


if (typeof console != 'undefined' && typeof console.debug == 'function') {
    // firefox with firebug, or other with firebug lite
    mjt.error    = function () {
        console.error.apply(console, arguments);
        return '';
    };
    mjt.warn     = function () {
        console.warn.apply(console, arguments);
        return '';
    };
    mjt.log      = function () {
        console.log.apply(console, arguments);
        return '';
    };
    mjt.note     = function () {
        if (mjt.debug)
            console.log.apply(console, arguments);
        return '';
    };
    mjt.openlog  = function () {
        if (mjt.debug)
            console.group.apply(console, arguments);
        return '';
    };
    mjt.closelog = function () {
        if (mjt.debug)
            console.groupEnd.apply(console, arguments);
        return '';
    };

} else {
    // other, including safari 2's botched console.log
    mjt.error    = function () { mjt.spew('error', arguments); return '';};
    mjt.warn     = function () { mjt.spew('warning', arguments);  return '';};
    mjt.log      = function () { return ''; };
    mjt.note     = function () { return ''; };
    mjt.openlog  = function () { return ''; };
    mjt.closelog = function () { return ''; };
}


/**
 * debug logging utility
 *  the argument processing should be rationalized here,
 *  and it should become an internal function.
 */
mjt.spew = function (msg, args) {
    var output = document.createElement('div');
    var tag;
    var text;

    tag = document.createElement('h3');
    tag.style.backgroundColor = '#fff0f0';
    tag.appendChild(document.createTextNode(msg));
    output.appendChild(tag);

    for (var ai = 0; ai < args.length; ai++) {
        var value = args[ai];

        if (value instanceof Array) {
            tag = document.createElement('div');
            tag.innerHTML = mjt.flatten_markup(value);
            output.appendChild(tag);
            continue;
        }

        tag = document.createElement('pre');

        if (typeof(value) == 'string') {
            text = value; 
        } else {
            // try to format each arg as json if possible
            try {
                text = mjt.json_from_js(value);
            } catch (e) {
                text = '' + value;
            }
        }

        text = text.replace(/\r?\n/g, '\r\n');
        tag.appendChild(document.createTextNode(text));
        output.appendChild(tag);
    }

    var container = document.getElementById('mjt_debug_output');
    if (!container)
        container = document.getElementsByTagName('body')[0];
    container.appendChild(output);
}

/**
 * the list of characters that are ok in uris.
 * this set is ok for query args and fragment.
 * also for url subpath (not a single path segment - note '/' is considered ok)
 */
mjt._uri_ok = {
        '~': true,  '!': true,  '*': true,  '(': true,  ')': true,
        '-': true,  '_': true,  '.': true,  ',': true,
        ':': true,  '@': true,  '$': true,
        "'": true,  '/': true
};

/**
 * this is like encodeURIComponent() but quotes fewer characters.
 * encodeURIComponent passes   ~!*()-_.'
 * mjt.formquote also passes   ,:@$/
 */
mjt.formquote = function(x) {
    // speedups todo:
    //   regex match exact set of uri_ok chars.
    //   chunking series of unsafe chars rather than encoding char-by-char
    var ok = mjt._uri_ok;

    if (/^[A-Za-z0-9_-]*$/.test(x))  // XXX add more safe chars
        return x;

    x = x.replace(/([^A-Za-z0-9_-])/g, function(a, b) {
        var c = ok[b];
        if (c) return b;

        return encodeURIComponent(b);
    });
    return x.replace(/%20/g, '+');
};


/**
 * generate a www-form-urlencoded string from a dictionary
 *  undefined values are skipped, but empty-string is included.
 */
mjt.formencode = function(values) {
    var qtext = [];
    var sep = '';
    var k, v, ki, ks = [];

    // keys are sorted for cache-friendliness
    for (k in values)
        ks.push(k);
    ks.sort();

    for (ki in ks) {
        k = ks[ki];
        v = values[k];
        if (typeof v == 'undefined') continue;

        qtext.push(sep);
        sep = '&';
        qtext.push(mjt.formquote(k));
        qtext.push('=');
        qtext.push(mjt.formquote(v));
    }
    return qtext.join('');
};

/**
 * parse a www-form-urlencoded string into a dict
 */
mjt.formdecode = function (qstr) {
    if (typeof qstr == 'undefined' || qstr == '')
        return {};

    var qdict = {};
    var qpairs = qstr.split('&');
    for (var i = 0; i < qpairs.length; i++) {
        var m = /^([^=]+)=(.*)$/.exec(qpairs[i]);

        if (!m) {
            mjt.warn('bad uri query argument, missing "="', qpairs[i]);
            continue;
        }

        // decodeURIComponent doesnt handle +
        var k = decodeURIComponent(m[1].replace(/\+/g,' '));
        var v = decodeURIComponent(m[2].replace(/\+/g,' '));
        qdict[k] = v;
    }
    return qdict;
};

/**
 * create a GET url from a base url and form values
 */
mjt.form_url = function(base, values) {
    var q = values && mjt.formencode(values);
    if (q == '')
        return base;
    return base + '?' + mjt.formencode(values);
};

mjt.short_server_name = function (server) {
    if (typeof server == 'undefined')
        server = mjt.service_url;

    if (server == mjt.default_service_url)
        return undefined;

    server = server.replace(/^http:\/\//, '');

    if (server == window.location.host)
        return '.';
    return server;
};

mjt.form_mjt_url = function(base, values) {
    var mjtvalues = {}
    mjtvalues['mjt.server'] = mjt.short_server_name();
    if (mjt.debug)
        mjtvalues['mjt.debug'] = '' + mjt.debug;

    var args = mjt.formencode(mjtvalues);
    if (args != '')
        args = '&' + args;
    return base + '?' + mjt.formencode(values) + args;
}


//////////////////////////////////////////////////////////////////////

/**
 * parse the query and fragment sections of the url, if present.
 *   sets mjt.debug if there is a mjt.debug=1 argument
 *   sets mjt.service_url if there is a mjt.server=... argument
 */
mjt.parse_url = function () {
    var qstr = window.location.search;
    var qd = {};
    if (typeof(qstr) == 'string' && qstr.length > 0 && qstr.charAt(0) == '?')
        qd = mjt.formdecode(qstr.substr(1));
    mjt.urlquery = qd;

    if (typeof qd['mjt.debug'] != 'undefined' && qd['mjt.debug'])
        mjt.debug = 1;

    if (typeof qd['mjt.server'] != 'undefined') {
        var server = qd['mjt.server'];
        if (server.substr(0,4) == 'http')
            mjt.service_url = server;
        else if (server == '.')
            mjt.service_url = window.location.protocol + '//'
                            + window.location.host;
        else
            mjt.service_url = 'http://' + server;
    }

    qstr = window.location.hash;
    qd = {};
    if (typeof(qstr) == 'string')
        qd = mjt.formdecode(qstr);
    mjt.urlfragment = qd;
};


// note this is evaluated on <script src="mjt.js"> load
// - it reads the url and parses the ? and # sections
mjt.urlquery = null;
mjt.urlfragment = null;
mjt.parse_url();


//////////////////////////////////////////////////////////////////////

mjt.TaskPrivate = function (task) {
    this.task = task;  // backlink
    this.listeners = [];
    this.tcalls = [];
    this.tid = mjt.TaskPrivate._next_tid++;
};
mjt.TaskPrivate._next_tid = 1;
mjt.TaskPrivate.prototype.register = function (cb) {
    this.listeners.push(cb);
};
mjt.TaskPrivate.prototype.notify = function (task) {
    //mjt.log('task notify', this.task)
    for (var k in this.listeners) {
        var cb = this.listeners[k];
        cb(task);
    }
};
mjt.TaskPrivate.prototype.toMarkup = function () {
    return '<span class="mjt_task">task '
        + this.tid + ':' + this.task.state + '</span>';
};


mjt.Task = function() {
    this.state = 'init';
    this._ = new mjt.TaskPrivate(this);
};

mjt.notify = function(task) {
    // backwards compat
    task._.notify(task);
};

mjt.enqueue = function(task) {
    if (task.state == 'init') {
        task.state = 'wait';
        task.enqueue();
    }
};




//////////////////////////////////////////////////////////////////////

/**
 * wrapper for window.setTimeout() that handles closures
 *  with a table.  this may not be necessary, but it helps
 *  with nervousness about IE memory leaks.
 */
mjt.setTimeout = function (cb, msec) {
    // TODO use mjt._cb and get rid of mjt._timeouts
    var tid = mjt.uniqueid('timeout');
    mjt._timeouts[tid] = function() {
        delete mjt._timeouts[tid];

        mjt.openlog('timeout', cb);
        try {
            cb();
        } finally {
            mjt.closelog();
        }
    };

    var tok = window.setTimeout('mjt._timeouts.' + tid + '()', msec);

    return tok;
};

mjt.dynamic_script = function (tag_id, url, text) {
    var head = document.getElementsByTagName('head')[0];
    var tag = document.createElement('script');
    tag.type = 'text/javascript';
    if (typeof tag_id == 'string')
        tag.id = tag_id;
    if (typeof url !== 'undefined')
        tag.src = url;
    if (typeof text !== 'undefined') {
        // see http://tobielangel.com/2007/2/23/to-eval-or-not-to-eval
        if(/WebKit|Khtml/i.test(navigator.userAgent))
            throw Error('safari doesnt evaluate dynamic script text');
        tag.text = text;
    }

    head.appendChild(tag);
    return tag;
};




mjt._script_timeout = 10000;

mjt.already_gave_up = function (response) {
    mjt.note('mjt task completed after timeout');
};

/**
 * apply a function, trapping exceptions
 */
mjt.apply_safe = function (func, thiss, args) {
    mjt.openlog('apply_safe', func, args);

    // add catch handler
    //  - look for func.signature and other useful info
    //  - interact better with firebug?

    try {
        return func.apply(thiss, args);
    } finally {
        mjt.closelog();
    }
};

mjt.callback_script_get = function (urlbase, path, form, cb, cbkey) {
    //mjt.log('creating <script>');

    var script_tag_id = mjt.uniqueid('mjt_script');
    var cbid;
    var timer = undefined;

    var urlquery = mjt.formencode(form);

    /* using a random callback string in the uri defeats caching, so
     * hash the the query to create the callback, if we have a mjt.hash().
     * some queries could skip .state='wait' because of this?
     * and of course you need some way to flush the cache besides "reload" */
    if (typeof mjt.hash == 'function') {
        cbid = 'c' + mjt.hash(path + urlquery);
        var cbsaved = mjt._cb[cbid];

        // check that we don't have a hash collision.
        // if we do, we can fallback to mjt.uniqueid() without loss
        // of correctness, we just lose the cacheability.
        if (typeof cbsaved == 'function') {
            var cached = cbsaved._cached_result;

            if (typeof cached === 'undefined') {
                cbsaved._pending.push(cb);
                return;
            } else {
                // XXX should check url too, if mjt._cb is a cache...
                //  need to extend cache entry to:
                //  [ { url: url, result: result }, ... ]
                //mjt.log('scriptget cached', cbid);
                mjt.apply_safe(cb, window, cached)
                return;
            }

            // in the case of a hash collision we have to
            // suffer a bit.  it would be nice to re-use
            // mjt._cb[cbid] for multiple responses, but there's
            // no good way to tell that the responses came from
            // a particular url.  so we have to generate a fresh
            // callback.  right now the colliding query isn't
            // really cacheable - that could be fixed by rehashing
            // instead of bailing to mjt.uniqueid()

            mjt.log('repeated hash?', cbid, form);
            // XXX should check url and hook this cb onto the
            //   existing query if possible
            // use a fresh cb and fall through
            cbid = mjt.uniqueid('cb');
        } else if (typeof cbsaved == 'undefined') {
            // create a new one below
        }
    } else {
        cbid = mjt.uniqueid('cb');
    }

    // this is what gets called by a generated script response
    // captures timer and cbid vars.
    // function object is decorated with _pending
    mjt._cb[cbid] = function (possible_timeout_token) {
        // we distinguish timeouts using a special value passed
        // to the callback
        if (possible_timeout_token == mjt._timeout_token) {
            timer = undefined;

            // we're giving up, but a reply may still arrive.
            // if so we have to throw it away since we don't
            //  allow a error->ready transitions.
            // so replace the callback with a function that does
            //  nothing.
            if (cbid in mjt._cb)
                mjt._cb[cbid] = mjt.already_gave_up;
        }

        // clean up the request timeout if this is a normal completion
        if (typeof(timer) != 'undefined') {
            clearTimeout(timer);
            timer = undefined;
        }

        // pass all arguments through to the callback
        // XXX note this copy of the arguments array is shared
        //  across requests, should it be deepcopied?
        for (var cached=[], i=0; i < arguments.length; i++)
            cached[i] = arguments[i];
        //mjt.log('scriptget complete', cbid, cached);

        // create a fresh function object and save the response in
        // a cache property on the function.
        mjt._cb[cbid] = function () {
            mjt.log('this result has already arrived or timed out');
        };

        mjt._cb[cbid]._cached_result = cached;

        var pending = arguments.callee._pending;
        for (var cbi = 0; cbi < pending.length; cbi++) {
            //mjt.log('firing pending task for ' + cbid + ': ' + pending[cbi]);
            mjt.apply_safe(pending[cbi], window, cached);
        }
    };
    // track dependencies on the result while it is fetching.
    mjt._cb[cbid]._pending = [cb];

    var timeout_code = '(mjt._cb.' + cbid
        + ' || function(){return "";})'
        + '(mjt._timeout_token);';
    timer = window.setTimeout(timeout_code, mjt._script_timeout);

    if (typeof cbkey == 'undefined')
        cbkey = 'callback';

    if (urlquery === '')
        urlquery = cbkey + '=mjt._cb.' + cbid;
    else
        urlquery += '&' + cbkey + '=mjt._cb.' + cbid;

    //mjt.note('scriptget', cbid);

    mjt.dynamic_script(script_tag_id, urlbase + path + '?' + urlquery);
};

/**
 * hopefully browser-independent function to generate a
 * dynamic <script> tag with completion callback.
 * this is needed when we don't get to send a callback= parameter.
 * i don't think this method reports http errors though.
 *
 * original from:
 *   http://www.phpied.com/javascript-include-ready-onload/
 * safari iframe hack from:
 *   http://pnomolos.com/article/5/dynamic-include-of-javascript-in-safari
 * added completion function and hopeful safari future-proofing
 *
 */
mjt.include_js_async = function (url, k) {
    var js = mjt.dynamic_script(null, url);

    // Safari doesn't fire onload= on script tags.  This hack from
    // loads the script into an iframe too, and assumes that the
    // <script> will finish before the onload= fires on the iframe.
    if(/WebKit|Khtml/i.test(navigator.userAgent)) {
        var iframe = mjt.dynamic_iframe();
        // Fires in Safari
        iframe.onload = k;
        document.getElementsByTagName('body')[0].appendChild(iframe);
    } else {
        // Fires in IE, also modified the test to cover both states
        js.onreadystatechange = function () {
            if (/complete|loaded/.test(js.readyState))
                k();
        }
        // Fires in FF
        // (apparently recent versions of webkit may fire this too - nix)
        js.onload = k;
    }
};

mjt.dynamic_iframe = function (id, url) {
    var iframe = document.createElement('iframe');
    if (typeof id == 'string')
        iframe.id = id;
    iframe.style.display = 'none';
    iframe.className = 'mjt_dynamic';
    iframe.setAttribute('src', url);
    //mjt.log('created iframe src=', url, iframe.id);
    return iframe;
};

/**
 *
 * load an url into an <iframe>
 *   k is called with a single argument, the <iframe> element
 *
 */
mjt.dynamic_iframe_async = function (url, k) {
    var iframe = mjt.dynamic_iframe(mjt.uniqueid('mjt_iframe'), url);
    iframe.onload = function () {
        // works on firefox and hopefully safari
        k(iframe);
    };
    iframe.onreadystatechange = function () {
        // works on ie6
        if (iframe.readyState == 'complete') {
            k(iframe);
        }
    }
    document.getElementsByTagName('body')[0].appendChild(iframe);
};

//////////////////////////////////////////////////////////////////////

mjt.task_timeout = function (task) {
    task.state = 'error';

    var response = {
        status: "503 Service unavailable",
        code: '/user/mjt/messages/script_timeout',
        messages: [{
            code: '/user/mjt/messages/script_timeout',
            message: "browser could not contact the server",

            // XXX deprecated fields
            type: '/user/mjt/messages/script_timeout',
            text: "browser could not contact the server",
            level: 'error'
        }]};
    task.envelope = response;
    task.messages = response.messages;
    mjt.notify(task);
};

mjt.task_empty_result = function (task) {
    return mjt.task_error(task,
                          '/user/mjt/messages/empty_result',
                          'no results found');
};

mjt.task_error = function (task, errtype, messages) {
    task.state = 'error';

    if (! (messages instanceof Array)) {
        messages = [{
            code: errtype,
            message: messages,

            // XXX deprecated fields
            type: errtype,
            text: messages,
            level: 'error'
        }];
    }

    var response = {
        messages: messages
    };

    task.envelope = response;
    task.messages = messages;
    mjt.notify(task);
};

mjt.task_ready = function (task, result) {
    task.state = 'ready';
    task.result = result;
    mjt.notify(task);
};



/**
 *
 * handle a query response.
 *
 */
mjt.parse_metaweb_script_response = function(task, o) {
    if (typeof(o) == 'string' && o == mjt._timeout_token) {
        mjt.task_timeout(task);
        return;
    }

    task.envelope = o;

    if (o.status !== '200 OK') {
        mjt.task_error(task, o.code, o.messages);
        return;
    }

    task.state = 'ready';
    task.result = o.result;
    mjt.notify(task);
};


mjt.MqlReadTask = function(query, args) {
    mjt.Task.apply(this);
    this.query = query;
    if (typeof args == 'undefined')
        this.args = {};
    else
        this.args = args;
    
};

//mjt.MqlReadTask.prototype = new mjt.Task;

/**
 * note this is not on the prototype
 */
mjt.MqlReadTask.send_queued = function() {
    var batchq = mjt.MqlReadTask._in_preparation;
    if (!batchq)
        return;
    mjt.MqlReadTask._in_preparation = false;

    // fire off the query immediately for now
    batchq.send_query();
};

mjt.MqlReadTask.prototype.enqueue = function() {
    var query = mjt.MqlReadTask._in_preparation;
    if (!query) {
        query = new mjt.MqlReadRequest();
        mjt.MqlReadTask._in_preparation = query;
    }

    var qk = 'c' + query.nsubqueries++;
    query.subqueries[qk] = this;

    // this.result is undefined until state=ready

    // save result envelope as this.envelope?

    // XXX dont batch requests for now
    mjt.MqlReadTask.send_queued();
};

/**
 * create a mqlread task
 */
mjt.mqlread = function(q, args) {
    return new mjt.MqlReadTask(q, args);
};



/**
 *
 *  a MqlReadRequest represents an HTTP request to the mqlread service,
 *   which may aggregate multiple MqlReadTasks.
 *  XXX should aggregate less when hitting to deal with url
 *   length limitations.
 *
 */
mjt.MqlReadRequest = function () {
    mjt.Task.apply(this, []);

    // each subquery is a mjt.MqlReadTask
    this.subqueries = {};
    this.nsubqueries = 0;
};

/**
 * send a query:
 *  - create a custom callback handler
 *  - create a dynamic <script> tag that fetches a json response
 *
 */
mjt.MqlReadRequest.prototype.send_query = function () {
    // build the complete query string from all the subqueries.
    var qenv = {};
    for (var sqi in this.subqueries) {
        var sq = this.subqueries[sqi];
        qenv[sqi] = { query: sq.query,
                      escape: false };
        if (typeof sq.args.cursor != 'undefined')
            qenv[sqi].cursor = sq.args.cursor;
        else if (sq.query instanceof Array)
            qenv[sqi].cursor = true;  // always ask for it
    }
    var s = mjt.json_from_js(qenv);

    var req = this;  // for closure
    mjt.callback_script_get(mjt.service_url, '/api/service/mqlread',
                            { queries: s },
                            function (o) {
                                req.response_handler(o);
                            });
/* 
    // request a redraw, but yield first, in case some data
    //  has already arrived.
    var batchq = this;
    mjt.setTimeout(function() { batchq.notify(); }, 50);
*/
};

mjt.MqlReadRequest.prototype.notify = function () {
    // notify all dependents
    for (var sqk in this.subqueries) {
        var sq = this.subqueries[sqk];
        mjt.notify(sq);
    }
};


/**
 *
 * handle a query response.
 *   do most of the work for all json callback handlers
 *
 */
mjt.MqlReadRequest.prototype.response_handler = function(o) {
    var subtask_key;

    if (typeof(o) == 'string' && o == mjt._timeout_token) {
        for (subtask_key in this.subqueries)
            mjt.task_timeout(this.subqueries[subtask_key]);
        mjt.task_timeout(this);
        return;
    } else {
        this.state = 'ready';
        this.result = true;
    }

    // whole request failed
    //if (o.code !== '/api/status/ok') {
    if (!o.status.match(/^200/)) {
        for (subtask_key in this.subqueries)
            mjt.task_error(this.subqueries[subtask_key], o.code, o.messages);
        mjt.task_error(this, o.code, o.messages);
        return;
    }

    // split result and notify all dependents
    // if the service didn't return results for one of
    //  the subqueries, should really generate an error for it
    for (subtask_key in this.subqueries) {
        var subtask = this.subqueries[subtask_key];
        var sr = o[subtask_key];

        if (sr.code !== '/api/status/ok') {
            if (sr.status !== '/mql/status/ok') { // old version, remove by the solstice
                mjt.task_error(subtask, sr.code, sr.messages);
                continue;
            }
        }

        if (sr.result == null) {
            mjt.task_empty_result(subtask);
            continue;
        }

        subtask.state = 'ready';
        subtask.result = sr.result;
        if (typeof sr.cursor === 'string')
            subtask.next_cursor = sr.cursor;

        mjt.notify(subtask);
    }
};


//////////////////////////////////////////////////////////////////////

mjt.BlobGetTask = function(id, transtype, values) {
    mjt.Task.apply(this);
    this.id = id;
    if (transtype)
        this.trans_type = transtype;
    else
        this.trans_type = 'raw';

    if (typeof(values) == 'undefined')
        this.values = {};
    else
        this.values = values;
};

mjt.BlobGetTask.prototype.enqueue = function() {
    var req = this;  // for closure

    var path = '/api/trans/' + this.trans_type;
    if (this.id.charAt(0) == '/')
        path += this.id;
    else
        path += '/' + mjt.formquote(this.id);

    mjt.callback_script_get(mjt.service_url, path, this.values,
                            function (o) {
                                mjt.parse_metaweb_script_response(req, o);
                            });

};

//////////////////////////////////////////////////////////////////////

/**
 *
 * escape <>&" characters with html entities.
 *
 *  escaping " is only necessary in attributes but
 *   we do it in all text.
 *
 */
mjt.htmlencode = function (s) {
    if (typeof(s) != 'string') {
        return '<span style="color:red">' + typeof(s) + ' ' + s + '</span>';
    }

    // TODO which is the right way to do this and where is
    //  the authoritative url explaining it?

    // 
    // XXX need this to handle unicode?
    //   apparently not - but keep it for now...
    //
    if (0) {
        var cmap = {'<':'&lt;',
                    '>':'&gt;',
                    '&':'&amp;',
                    '"':'&quot;'
                   };

        // 
        if (/["\\<>&\x00-\x1f\u0100-\uffff]/.test(s)) {
            s = s.replace(/([\\"<>&\x00-\x1f\u0100-\uffff])/g, function(m, b) {
                var c = cmap[b];
                if (c) return c;
                c = b.charCodeAt();
                return '&#' + c + ';';  // decimal unicode char ref
            });
        }
        return s;
    }

    if (0) {
        // seems like this should be fastest
        var cmap = {'<':'&lt;',
                    '>':'&gt;',
                    '&':'&amp;',
                    '"':'&quot;'
                   };
        return s.replace(/([\&\<\>\"])/g, function(m, c) {
            return cmap[c];
        });
    } else {
        // though this is what mochikit does...
        return s.replace(/\&/g,'&amp;')
            .replace(/\</g,'&lt;')
            .replace(/\>/g,'&gt;')
            .replace(/\"/g,'&quot;');
    }
};


/**
 * external entry point to create markup from a trusted string.
 */
mjt.bless = function (html) {
    return new mjt.Markup(html);
}

/**
 * constructor for Markup objects, which contain strings
 *  that should be interpreted as markup rather than quoted.
 */
mjt.Markup = function (html) {
    this.html = html;
};

/**
 * any object can define a toMarkup() method and
 *  return a representation of itself as a markup
 *  stream.
 */
mjt.Markup.prototype.toMarkup = function () {
    return this.html;
};

(function () {
    function bad_markup_element(v, msg, markup) {
        markup.push('<span style="outline-style:solid;color:red;">');
        if (msg) {
            markup.push(msg);
            markup.push('</span>');
        } else {
            // could use __proto__ for more info about objects
            markup.push('bad markup element, type [');
            markup.push(typeof(v));
            markup.push(']</span>');
        }
    }

    function flatn(x, markup) {
        //mjt.log('flatn', x);
        switch (typeof x) {
          case 'object':
            if (x === null) {
                bad_markup_element(x, '[null]', markup); // null
            } else if (x instanceof Array) {
                for (var i = 0; i < x.length; i++)
                    flatn(x[i], markup);
            } else if (typeof x.toMarkupList === 'function') {
                flatn(x.toMarkupList(), markup);
            } else if (typeof x.toMarkup === 'function') {
                markup.push(x.toMarkup());
            } else {
                bad_markup_element(x, '[object]', markup);
            }
            break;
          case 'undefined':
            bad_markup_element(x, '[undefined]', markup);
            break;
          case 'string':
            markup.push(mjt.htmlencode(x));
            break;
          case 'boolean':
            markup.push(String(x));
            break;
          case 'number':
            markup.push(String(x));
            break;

          // could eval functions like genshi, this could
          //   allow lazier construction of the result
          //   strings with possible lower memory footprint.
          //   might be important because of the lame ie6 gc.
          //   right now it all gets generated and joined
          //   from a single list anyway.
          case 'function':
            bad_markup_element(x, '[function]', markup);
            break;
        };
        return markup;
    }

    /**
     * hopefully fast function to flatten a nested markup list
     *  into a string.
     *   instances of Markup are passed through
     *   bare strings are html encoded
     *   other objects are errors
     */
    mjt.flatten_markup = function (v) {
        return flatn(v, []).join('');
    };
})();

/**
 * get an element from an id or the actual element
 *  dig inside iframes too.
 */
mjt.id_to_element = function (top) {

    if (typeof(top) == 'string') {
        var e = document.getElementById(top);
        if (!e) {
            mjt.note('no element with id ' + top);
            return null;
        } else {
            top = e;
        }
    }

mjt.log('id_to_element', typeof top);
    if (top.nodeName == 'IFRAME') {

        var idoc = (top.contentWindow || top.contentDocument);

        if (idoc.document)
            idoc = idoc.document;

        top = idoc.getElementsByTagName('body')[0]
    }
    return top;
}



mjt.error_html = function (e, codestr, target_id) {
    // IE has .description as well
    // e.fileName, e.lineNumber
    // e.stack

    var source = [];

    if (codestr && e.lineNumber) {
        var lineno = e.lineNumber;
        var lines = codestr.split('\n');

        if (lineno < 0)
            lineno = 0;
        if (lineno >= lines.length)
            lineno = lines.length - 1;

        var line0 = lineno - 10;
        if (line0 < 0) line0 = 0;

        var cx = [];
        var line;

        source.push(mjt.bless(['\n<pre>']));
        for (line = line0; line < lineno; line++)
            cx.push(lines[line]);
        source.push(cx.join('\n'));

        source.push(mjt.bless(['</pre>\n<pre style="color:red">']));
        source.push(lines[lineno] + '\n');
        source.push(mjt.bless(['</pre>\n<pre>']));

        cx = [];
        for (line = lineno+1; line < lines.length; line++)
            cx.push(lines[line]);
        source.push(cx.join('\n'));
        source.push(mjt.bless(['</pre>\n']));

    }

    var html = [mjt.bless(['<div class="mjt_error"']),
                (target_id ? [mjt.bless([' id="']), target_id, mjt.bless(['"'])]
                   : []),
                mjt.bless(['>']),
                e.name, ': ',
                e.message,
                source,
                mjt.bless(['</div>\n'])
                ];
    html =  html.concat(source);
    return html;
};
/**
 * remove all event handlers in elt and its siblings and children
 */
mjt.teardown_dom_sibs = function (elt, elt_only) {
    while (elt !== null) {
        for (var k in elt) {
            //if (!elt.hasOwnProperty(k)) continue;
    
            if (/^on/.exec(k))
                elt[k] = null;
        }

        var c = elt.firstChild;
        if (c != null)
            mjt.teardown_dom_sibs(c);

        if (elt_only)
            break;

        elt = elt.nextSibling;
    }
};

mjt.replace_innerhtml = function (top, html) {
    var htmltext = mjt.flatten_markup(html);
//    if (top.firstChild) mjt.teardown_dom_sibs(top.firstChild, true);
    top.innerHTML = htmltext;
};

mjt.replace_html = function (top, html) {
    var tmpdiv = document.createElement('div');
    var htmltext = mjt.flatten_markup(html);
    tmpdiv.innerHTML = htmltext;

    //mjt.log(htmltext);

    if (top.parentNode === null) {
        mjt.warn('attempt to replace html that has already been replaced?');
        return;
    }

    var newtop = tmpdiv.firstChild;

    if (newtop === null) {
        // should quote the htmltext and insert that?
        mjt.warn('bad html in replace_innerhtml');
        return;
    }

    //mjt.log('replacetop', newtop, top);
    if (newtop.nextSibling) {
        mjt.warn('template output should have a single toplevel node');
    }

//    mjt.teardown_dom_sibs(top, true);

    top.parentNode.replaceChild(newtop, top);

    // this is kind of unusual behavior, but it's hard to figure
    // out where else to do it.
    if (newtop.style && newtop.style.display == 'none')
        newtop.style.display = '';    // to use default or css style
};


/**
 *  this implements the guts of mjt.for= iteration
 *
 *  it handles:
 *    javascript objects and arrays
 *    pseudo-arrays:
 *      js strings
 *      jQuery result sets 
 *      html DOM nodelists
 *
 *  it doesn't handle:
 *    js "arguments" objects
 *
 */
mjt.foreach = function(self, items, func) {
    var i,l;

    //mjt.log('foreach', typeof items, items, items instanceof Array);

    if (typeof items === 'string' || items instanceof Array
        || (typeof jQuery === 'object' && items instanceof jQuery)) {
        // string, array, or pseudo-array
        l = items.length;
        for (i = 0; i < l; i++)
            func.apply(self, [i, items[i]]);
    } else if (typeof items === 'object') {
        if (items.item  === document.childNodes.item) {
            // dom nodelist
            l = items.length;
            for (i = 0; i < l; i++)
                func.apply(self, [i, items.item(i)]);
        } else {
            // plain old js object
            for (i in items)
                if (items.hasOwnProperty(i))
                    func.apply(self, [i, items[i]]);
        }
    }
};

//////////////////////////////////////////////////////////////////////
/**
 *
 *  a TemplateCall is a runtime template call.
 *   this includes the result of calling mjt.run(),
 *   or any nested ${...} calls to mql.def= template functions.
 *
 *  nested mql.def calls only need a TemplateCall instance
 *   if they contain mjt.task calls, but right now a TemplateCall
 *   is created for every function call.
 *
 *  an instance of TemplateCall is created for each
 *   template function, as a prototype for the calls
 *   to that function.  see tfunc_factory()
 *   for more comments about this.
 *
 */
mjt.TemplateCall = function (raw_tfunc) {
    // make available to template code under "this."
    this.raw_tfunc = raw_tfunc;
    delete this._markup;
}

mjt.TemplateCall.prototype.toMarkupList = function () {
    return this._markup;
};


/**
 *  redraw / redisplay / update the template call's generated markup.
 *  this preserves some state from one tcall to the next.
 */
mjt.TemplateCall.prototype.redisplay = function () {
    var tfunc = this.this_tfunc;

    //mjt.log('redisplay ', tfunc.prototype.signature, this);

    var tcall = new tfunc();
    tcall.prev_tcall = this;
    tcall.subst_id = this.subst_id;
    tcall.render(this.targs).display();
    return tcall;
};


mjt.TemplateCall.prototype.display = function (target_id, targs) {
    if (typeof target_id != 'undefined')
        this.subst_id = target_id;

    //mjt.log('display tf', this.signature, this.subst_id);

    var top = mjt.id_to_element(this.subst_id);

    if (!top) {
        //mjt.log('missing top ', this.subst_id, this);

        // fail silently - this often happens if the user hits
        // reload before the page has completed.
        return this;
    }

    if (typeof this._markup != 'undefined')
        mjt.replace_html(top, this);
    return this;
};


mjt.TemplateCall.prototype.render = function(targs) {
    var html;

    if (typeof targs != 'undefined')
        this.targs = targs;

    var raw_tfunc = this.raw_tfunc;

    try {
        if (0) {  // too verbose for normal debugging
            var tstates = [];
            for (var t in this.tasks)
                tstates.push(t + ':' + this.tasks[t].state);
            mjt.openlog('applying', this.signature, this.targs, 'to id=', this.subst_id + ': ' + tstates.join(' '));
        }
    
        try {
            this._no_render = false;
            this._markup = raw_tfunc.apply(this, this.targs);
            //mjt.log('no ren', (this instanceof mjt.TemplateCall), this._no_render, this.signature, this);
        } catch (e) {
            if (e == mjt.NoDrawException) {
                this._markup = undefined;
            } else {
                var codeblock = this.codeblock;
                if (typeof codeblock == 'undefined')
                    codeblock = new mjt.Codeblock('somewhere');
                mjt.log('codeblock', codeblock.name, this);
                e.tcall = this;
                codeblock.handle_exception('applying tfunc '+
                                           this.signature, e);
                var tstates = [];
                for (var t in this.tasks) {
                    var tt = this.tasks[t];
                    if (typeof tt === 'object' && tt !== null) {
                        tstates.push(t + ':' + tt.state);
                    } else {
                        tstates.push(t + ':' + typeof tt);
                    }
                }
                this._markup = [mjt.bless('<h3>error applying '),
                        this.signature,
                        ' to id=', this.subst_id,
                        mjt.bless('</h3>'),
                        'states:[',
                        tstates.join(' '),
                        ']'];
                // re-throw the exception so other debuggers get a chance at it
                throw e;
            }
        }
    } finally {
        // do this inside finally so it happens even if the error 
        // is re-thrown
        if (this._no_render)
            this._markup = undefined;

        if (0) {  // too verbose for normal debugging
            mjt.closelog();
        }
    }
    return this;
};
/**
 *
 *  associates a task with a TemplateCall
 *
 */
mjt.TemplateCall.prototype.mktask = function(name, task) {
    //mjt.log('MKTASK', name, this);

    this.tasks[name] = task;

    //mjt.log('mktask', task);

    //
    // callback for query completion
    //
    var tcall = this;  // because "this" is wrong in closure
    task._.register(function (t) {
        // right now all events are fired synchronously -
        // this is wasteful - if we depend on more than one
        // query and they arrive together we will fire twice, etc.
        tcall.render().display();

        // XXX this should really set a dirty flag
        //  and a timer before sending
        //mjt.send_queued();
    });

    mjt.enqueue(task);

    // XXX dont batch requests for now
    //mjt.send_queued();

    return task;
};




//////////////////////////////////////////////////////////////////////

/**
 *
 *  the public name for a tfunc is actually a call
 *   to this wrapper.  this is because 
 *  a function created using mjt.def="tfunc(...)" needs to be
 *    called in several ways:
 *
 *   - within markup using ${tfunc(...)}
 *   - internally using new() to set up the __proto__ link.
 *   - recursively in order to hide the differences between those cases
 *
 *  not implemented yet:
 *    a template call may not actually need to construct
 *      an object.  this code tries to construct a new instance if
 *      the tfunc contains any mjt.task= declarations - in that case
 *      need a place to keep track of state while waiting for the task.
 *
 *    if we dont need a new instance we just use the TemplateCall
 *      instance.
 *
 *  @param signature  is a debugging name for the template function
 *  @param rawtfunc   is a function that returns markup 
 *  @param codeblock  is the code where rawtfunc was defined
 *  @param has_tasks  is true if rawtfunc included mjt.task declarations
 *  @param template   is the template where rawtfunc was defined (TODO deprecate!)
 *  @param toplevel   is true if rawtfunc has top-level scope
 *
 */
mjt._internal_tcall = { construct_only: true };  // magic token
mjt.tfunc_factory = function (signature, rawtfunc, codeblock, has_tasks, template, toplevel) {

    var _inline_tcall = function () {  // varargs
        var ctor = arguments.callee;  // _inline_tcall
  
        //mjt.log('calling ' + signature);
        if (this instanceof ctor) {
            // this is filled in by running the tcall
            this.tasks = {};
            this.defs = {};

            // when called as a constructor, we create the template call
            //  object but dont actually expand it yet.
            //mjt.log(signature + ' called as constructor');
            return undefined;
        }

        // called as a plain function, presumably from ${ctor(...)}

        // if this is a lightweight call (no need for redisplays)
        //  then we just bind the TemplateCall as "this" rather than
        //  creating a new instance, and run it.
        // also make sure we dont need this.defs (for main() )

        // has_tasks is currently wrong

        if (0 && !ctor.prototype.has_tasks && !toplevel) {
            return rawtfunc.apply(ctor.prototype, arguments);
        }

  
        // if we werent called as a constructor, re-invoke
        //   ourselves that way to create an object.
        var self = new ctor();

        // copy arguments array
        var targs = [];
        for (var ai = 0; ai < arguments.length; ai++)
            targs[ai] = arguments[ai];

        // if we're called inline, generate a subst_id
        var tname = self.signature.replace(/\(.*\)$/,'');
        self.subst_id = mjt.uniqueid('tcall__' + tname);

        // update the generated markup
        // this is done eagerly so that the state is more predictable,
        //  but lazy update (on display rather than eval) would save
        //  computation in some cases.
        self.render(targs);

        // make arguments available to template code under "this."
        // self.stackframe = mjt.reify_arguments(self.signature, targs);

        // since werent called using new(), return this explicitly.
        // this means the template call object gets mixed into the
        // output stream, so it must have a .toMarkup() method...
        return self;
    };

    // provides this.raw_tfunc, the raw template expansion function
    _inline_tcall.prototype = new mjt.TemplateCall(rawtfunc);

    _inline_tcall.prototype.signature = signature;
    _inline_tcall.prototype.codeblock = codeblock;
    _inline_tcall.prototype.has_tasks = has_tasks;
    _inline_tcall.prototype.template = template;

    // this_tfunc is the constructor rather than the raw expansion code
    _inline_tcall.prototype.this_tfunc = _inline_tcall;


    // XXX temporarily for backward compat
    _inline_tcall.signature = signature;
    _inline_tcall.codeblock = codeblock;
    _inline_tcall.has_tasks = has_tasks;

    return _inline_tcall;
};


/**
 * this turns a js builtin arguments object into a more
 * convenient stack frame representation that includes the
 * arguments indexed by name.
 */
mjt.reify_arguments = function (signature, arguments) {
    var m = /^(\S+)\(([^)]*)\)$/.exec(signature);
    var name = m[1];
    var argnames = m[2].split(',');
    var argd = {};
    var extras = [];

    for (var i = 0; i < argnames.length; i++) {
        argd[argnames[i]] = arguments[i];
    }
    for (; i < arguments.length; i++) {
        extras.push(arguments[i]);
    }

    var r = {
        argnames: argnames,
        args: args,
        extra_args: extras,
        callee: arguments.callee
    };

    return r;
}

//////////////////////////////////////////////////////////////////////
/**
 * somehow indicate that this isnt an error...
 */
mjt.NoDrawException = new Error('no redraw needed for this event');
mjt.NoDrawException.name = 'NoDrawException';

//////////////////////////////////////////////////////////////////////

/**
 *
 * mjt.Scope holds a stack of mjt.def= definitions.
 *
 */
mjt.Scope = function(template, parent, decl) {
    this.template = template
    if (!parent) parent = null;
    this.parent = parent;

    if (!decl) decl = '[unnamed]';
    this.decl = decl;

    this.tasks = {};

    this.toplevel = false;
}

/**
 *
 * much of the Template class should really be TemplateCompiler
 *  as it holds the current state of the compilation.
 * this will get fixed when we support serializing compiled
 *  templates.
 */

mjt.Template = function (top) {
    top = mjt.id_to_element(top);

    this.strings = [];

    // namespace will contain at least 'main'
    //  and possibly other toplevel mjt.defs
    this.namespace = null;

    this.compiler_dt = null;
    this.codestr = null;

    // for construction
    this.buffer = [];
    this.code = [];

    this.scope = new mjt.Scope(this, null, '[toplevel]');
    this.scope.toplevel = true;

    this.compile_top(top);
};

mjt.Template.prototype.flush_string = function(no_output, ignore_whitespace) { 
    var s = this.buffer.join('');
    this.buffer = [];

    if (s == '')
        return -1;

    if (ignore_whitespace && /^\s*$/.exec(s))
        return -1;

    var texti = this.strings.length;
    this.strings.push(new mjt.Markup(s));

    if (mjt.debug) {
        // generate comments with the text in them

        var indent = '                                                  ';
        var commentstart = '// ';
        var x = this.strings[texti].toMarkup();
        x = x.replace(/\r?\n/gm, '\r\n' + indent + commentstart);

        var c = '__m[__n++]=__ts[' + texti + '];';
        if (c.length < indent.length)
            c += indent.substr(c.length);
        this.code.push(c);
        this.code.push([commentstart, x, '\n'].join(''));

    } else if (! no_output) {
        this.code.push('__m[__n++]=__ts[' + texti + '];\n');
    }

    return texti;
};
/**
 * warn into the template output
 */
mjt.Template.prototype.warn = function(s) { 
    this.buffer.push('<span style="outline-style:solid;color:red;">');
    this.buffer.push(mjt.htmlencode(s));
    this.buffer.push('</span>');
};
/**
 * push the scope stack
 */
mjt.Template.prototype.push_def = function(decl) {
    this.scope = new mjt.Scope(this, this.scope, decl);
}
/**
 * pop the scope stack
 */
mjt.Template.prototype.pop_def = function() {
    this.scope = this.scope.parent;
}
/**
 *
 * compile code to create or reference a mjt task.
 *   the task is only created once, not on each redraw!
 *
 */
mjt.Template.prototype.compile_task = function(name, e) {
    // the query is in the text
    // XXX should fail/warn if more than one child
    var mq = e.firstChild.nodeValue;

    if (mq.match(/;\s*$/)) {
        mjt.warn('mjt.task=', name,
                 'definition should not end with a semicolon');
        mq = mq.replace(/;\s*$/, ''); // but fix it and continue
    }

    if (mq.match(/\/\/ /)) {
        // no way to fix this - IE doesnt preserve whitespace
        mjt.warn('"//" comments in mjt.task=', name,
                 'definition will fail on IE6');
        //mq = mq.replace(/\r?\n/g, '\r\n');
    }

    this.flush_string();
    //this.code.push('mjt.log("compile_task", this);\n');
    this.code.push('var ' + name + ' = this.tasks && this.tasks.'
                   + name + ';\n');

    this.code.push('if (!' + name + ') ');

    // mark the current function as requiring a TemplateCall
    this.scope.has_tasks = true;

    // note that we dont evaluate mq unless we're actually creating it.
    this.code.push(name + ' = this.mktask("' + name
                   + '", (\n' + mq + '));\n');
};

/**
 * compile a mjt.attrs clause
 */
mjt.Template.prototype.compile_attrs = function(s) {
    this.flush_string();

    var uvar = mjt.uniqueid('attrs');  // unique variable
    var tvar = mjt.uniqueid('attrs_i');  // unique variable
    this.code.push('var ' + uvar + ' = ' + s + ';\n');
    this.code.push('for (var ' + tvar + ' in ' + uvar + ') {\n');

    //var x = '" "+' + tvar + '+"=\""' + uvar + '[' + tvar + ']';

    var x = "' ' + @tvar + '=\"' + @uvar[@tvar] + '\"'"
        .replace(/@tvar/g,tvar).replace(/@uvar/g,uvar);
    this.code.push('__m[__n++]=mjt.bless(' + x + ');\n');

    //this.code.push('mjt_html.push(" " + ' + tvar + ' + "=");\n');
    //this.code.push('mjt_html.push(mjt.bless(\'"\'));\n');
    //this.code.push('mjt_html.push(' + uvar + '[' + tvar + '])\n');
    //this.code.push('mjt_html.push(mjt.bless(\'"\'));\n');
    this.code.push('}\n');
};
/**
 *
 * compile a text node or attribute value,
 *  looking for $$ or $var or ${expr} and expanding
 *
 */
mjt.Template.prototype.compile_text = function(s) { 
    var segs = s.split('$');
    if (segs.length == 1) {
        this.buffer.push(mjt.htmlencode(s));
        return;
    }

    this.buffer.push(mjt.htmlencode(segs[0]));
    var escaped = true;
    var valid = true;
    var segi = 1;
    var seg = segs[segi];

    // this code could be much faster using better regexp-fu,
    // particularly using Regexp.lastIndex.  but it doesnt
    // show up as a big profiling hotspot...
    while (segi < segs.length) {
        if (escaped) {
            escaped = false;

            if (seg == '' && segi < segs.length - 1) {
                this.buffer.push('$');
                segi++;
                seg = segs[segi];
                continue;
            }

            var m = seg.match(/^(([A-Za-z0-9_.]+)|\{([^}]+)\}|\[([^\]]+)\])((.|\n)*)$/);
            if (m != null) {
                var expr = m[2];
                if (typeof(expr) == 'undefined' || expr == '')
                    expr = m[3];

                if (typeof(expr) == 'undefined' && typeof(m[4] != 'undefined'))
                    expr = 'mjt.ref("' + m[4] + '")';

                if (typeof(expr) == 'undefined') {
                    this.warn('bad $ substitution');
                } else {
                    this.flush_string();
                    this.code.push('__m[__n++]=(' + expr + ');\n');
                }

                // re-evaluate on the rest.
                if (seg != '' || segi < segs.length - 1)
                    seg = m[5];
            } else {
                this.warn('bad $ substitution');
            }
        } else {
            if (seg != '') {
                this.buffer.push(mjt.htmlencode(seg));
            }
            escaped = true;
            segi++;
            seg = segs[segi];
        }
    }
};
/**
 * generate the body of an onevent handler
 * UNLIKE HTML, event handlers use the lexical scope of the template function.
 *  this makes it much easier to write handlers for tags that are generated
 *  inside loops or functions.
 * the disadvantage is that we create lots of little anonymous functions, many of
 *  them unnecessary.  in many cases it would be safe to just inline the event
 *  handler rather than capturing the environment in a closure, but we cant tell
 *  whether an onevent handler has free variables so we always have to create the
 *  closure.
 * there are almost certainly leaks here - use something like
 *  MochiKit.signal for onevent management?
 */
mjt.Template.prototype.compile_onevent_attr = function (n, aname, avalue) {
    // TODO make sure aname is a known event handler.  we assume it's clean below.

    this.flush_string();

    // XXX this could leak over time, and there's no good
    //  way to gc these keys.  should hang off TemplateCall
    //  rather than mjt._cb so the closures will go away
    //  at some point.

    
    var uvar = mjt.uniqueid(aname + '_cb');  // unique variable
    this.code.push('var ' + uvar + ' = mjt.uniqueid("' + aname + '");\n');
    this.code.push('mjt._cb[' + uvar + '] = function (event) {\n');
    this.code.push(avalue);
    this.code.push('}\n');

    // return the new onevent attribute string
    return ('return mjt._cb.${' + uvar + '}.apply(this, [event])');
};


mjt.Template.prototype.get_attributes = function(n, attrs, mjtattrs) { 

    var t0 = (new Date()).getTime();

    // extract mjt-specific attributes and put the rest in a list.
    //  expansion of dynamic attributes is done later.
    // this gets called alot.
    var srcattrs = n.attributes;
    var a;
    var ie_dom_bs = /MSIE/.test(navigator.userAgent);

    for (var ai = 0; ai < srcattrs.length; ai++) {
        var attr = srcattrs[ai];
        if (!attr.specified) continue;

        var aname = attr.nodeName;
        var m = aname.match(/^mjt\.(.+)/);
        if (m) {
            var mname = m[1];

            a = { name: mname };

            // we dont warn about unknown mjt attrs yet
            mjtattrs[mname] = attr.nodeValue;

            if (mname == 'src') {
                // mjt.src is used to hide src= attributes within
                //  the template so they arent fetched until the
                //  template is expanded.
                a.value = attr.nodeValue;
                attrs.push(a);
            }
        }
    }

    for (var ai = 0; ai < srcattrs.length; ai++) {
        var attr = srcattrs[ai];
        if (!attr.specified) continue;

        var aname = attr.nodeName;
        var m = aname.match(/^mjt\.(.+)/);
        if (!m) {
            // ignore src= attribute if mjt.src= is present.
            if (aname == 'src' && (typeof mjtattrs.src != 'undefined'))
                continue;
            a = { name: aname };

            // TODO: see
            //  http://tobielangel.com/2007/1/11/attribute-nightmare-in-ie

            // cant do vanilla onevent= on IE6 because the dom doesnt
            //  have access to the original string, only to the
            //  compiled js function.  use mjt.onevent=.
            if (aname.substr(0,2) == 'on') {
                mjt.warn(a.name, '="..."',
                         'will break on IE6, use',
                         'mjt.' + aname);
                attrs.push(a);
            }

            // we dont warn about unknown attrs (like "mql.")
            //  yet.

            if (ie_dom_bs) {
                if (aname == "style") {
                    // IE makes it hard to find out the style value
                    a.value = '' + n.style.cssText;
                } else if (aname == 'CHECKED') {
                    aname = 'checked';
                    a.value = '1';
                } else {
                    a.value = n.getAttribute(aname, 2);
                    if (!a.value)
                        a.value = attr.nodeValue;
                }
            } else {
                a.value = attr.nodeValue;
            }
            if (typeof a.value == 'number')  // some ie attributes
                a.value = '' + a.value;

            attrs.push(a);
        }
    }

    // IE doesnt show form value= as a node attribute
    if (ie_dom_bs && n.nodeName == "INPUT") {
        a = { name: 'value', value: n.value };
        attrs.push(a);
    }

var dt = (new Date()).getTime() - t0;
/*
if (dt > 40) {
    console.trace()
    mjt.warn('slow get_attributes?', t0);
}
*/

};

/**
 *
 * compile a mjt.choose directive
 *
 */
mjt.Template.prototype.compile_choose = function(cn, choose) { 
    var choose_state = 'init';
    var tablevar = false;
    var default_label = false;

    this.flush_string();

    if (choose) {
        this.code.push('switch (' + choose + ') {\n');
        choose_state = 'dispatch_init';
    }

    var n = cn.firstChild;
    while (n != null) {
        var nextchild = n.nextSibling;

        var nt = n.nodeType;

        if (nt == 3) { // TEXT_NODE
            if (n.nodeValue.match(/[^ \t\r\n]/)) {
                mjt.warn('only whitespace text is allowed in mjt.choose, found',
                         '"' + n.nodeValue + '"');
            }
            n = nextchild;
            continue;
        }
    
        if (nt == 1) { // ELEMENT_NODE
            var next_choose_state = choose_state;
            var mjtattrs = {};
            var attrs = [];
            this.get_attributes(n, attrs, mjtattrs);
            var defaultcase = false;

            if (typeof(mjtattrs.when) != 'undefined') {
                defaultcase = false;
            } else if (typeof(mjtattrs.otherwise) != 'undefined') {
                defaultcase = true;
            } else {
                mjt.warn('all elements inside mjt.choose must have a mjt.when= or mjt.otherwise= attribute');
                break;
            }


            //this.flush_string();

            if (choose_state == 'init') {
                if (defaultcase) {
                    this.code.push('{\n');
                    next_choose_state = 'closed';
                } else {
                    this.code.push('if (' + mjtattrs.when + ') {\n');
                    next_choose_state = 'open';
                }
            } else if (choose_state == 'open') {
                if (defaultcase) {
                    // for an if-else chain this is the final else
                    this.code.push('} else {\n');
                    next_choose_state = 'closed';
                } else {
                    this.code.push('} else if (' + mjtattrs.when + ') {\n');
                    next_choose_state = 'open';
                }
            } else if (choose_state.match(/^dispatch/)) {
                if (choose_state != 'dispatch_init')
                    this.code.push('break;\n');

                if (defaultcase) {
                    this.code.push('default:\n');
                    next_choose_state = 'dispatch';  // XXX dispatch_closed?
                } else {
                    this.code.push('case ');
                    this.code.push(mjt.json_from_js(mjtattrs.when));
                    this.code.push(':\n');
                    next_choose_state = 'dispatch';
                }
            }

            this.compile_node(n, 'in_choose');

            choose_state = next_choose_state;
        }
    
        n = nextchild;
    }

    this.flush_string();
    
    if (choose == '') {
        // end if-else chain
        this.code.push('}\n');
    } else {
        if (choose_state != 'dispatch_init')
            this.code.push('break;\n');
        // close switch statement
        this.code.push('};\n');
    }
};


/**
 *
 * compile a template from a dom representation.
 *
 */
mjt.Template.prototype.compile_node = function(n, choose_state) { 
    if (typeof(choose_state) == 'undefined')
        choose_state = 'none';
    var nt = n.nodeType;
    var tt = this;
    var subcompiler = function(n) {
            var child = n.firstChild;
            while (child != null) {
                var nextchild = child.nextSibling;
                tt.compile_node(child);
                child = nextchild;
            }
    };

    var toplevel = this.scope.toplevel;


    if (nt == 3) { // TEXT_NODE
        this.compile_text(n.nodeValue);
        return;
    }

    if (nt == 1) { // ELEMENT_NODE
        // extract mjt-specific attributes and put the rest in a list.
        //  expansion of dynamic attributes is done later.
        var mjtattrs = {};
        var attrs = [];
        this.get_attributes(n, attrs, mjtattrs);
        var completions = []; // a stack but without all the function calls

        var render_outer_tag = true;
        var generate_id = false;


        if (toplevel) {
            mjtattrs.def = 'rawmain()';
        }

        var tagname = n.nodeName;

        if (tagname.match(/script/i)) {
            // XXX this kind of sucks, but passing <script> tags
            //  through is confusing and there seems to be a bug
            //  where the &quot; entities inside a <script> tag
            //  arent treated as " quotes.  &lt; works right though?
            //mjt.log('elided script tag');
            return;
        }

        if (typeof(mjtattrs.task) != 'undefined') {
            // should be an error to have other mjt.* attrs
            this.flush_string();
            this.compile_task(mjtattrs.task, n);
            return;  // elide the whole element
        }

        if (typeof(mjtattrs.def) != 'undefined') {
            this.flush_string();
            var defn = mjtattrs.def.match(/^([^(]+)\(([^)]*)\)$/ );
            
            if (! defn) {
                mjt.warn('bad mjt.def=', mjtattrs.def,
                         ': must contain an argument list');
                return;
            }
            var defname = defn[1];
            var defargs = defn[2];

            if (mjt.debug) {
                this.code.push('// mjt.def=');
                this.code.push(mjtattrs.def);
                this.code.push('\n');
            }

            if (typeof(attrs.id) != 'undefined') {
                mjt.warn('mjt.def=', mjtattrs.def,
                         'must not have an id="..." attribute');
            }

            // this is the actual function declaration
            this.code.push('var ' + defname + ' = ');
            this.code.push('function (' + defargs + ') {\n');

            this.push_def(mjtattrs.def);

            //this.code.push("mjt.log('TCALL', this);\n");

            if (toplevel) {
                this.code.push('var __template=this.template;\n');
                this.code.push('var __ts=__template.strings;\n');
            }

            this.code.push('var __m=[],__n=0;\n');

            // generate an id for the tcall
            generate_id = true;

            var t = this;
            completions.push(function () {
                var defscope = this.scope;
                this.pop_def();
                this.flush_string();
                this.code.push('return __m;\n');
                this.code.push('}\n');

                if (0) {
                    // if there were any mjt.tasks in this scope, record that
                    // on the compiled function.
                    if (defscope.has_tasks) {
                        this.code.push(defname + '.has_tasks = true;\n');
                    }
                    // record the declaration of the function for debugging
                    this.code.push(defname + '.signature = ' +
                                   mjt.json_from_js(mjtattrs.def) + ';\n');
                    if (!toplevel)
                        this.code.push(defname + '.codeblock = __template.codeblock;\n')
                } else {
                    // if there were any mjt.tasks in this scope, record that
                    // on the compiled function.
                    var has_tasks = false;
                    if (defscope.has_tasks) {
                        has_tasks = true;
                    }
                    //mjt.log('HAS_TASKS', mjtattrs.def, has_tasks);

                    if (!toplevel) {
                        var codevar = '__template.codeblock';
                        var templatevar = '__template';

                        this.code.push(defname + ' = mjt.tfunc_factory(' + 
                                       mjt.json_from_js(mjtattrs.def) + ', ' +
                                       defname + ', ' + codevar + ', ' +
                                       has_tasks + ', ' + templatevar + ', ' +
                                       toplevel + ');\n');
                    }
                }
                if (this.scope.parent && this.scope.parent.toplevel)
                    this.code.push('this.defs.' + defname + ' = ' + defname + ';\n');
            });
        }

        if (typeof(mjtattrs['when']) != 'undefined') {
            this.flush_string();

            // make sure we are in a mjt.choose clause.
            //  if so, the containing compile_choose takes care of things
            if (choose_state != 'in_choose')
                mjt.warn('unexpected mjt.when, in choice state', choose_state);

            completions.push(function () {
                this.flush_string();
            });
        }

        if (typeof(mjtattrs['otherwise']) != 'undefined') {
            this.flush_string();

            // make sure we are in a mjt.choose clause.
            //  if so, the containing compile_choose takes care of things
            if (choose_state != 'in_choose')
                mjt.warn('unexpected mjt.otherwise, in choice state ', choose_state);

            completions.push(function () {
                this.flush_string();
            });
        }

        if (typeof(mjtattrs['for']) != 'undefined') {
            this.flush_string();

            // expect a python style "VAR in EXPR" loop declaration
            var matches = /^(\w+)(\s*,\s*(\w+))?\s+in\s+(.+)$/.exec(mjtattrs['for']);

            if (!matches) {
                // handle javascript style
                //   "(var i = 0 ; i < 3; i++)" declarations
                if (mjtattrs['for'].charAt(0) == '(') {
                    this.code.push('for ' + mjtattrs['for'] + ' {\n');
                } else {
                    mjt.warn('bad mjt.for= syntax');
                }
                completions.push(function () {
                    this.flush_string();
                    this.code.push('}\n');  // for (...)
                });
            } else {
                var var1 = matches[1];
                var var2 = matches[3];
                var forexpr = matches[4];
                var itemid, indexid;

                if (!var2) {   // "for v in items"
                    indexid = mjt.uniqueid(var1 + '_index');
                    itemid = var1;
                } else {       // "for k,v in items"
                    indexid = var1
                    itemid = var2;
                }

                var itemsid = mjt.uniqueid(itemid + '_items');

                var funcvar = mjt.uniqueid('for_body');
    
                this.code.push('var ' + itemsid + ' = (' + forexpr + ');\n');

                this.code.push('var ' + funcvar + ' = function ('
                               + indexid + ', ' + itemid + ') {\n'
                               + itemid + ' = ' + itemsid + '['
                               + indexid + '];\n');

                // hack to make "continue;" work inside mjt.for=
                var onceid = mjt.uniqueid('once');
                this.code.push('var ' + onceid + ' = 1;\n');
                this.code.push('while (' + onceid + '--) {\n');

                completions.push(function () {
                    this.flush_string();
    
                    this.code.push('} /* while once-- */\n');
                    this.code.push('}; /* function ' + funcvar + '(...) */\n');
    
                    this.code.push('mjt.foreach(this, ' + itemsid + ', ' + funcvar + ');\n');
                });
            }
        }

        if (typeof(mjtattrs['if']) != 'undefined') {
            this.flush_string();

            this.code.push('if (' + mjtattrs['if'] + ') {\n');

            completions.push(function () {
                this.flush_string();
                this.code.push('}\n');
            });
        }

        if (typeof(mjtattrs['elif']) != 'undefined') {
            this.flush_string(false, true);  // skip whitespace text

            this.code.push('else if (' + mjtattrs['elif'] + ') {\n');

            completions.push(function () {
                this.flush_string();
                this.code.push('}\n');
            });
        }

        if (typeof(mjtattrs['else']) != 'undefined') {
            this.flush_string(false, true);  // skip whitespace text

            this.code.push('else {\n');

            completions.push(function () {
                this.flush_string();
                this.code.push('}\n');
            });
        }

        if (typeof(mjtattrs.script) != 'undefined') {
            // later, the particular value will probably specify an event
            // that should trigger the script.  for now it's run inline.
            switch (mjtattrs.script) {
                case '':
                    break;
                case '1':
                    // accepted for backwards compat
                    break;
                default:
                    mjt.warn('reserved mjtattrs.script= value:', mjtattrs.script);
                    break;
            }

            // TODO should play better with other mjt.* attrs
            this.flush_string();
            var textnode = n.firstChild;
            if (!textnode) {
                // dont expand anything inside mjt.script
                render_outer_tag = false;
                subcompiler = function (n) { };
            } else if (textnode.nodeType != 3 || textnode.nextSibling) {
                mjt.warn("the mjt.script element can only contain javascript text, not HTML.  perhaps you need to quote '<', '>', or '&' (this is unlike a <script> tag!)");
            } else {
                var txt = textnode ? textnode.nodeValue : '';

                if (txt.match(/\/\/ /)) {
                    // no way to fix this - IE doesnt preserve whitespace
                    mjt.warn('"//" comments in mjt.script= definition will fail on IE6');
                    //txt = txt.replace(/\r?\n/g, '\r\n');
                }
                this.code.push(txt);
                this.code.push('\n');

                // dont expand anything inside mjt.script
                render_outer_tag = false;
                subcompiler = function (n) { };
            }
        }

        if (typeof(mjtattrs.choose) != 'undefined') {
            this.flush_string();

            var tt = this;
            subcompiler = function(n) {
                tt.compile_choose(n, mjtattrs.choose);
            };
        }

        if (typeof(mjtattrs.replace) != 'undefined') {
            render_outer_tag = false
            // behaves like mjt.content but strips the outer tag
            mjtattrs.content = mjtattrs.replace;
        }

        if (typeof(mjtattrs.strip) != 'undefined') {
            this.flush_string()
        }

        // handle mjt.onevent attrs
        for (var evname in mjtattrs) {
            if (evname.substr(0,2) != 'on') continue;
            a = { name: evname,
                  value: this.compile_onevent_attr(n, evname, mjtattrs[evname])
                };
            attrs.push(a);
        }

        if (generate_id && (!render_outer_tag
                            || (typeof(mjtattrs.strip) != 'undefined'))) {

            // XXX really only a problem with contained tasks
            mjt.warn('can\'t strip mjt.def="' + mjtattrs.def + '" tag yet');
        }

        if (render_outer_tag) {
            // the surrounding tag may not get included in the
            // output if it contains some special attributes.
            this.buffer.push('<');
            this.buffer.push(tagname);

            var myattrs = [];

            for (var ai = 0; ai < attrs.length; ai++) {
                myattrs.push(attrs[ai]);
            }

            for (var ai = 0; ai < myattrs.length; ai++) {
                var a = myattrs[ai];

                if (a.name == 'id' && generate_id)
                    generate_id = false;

                if (typeof(a.value) == 'function') {
                    mjt.warn('ignoring function-valued attr',
                              tagname, a.name, a.value);
                    continue;
                }

                this.buffer.push(' ');
                this.buffer.push(a.name);
                this.buffer.push('="');
                // XXX potentially incompatible with mjt.strip!
                this.compile_text(a.value);
                this.buffer.push('"');
            }

            if (generate_id) {   // XXX incompatible with mjt.strip
                this.flush_string();

                this.code.push('if (this.subst_id) ');
                this.code.push('__m[__n++]=mjt.bless(\' id="\' + this.subst_id + \'"\');\n');
            }

            // XXX note this cant override other attrs yet!
            if (typeof(mjtattrs.attrs) != 'undefined') {
                this.compile_attrs(mjtattrs.attrs);
            }

            this.buffer.push('>');
        }

        if (typeof(mjtattrs.strip) != 'undefined') {
            this.code.push('if (!(' + mjtattrs['strip'] + ')) {\n');
            this.flush_string()
            this.code.push('};\n');
        }

        if (typeof(mjtattrs.content) != 'undefined') {
            this.flush_string();
            this.code.push('__m[__n++]=(' + mjtattrs.content + ');\n');
        } else {
            subcompiler(n);
        }


        if (typeof(mjtattrs.strip) != 'undefined') {
            this.flush_string()
        }

        if (render_outer_tag) {
            this.buffer.push('</' + tagname + '>');
        }

        if (typeof(mjtattrs.strip) != 'undefined') {
            // XXX should keep result of previous expr evaluation -
            // right now we re-eval to see if stripping is in order.
            this.code.push('if (!(' + mjtattrs['strip'] + ')) {\n');
            this.flush_string()
            this.code.push('};\n');
        }

        for (var ci = completions.length-1; ci >= 0 ; ci--) {
            completions[ci].apply(this, []);
        }
    }
};

/**
 *
 * compile the template
 *
 */
mjt.Template.prototype.compile_top = function(top) { 
    var t0 = (new Date()).getTime();

    this.compile_node(top);
    var dt = (new Date()).getTime() - t0;
    mjt.log('compiled dom in ', dt, 'msec');

    this.code.push('; var s = { rawmain: rawmain }; s;\n');
    this.codestr = this.code.join('');

    // this.codestr = this.codestr.replace(/\r?\n/g, '\r\n');

    this.codeblock = new mjt.Codeblock('#'+top.id, this.codestr);

    // clean up for gc.  keep codestr for debugging though
    this.code = null;

    // evaluate the code string, generating a new function object
    // that can be used to instantiate the template as a string of
    // html.

    this.namespace = this.codeblock.evaluate();

    this.namespace.main = mjt.tfunc_factory("main()", this.namespace.rawmain,
                                            this.codeblock, false, this, true);

    this.compiler_dt = (new Date()).getTime() - t0;
};


/**
 *
 * a TemplatePackage is a namespace of template functions,
 *  usually loaded from a single html document.
 *
 * @param name  is used for debugging only right now
 */
mjt.TemplatePackage = function () {
    // XXX leading underscores need to be rationalized
    this._prereqs = [];
    this._top = null;
    this.source = null;

    // each template function defines a property here
    this.namespace = {
        _package: this
    };
};
/**
 *
 * load the metadata from freebase.
 *   unfinished.
 *
 */
mjt.TemplatePackage.prototype.from_freebase = function (id) {
    this.id = id;

    var q = {
        id: id,
        type: '/common/document',

        name: null,
        author: null,
        summary: null,
        content: {
            media_type: null,
            language: null
        },
        '/user/nix/types/mjt_package/imports': []
    };

    // send q, fill in the prereqs array

    // request the package text from the blob
};

mjt.global_scope = window;

mjt.load_resource = function (spec, k) {
    //mjt.log('load_res', spec.url, spec);
    switch (spec.restype) {
      case 'js':
        mjt.include_js_async(spec.url, k);
        break;
      case 'mjt':
        mjt.dynamic_iframe_async(spec.url, function(iframe) {
            var idoc = (iframe.contentWindow
                        || iframe.contentDocument);

            if (idoc.document)
                idoc = idoc.document;
            var ibody = idoc.getElementsByTagName('body')[0];

            var load_t0 = (new Date()).getTime();

            //mjt.log('idoc', idoc.html, ibody, iframe, iframe.contentWindow.document);
            var reqpkg = new mjt.TemplatePackage();
            reqpkg.source = spec.url;
            reqpkg.from_head(idoc.getElementsByTagName('head')[0]);
            reqpkg.compile_document(ibody, [], function (tcall) {
                // link.title gives a global variable to set
                mjt.global_scope[spec.title] = reqpkg;

                dt = (new Date()).getTime() - load_t0;
                mjt.log('loaded pkg', spec.title, ' in ', dt, 'msec from ', reqpkg.source);

                k();
            });
        });
        break;

      // XXX styles
      default:
        mjt.error('unknown resource type', spec.restype)
        break;
    }
};
/**
 *
 * load the metadata from a dom document element.  in
 *  this case the metadata is encoded in subelements of
 *  the html <head> element.
 *
 */
mjt.TemplatePackage.prototype.from_head = function (head) {
    var elts = [];
    for (var e = head.firstChild; e !== null; e = e.nextSibling) {
        if (e.nodeType != 1)
            continue;
        // nodeType == NODE
        elts.push(e);
        /*
        elts.push({
            tagname: e.nodeName,
            body: e.innerHTML,
            attrs: {}
        }); */
    }
    /*
    var subelts = head.*;
    for (var i = 0; i < ; i++) {
        var e = subelts[i];
        elts.push({
            tagname: e.localName().toUpperCase,
            body: '',
            attrs: {}
        });
    }
    */

    for (var i = 0; i < elts.length; i++) {
        var e = elts[i];
        switch (e.nodeName) {
          case 'TITLE':
            this.title = e.innerHTML;
            break;
    
          case 'META':
            //d.push({ name: e.name, content: e.content, http_equiv: e.httpEquiv });
            switch (e.name) {
              case 'description':
                this.summary = e.content;
                break;
              case 'author':
                this.author = e.content;
                break;
              case 'content-language':
                this.language = e.content;
                break;
              case 'x-mjt-id':
                this.id = e.content;
                break;
            }
            break;
    
          case 'SCRIPT':
            // skip this, its already been evaluated by the browser
            //d.push({ type: e.type, src: e.src, text: e.text });
            break;
    
          case 'STYLE':
            //d.push({ media: e.media,  type: e.type, innerHTML: e.innerHTML });
            break;
    
          case 'LINK':
            //d.push({ rel: e.rel, href: e.href, type: e.type, title: e.title, id: e.id });
            switch (e.rel) {
              case 'x-mjt-script':
                this._prereqs.push({
                    restype: 'js',
                    url: e.href,
                    title: e.title,
                    type: e.type || 'text/javascript'
                });
                break;
              case 'x-mjt-import':
                this._prereqs.push({
                    restype: 'mjt',
                    url: e.href,
                    title: e.title,
                    type: e.type || 'text/x-metaweb-mjt'
                });
                break;
              case 'stylesheet':
              case 'alternate stylesheet':
                break;
            }
            break;
    
          default:
            break;
        }
    }
};

/**
 * asynchronously loads all remaining _prereqs.
 *  reinvokes itself until _prereqs is empty
 *  then calls continuation k()
 */
mjt.TemplatePackage.prototype.load_prereqs = function (k) {
    var pkg = this;
    if (!this._prereqs.length) {
        k();
        return;
    }

    var prereq = pkg._prereqs.shift();

    function resource_loaded() {
        //mjt.log('loaded prereq', prereq.url, prereq);
        pkg.load_prereqs(k);
    };

    mjt.log('loading prereq', prereq.url, prereq);
    mjt.load_resource(prereq, resource_loaded);
};

/**
 * runs asynchronously - calls continuation cb(tcall) when finished
 *  where tcall is the result of compiling and evaluating the package.
 * in the case of mjt.run the result is spliced in to the document,
 *  for mjt.load the resulting html is thrown away but the definitions
 *  kept.
 */
mjt.TemplatePackage.prototype.compile_document = function (top, targs, cb) {
    var pkg = this;
    pkg._top = top;
    
    if (typeof targs == 'undefined')
        targs = [];
    pkg._args = targs;

    var load_t0 = (new Date()).getTime();

    function prereqs_loaded() {  // continuation
        var load_dt = (new Date()).getTime() - load_t0;
        //mjt.log('template prereqs ready in ', load_dt, 'msec for ', pkg.source);

        var t0 = (new Date()).getTime();
        var template = new mjt.Template(top);
        pkg._template = template;

        var dt = (new Date()).getTime() - t0;
        //mjt.log('template compiled in ', dt, 'msec from ', pkg.source, template.compiler_dt);

        // copy the string table for template expansion
        pkg._template_strings = template.strings;
        pkg._codestr = template.codestr;
        pkg._baseline = template.baseline;

        // copy the namespace from the compiled template
        var ns = template.namespace;

        // is this used?
        ns.main.prototype.template = template;

        var tcall = (new ns.main()).render(pkg._args)
        tcall.pkg = pkg;
        tcall.template = template;

        dt = (new Date()).getTime() - t0;
        //mjt.log('template loaded in ', dt, 'msec from ', pkg.source, tcall, tcall.defs);

        var defs = tcall.defs;
        for (var k in defs) {
            if (!defs.hasOwnProperty(k)) continue;

            pkg.namespace[k] = defs[k];

            // XXX kill this
            pkg[k] = defs[k];

        }

        cb(tcall);
    }

    pkg.load_prereqs(prereqs_loaded);
};


//////////////////////////////////////////////////////////////////////


/**
 *
 * walk the html dom, extracting mjt.* attributes, recording
 *   and compiling templates, queries, and template insertion sites.
 *
 */
mjt.run = function (target, tfunc, targs) {
    //mjt.log('mjt.run', target, tfunc, targs);
    var target_id;

    if (typeof target === 'string') {
        target_id = target;
        target = document.getElementById(target_id);
    } else if (typeof target === 'object') {
        //mjt.log('mjt.run id ', typeof target.id, target_id, target);
        if (target.id == '')
            target.id = mjt.uniqueid('run_target');
        target_id = target.id;
    }

    if (typeof tfunc === 'function') {
        var tcall = new tfunc();
        tcall.subst_id = target_id;
        tcall.render(targs).display();
        return tcall.defs;
    }

    var pkg = new mjt.TemplatePackage();

    // if called with no args, compile the <body>
    if (typeof(target) === 'undefined') {

        pkg.source = window.location.protocol + '//'
            + window.location.host + window.location.pathname;
        // pull the template contents of <body> into a subdiv
        target = document.createElement('div')

        var body = document.getElementsByTagName('body')[0];
        var e = body.firstChild;
        while (e !== null) {
            var tmp = e;
            e = e.nextSibling;

            if (tmp.nodeName === 'IFRAME'
                && tmp.className === 'mjt_dynamic') {
                continue;
            }

            body.removeChild(tmp);
            target.appendChild(tmp);
        }

        // TODO can this be removed if we refer to target by 
        //  element rather than by id?
        if (1) {
            target.id = mjt.uniqueid('mjt_body');
            target.style.display = 'none';
            body.appendChild(target);
        }

        // strip off any display='none' on <body>
        if (body.style.display == 'none')
            body.style.display = '';

        // get package metadata from this page's <head>
        pkg.from_head(document.getElementsByTagName('head')[0]);
    } else {
        pkg.source = window.location.protocol + '//'
            + window.location.host + window.location.pathname
            + '#' + target_id;
    }

    var tcall_defs = null;

    function compile_document_done(tcall) {
        tcall.subst_id = target.id;
        mjt.log('mjt.run compiled', target_id);
        tcall.display();

        // set a variable in the containing scope - this
        // will only make a difference if pkg.compile_document is
        // called synchronously.
        tcall_defs = tcall.defs;
    }
    //mjt.log('compiling', target, targs);

    pkg.compile_document(target, targs, compile_document_done);

    // if compile_document succeeds synchronously (no need to
    // wait for dependencies), then this will be set.
    return tcall_defs;
};

/**
 *
 * walk the html dom, extracting mjt.* attributes, recording
 *   and compiling templates, queries, and template insertion sites.
 *
 */
mjt.load = function (top_id) {
    //mjt.log('mjt.load', top_id);

    var pkg = new mjt.TemplatePackage();
    pkg.source = window.location.protocol + '//'
        + window.location.host + window.location.pathname
        + '#' + top_id;
    var top = document.getElementById(top_id);

    var tcall_defs = null;

    function compile_document_done(tcall) {
        mjt.log('mjt.load compiled', tcall);

        // set a variable in the containing scope - this
        // will only make a difference if pkg.compile_document is
        // called synchronously.
        tcall_defs = tcall.defs;
    }

    pkg.compile_document(top, [], compile_document_done);

    // if compile_document succeeds synchronously (no need to
    // wait for dependencies), then this will be set.
    return tcall_defs;
};


mjt.load_string = function (mjthtml, cb) {
    var tag_id = mjt.uniqueid('load_string');

    var tag = document.createElement('div');
    tag.style.display = 'none';
    tag.id = tag_id;
    tag.innerHTML = mjthtml;

    // XXX is this necessary?
    var body = document.getElementsByTagName('body')[0];
    body.appendChild(tag);

    var module = mjt.load(tag_id);

    //mjt.log('calling loaded ', module, cb);
    if (typeof cb != 'undefined')
        cb(module);
};


mjt.loadblob = function (docid, cb) {
    var task = new mjt.BlobGetTask(docid);
    task._.register(function (t) {
        if (t.state == 'ready') {
            //mjt.log('blobget', t.state, t.result);
            // check media_type?
            mjt.load_string(t.result.body, cb);
        }
    });

    mjt.enqueue(task);
};

//////////////////////////////////////////////////////////////////////
/**
 *
 * attach a popup with the given html to a textinput field.
 *
 */
mjt.popup = function (tfunc, args, kws) {
    if (typeof kws == 'undefined') kws = {};
    var id = kws.id ? kws.id : mjt.uniqueid('_popup');

    var html = mjt.flatten_markup(tfunc.apply(null, args));

    var div = document.createElement('div');
    div.innerHTML = html;

    // extract the mjt-generated node with the special id
    // this is kind of ugly but there are extra layers otherwise?
    if (id)
        div.id = id;

    // get position of target textfield
    var target = kws.target;

    var pos = {x: 0, y: 0};
    if (typeof target != 'undefined')
        pos = mjt.get_element_position(target);

    // position according to kws.style,
    //  interpreting some of the values as relative
    //  to the target input position.
    for (var sk in kws.style) {
        var sv = kws.style[sk];
        if (typeof sv == 'number') {
            if (sk == 'left' || sk == 'right')
                sv = (sv + pos.x) + 'px';
            else if (sk == 'top' || sk == 'bottom')
                sv = (sv + pos.y) + 'px';
            else 
                sv = sv + 'px';
        }
        div.style[sk] = sv;
    }

    if (typeof target != 'undefined')
        div.style.position = 'absolute';

    document.body.appendChild(div);

    return div.id;
};

/**
 *
 * helper to get the coordinates of an element relative to toplevel
 *
 */
mjt.get_element_position = function (elt) {
    var x = 0, y = 0;

    while (elt.offsetParent) {
        x += elt.offsetLeft;
        y += elt.offsetTop;
        elt = elt.offsetParent;
    }

    // handle the toplevel
    if (elt.x)
        x += elt.x;
    if (elt.y)
        y += elt.y;

    return {x:x, y:y};
}

//////////////////////////////////////////////////////////////////////
/**
 *
 * generate a wikilink
 *   this belongs in a standard library instead of in mjt.js
 *
 */
mjt.ref = function (name) {
    var s = ['<a href="view?name=',
             mjt.formquote(name), '">',
             mjt.htmlencode(name), '</a>'
             ].join('');
    return new mjt.Markup(s);
};
/**
 *
 * generate link text for an object with .name and .id
 *   this belongs in a standard library instead of in mjt.js
 *
 */
mjt.link = function (o, t) {
    var name = o.id;
    var tname = o.name;
    if (typeof(tname) == 'object' && tname) {
        tname = tname.value;
    }
    if (typeof(tname) == 'string' && ! tname.match('^[ \n\r\t]*$')) {
        name = tname;
    }

    var s = ['<a href="', t, '?id=',
             mjt.formquote(o.id), '">',
             mjt.htmlencode(o.id), '</a>',
             ' (', mjt.htmlencode(name), ')'
             ].join('');
    return new mjt.Markup(s);
};

mjt.imgurl = function(cid, maxwidth, maxheight) {
    var qargs = {};
    if (typeof(maxwidth) == 'number') {
        qargs.maxwidth = parseInt('' + maxwidth);  // clean up
    }
    if (typeof(maxheight) == 'number') {
        qargs.maxheight = parseInt('' + maxheight);  // clean up
    }

    // XXX is this the right quoting?  only if id is a guid!
    return mjt.form_url(mjt.service_url + '/api/trans/image_thumb/'
                        + mjt.formquote(cid),
                        qargs);
};


mjt.htmlurl = function(cid) {
    // XXX is this the right quoting?  only if id is a guid!
    return mjt.service_url + '/api/trans/raw/' + mjt.formquote(cid);
};

/*
 *
 *  based on json.js 2006-04-28 from json.org
 *  license: http://www.json.org/license.html
 *
 *  inlined for download speed
 *  and subsequently hacked so it doesn't mess with Object.prototype
 *  
 *
 */
/*
    
    

    This file adds these methods to JavaScript:

        json_from_js(obj)

            This function produces a JSON text from a javascript
            value. The value must not contain any cyclical references.

        json_to_js()

            This function parses a JSON text to produce an object or
            array. It will return false if there is an error.
*/
(function () {
    var m = {
            '\b': '\\b',
            '\t': '\\t',
            '\n': '\\n',
            '\f': '\\f',
            '\r': '\\r',
            '"' : '\\"',
            '\\': '\\\\'
        },
        s = {
            array: function (x) {
                var a = ['['], b, f, i, l = x.length, v;
                for (i = 0; i < l; i += 1) {
                    v = x[i];
                    f = s[typeof v];
                    if (f) {
                        v = f(v);
                        if (typeof v == 'string') {
                            if (b) {
                                a[a.length] = ',';
                            }
                            a[a.length] = v;
                            b = true;
                        }
                    }
                }
                a[a.length] = ']';
                return a.join('');
            },
            'boolean': function (x) {
                return String(x);
            },
            'null': function (x) {
                return "null";
            },
            'undefined': function (x) {
                mjt.warn('mjt.json_from_js: undefined value is illegal in JSON');
                return "[[[ERROR: undefined value]]]";
            },
            number: function (x) {
                return isFinite(x) ? String(x) : 'null';
            },
            object: function (x) {
                if (x) {
                    if (x instanceof Array) {
                        return s.array(x);
                    }
                    var a = ['{'], b, f, i, v;
                    for (i in x) {
                        v = x[i];
                        f = s[typeof v];
                        if (f) {
                            v = f(v);
                            if (typeof v == 'string') {
                                if (b) {
                                    a[a.length] = ',';
                                }
                                a.push(s.string(i), ':', v);
                                b = true;
                            }
                        }
                    }
                    a[a.length] = '}';
                    return a.join('');
                }
                return 'null';
            },
            string: function (x) {
                if (/["\\\x00-\x1f]/.test(x)) {
                    x = x.replace(/([\x00-\x1f\\"])/g, function(a, b) {
                        var c = m[b];
                        if (c) {
                            return c;
                        }
                        c = b.charCodeAt();
                        return '\\u00' +
                            Math.floor(c / 16).toString(16) +
                            (c % 16).toString(16);
                    });
                }
                return '"' + x + '"';
            }
        };

    mjt.json_from_js = function (v) {
        return s[typeof v](v);
    };

})();

// XXX possibly relevant for IE6
// from http://tech.groups.yahoo.com/group/json/message/660
// > there is a bug in IE6 in which the greedy quantifiers cause the
// > regexp to run in exponential time. When the text gets big, IE gets
// > really really slow.

mjt.json_to_js = function (s) {
    try {
        if (/^[,:{}\[\]0-9.\-+Eaeflnr-u \n\r\t]*$/.test(s.
                    replace(/\\./g, '@').
                    replace(/"[^"\\\n\r]*"/g, ''))) {

            return eval('(' + s + ')');
        }
        throw new SyntaxError('json_to_js');
    } catch (e) {
        return false;
    }
};

//
//  end inlined json.js
//
//////////////////////////////////////////////////


/**
 *  mjt.Codeblock is a wrapper around eval() that
 *   allows better debugging of the evaluated code.
 *   mjt does lots of run-time code generation, and
 *   most javascript runtimes are very bad at tracking
 *   eval source code.
 */
mjt.Codeblock = function (name, codestr) {
    this.name = name;
    this.codestr = codestr;
    this.baseline = null;
};

mjt.Codeblock.prototype.handle_exception = function (msg, e) {
    var espec;
    var html;
    if (e instanceof Error) {
        espec = {
            lineNumber: e.lineNumber-this.baseline,
            name: e.name,
            message: e.message
        };
    } else {
        espec = {
            name: 'Unknown error',
            message: ''+e
        };
    }
    var errtext = '<source unavailable>';
    if (this.codestr) {
        this.extract_context(this.codestr, espec.lineNumber, 5, espec);
        var pfx = '---' + espec.lineNumber + '-->  '; 
        var spc = [];
        for (var i = 0; i < pfx.length; i++) spc.push(' ');
        spc = spc.join('');
    
        errtext = [spc, espec.prev_lines.join('\n'+spc),
                       '\n', pfx, espec.the_line, '\n',
                       spc, espec.next_lines.join('\n'+spc)].join('');
    }
    mjt.error('error', msg, espec,
              '\n    ' + espec.name + ': ' + espec.message + '\n',
              errtext);

    // hang the extra info off the error object for handlers upstack
    e.mjt_error = espec;
};
/**
 *
 * extract a particular line from a block of (presumably) source code.
 * the line in question is placed in cx.the_line
 * arrays of the previous and next RADIUS lines are placed in
 *   cx.prev_lines and cx.next_lines respectively.
 * cx is initialized to {} if not passed in.
 * returns cx
 *
 */
mjt.Codeblock.prototype.extract_context = function (codestr, lineno, radius, cx) {
    var source = [];

    var lines = codestr.split('\n');

    if (lineno < 0)
        lineno = 0;
    if (lineno >= lines.length)
        lineno = lines.length - 1;

    var line0 = lineno - radius;
    if (line0 < 0) line0 = 0;

    var prev_lines = [];
    for (line = line0; line < lineno; line++)
        prev_lines.push(lines[line]);

    var the_line = lines[lineno];

    var next_lines = [];
    for (line = lineno+1; line < lines.length && line < lineno + radius; line++)
        next_lines.push(lines[line]);

    if (typeof cx !== 'object')
        cx = {};

    cx.prev_lines = prev_lines;
    cx.the_line = the_line;
    cx.next_lines = next_lines;
    return cx;
};


mjt.Codeblock.prototype.evaluate = function () {
    // evaluate the code string, generating a new function object
    // that can be used to instantiate the template as a string of
    // html.

    var t0 = (new Date()).getTime();

    mjt.debug && mjt.spew('evaluating code ' + this.name, [this.codestr]);

    // //@line doesn't seem to work on firefox 1.5?
    // TODO try this to clean up line numbers on firefox
    //  - could use bogus high line number if we're decoding it
    //    ourselves, using the high section as a tag to find the eval src.
    /*
    var codestr = [//     '//@line 100000\n',
                   this.codestr,
                   '\n; var s = { main: main }; s;\n'].join('');
    */

    var codestr = this.codestr;
    var result;

    // fireclipse (and firebug 1.1?) have sweeter eval debugging,
    //  so we let any errors past.
    // TODO can we check firebug version?
    if (typeof console != 'undefined' && typeof console.trace == 'function') {
        result = eval(codestr);
    } else if (typeof window.navigator.appName === 'undefined') {
        // rhino + env.js - should have a better check than missing appName!
        result = eval(codestr);
    } else {
        // otherwise do what we can.
        // more suggestions on easier debugging here:
        //  http://www.nabble.com/Partial-solution-to-debugging-eval()-code-t3191584.html
        //  http://www.almaden.ibm.com/cs/people/bartonjj/fireclipse/test/DynLoadTest/WebContent/DynamicJavascriptErrors.htm
        // magic to get the current line number
        try { null(); } catch (e) { this.baseline = e.lineNumber + 2; }
        try {
            result = eval(codestr);
        } catch (e) {
            this.handle_exception('evaluating codeblock '+this.name, e);
            throw e;    // re-throw for other debuggers
        }
    }

    var dt = (new Date()).getTime() - t0;
    mjt.log('evaluated code in ', dt, 'msec, ', codestr.length, 'chars');

    return result;
};


//
//  ideally, mjt.Codeblock.prototype.evaluate should be the last
//  function in the file.  this reduces ambiguity with the bizarre
//  eval() linenumbers.
//
