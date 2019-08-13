/* eslint-disable no-undef */
const MAX_STRING_LENGTH = 200;

var _ = {};

var ArrayProto = Array.prototype,
    ObjProto = Object.prototype,
    slice = ArrayProto.slice,
    toString = ObjProto.toString,
    hasOwnProperty = ObjProto.hasOwnProperty,
    nativeForEach = ArrayProto.forEach,
    nativeIsArray = Array.isArray,
    breaker = {};


_.each = function (obj, iterator, context) {
    // eslint-disable-next-line eqeqeq
    if (obj == null) {
        return false;
    }
    if (nativeForEach && obj.forEach === nativeForEach) {
        obj.forEach(iterator, context);
    } else if (obj.length === +obj.length) {
        for (var i = 0, l = obj.length; i < l; i++) {
            if (i in obj && iterator.call(context, obj[i], i, obj) === breaker) {
                return false;
            }
        }
    } else {
        for (var key in obj) {
            if (hasOwnProperty.call(obj, key)) {
                if (iterator.call(context, obj[key], key, obj) === breaker) {
                    return false;
                }
            }
        }
    }
};

_.extend = function (obj) {
    _.each(slice.call(arguments, 1), function (source) {
        for (var prop in source) {
            if (source[prop] !==
                void 0) {
                obj[prop] = source[prop];
            }
        }
    });
    return obj;
};

_.extend2Layers = function (obj) {
    _.each(slice.call(arguments, 1), function (source) {
        for (var prop in source) {
            if (source[prop] !== void 0) {
                if (_.isObject(source[prop]) && _.isObject(obj[prop])) {
                    _.extend(obj[prop], source[prop]);
                } else {
                    obj[prop] = source[prop];
                }
            }
        }
    });
    return obj;
};

_.isArray = nativeIsArray || function (obj) {
    return toString.call(obj) === '[object Array]';
};

_.isFunction = function (f) {
    try {
        return /^\s*\bfunction\b/.test(f);
    } catch (x) {
        return false;
    }
};

_.isObject = function (obj) {
    return (toString.call(obj) === '[object Object]') && (obj !== null);
};

_.isEmptyObject = function (obj) {
    if (_.isObject(obj)) {
        for (var key in obj) {
            if (hasOwnProperty.call(obj, key)) {
                return false;
            }
        }
        return true;
    }
    return false;
};

_.isUndefined = function (obj) {
    return obj === void 0;
};

_.isString = function (obj) {
    return toString.call(obj) === '[object String]';
};

_.isDate = function (obj) {
    return toString.call(obj) === '[object Date]';
};

_.isBoolean = function (obj) {
    return toString.call(obj) === '[object Boolean]';
};

_.isNumber = function (obj) {
    // eslint-disable-next-line no-useless-escape
    return (toString.call(obj) === '[object Number]' && /[\d\.]+/.test(String(obj)));
};

_.isJSONString = function (str) {
    try {
        JSON.parse(str);
    } catch (e) {
        return false;
    }
    return true;
};
_.decodeURIComponent = function (val) {
    var result = '';
    try {
        result = decodeURIComponent(val);
    } catch (e) {
        result = val;
    }
    return result;
};

_.encodeDates = function (obj) {
    _.each(obj, function (v, k) {
        if (_.isDate(v)) {
            obj[k] = _.formatDate(v);
        } else if (_.isObject(v)) {
            obj[k] = _.encodeDates(v);
        }
    });
    return obj;
};

_.formatDate = function (d) {
    function pad(n) {
        return n < 10 ? '0' + n : n;
    }

    function secondPad(n) {
        if (n < 100 && n > 9)
            return '0' + n;
        else if (n < 10)
            return '00' + n;
        else
            return n;
    }
    return d.getFullYear() + '-' + pad(d.getMonth() + 1) + '-' + pad(d.getDate()) + ' ' +
        pad(d.getHours()) + ':' + pad(d.getMinutes()) + ':' + pad(d.getSeconds()) + '.' + secondPad(d.getMilliseconds());
};

_.searchObjDate = function (o) {
    if (_.isObject(o)) {
        _.each(o, function (a, b) {
            if (_.isObject(a)) {
                _.searchObjDate(o[b]);
            } else {
                if (_.isDate(a)) {
                    o[b] = _.formatDate(a);
                }
            }
        });
    }
};

_.formatString = function (str) {
    if (str.length > MAX_STRING_LENGTH) {
        logger.info('字符串长度超过限制，已经做截取--' + str);
        return str.slice(0, MAX_STRING_LENGTH);
    } else {
        return str;
    }
};

_.searchObjString = function (o) {
    if (_.isObject(o)) {
        _.each(o, function (a, b) {
            if (_.isObject(a)) {
                _.searchObjString(o[b]);
            } else {
                if (_.isString(a)) {
                    o[b] = _.formatString(a);
                }
            }
        });
    }
};


_.UUID = function () {
    var visitTime = (new Date())
        .getTime();
    var uuid = '' + String(Math.random())
        .replace('.', '')
        .slice(1, 11) + '-' + visitTime;
    return uuid;
};

_.UUIDv4 = function () {
    return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function (c) {
        var r = Math.random() * 16 | 0,
            // eslint-disable-next-line eqeqeq
            v = c == 'x' ? r : (r & 0x3 | 0x8);
        return v.toString(16);
    });
};

var logger = typeof logger === 'object' ? logger : {};
logger.info = function () {
    if (typeof console === 'object' && console.log && logger.enabled) {
        try {
            return console.log.apply(console, arguments);
        } catch (e) {
            console.log(arguments[0]);
        }
    }
};

logger.warn = function () {
    if (typeof console === 'object' && console.log && logger.enabled) {
        try {
            return console.warn.apply(console, arguments);
        } catch (e) {
            console.warn(arguments[0]);
        }
    }

};

export {
    _,
    logger,
    slice,
};
