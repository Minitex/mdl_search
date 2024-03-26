var MDLdrawMap =
/******/ (function(modules) { // webpackBootstrap
/******/ 	// The module cache
/******/ 	var installedModules = {};
/******/
/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {
/******/
/******/ 		// Check if module is in cache
/******/ 		if(installedModules[moduleId]) {
/******/ 			return installedModules[moduleId].exports;
/******/ 		}
/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = installedModules[moduleId] = {
/******/ 			i: moduleId,
/******/ 			l: false,
/******/ 			exports: {}
/******/ 		};
/******/
/******/ 		// Execute the module function
/******/ 		modules[moduleId].call(module.exports, module, module.exports, __webpack_require__);
/******/
/******/ 		// Flag the module as loaded
/******/ 		module.l = true;
/******/
/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}
/******/
/******/
/******/ 	// expose the modules object (__webpack_modules__)
/******/ 	__webpack_require__.m = modules;
/******/
/******/ 	// expose the module cache
/******/ 	__webpack_require__.c = installedModules;
/******/
/******/ 	// define getter function for harmony exports
/******/ 	__webpack_require__.d = function(exports, name, getter) {
/******/ 		if(!__webpack_require__.o(exports, name)) {
/******/ 			Object.defineProperty(exports, name, { enumerable: true, get: getter });
/******/ 		}
/******/ 	};
/******/
/******/ 	// define __esModule on exports
/******/ 	__webpack_require__.r = function(exports) {
/******/ 		if(typeof Symbol !== 'undefined' && Symbol.toStringTag) {
/******/ 			Object.defineProperty(exports, Symbol.toStringTag, { value: 'Module' });
/******/ 		}
/******/ 		Object.defineProperty(exports, '__esModule', { value: true });
/******/ 	};
/******/
/******/ 	// create a fake namespace object
/******/ 	// mode & 1: value is a module id, require it
/******/ 	// mode & 2: merge all properties of value into the ns
/******/ 	// mode & 4: return value when already ns object
/******/ 	// mode & 8|1: behave like require
/******/ 	__webpack_require__.t = function(value, mode) {
/******/ 		if(mode & 1) value = __webpack_require__(value);
/******/ 		if(mode & 8) return value;
/******/ 		if((mode & 4) && typeof value === 'object' && value && value.__esModule) return value;
/******/ 		var ns = Object.create(null);
/******/ 		__webpack_require__.r(ns);
/******/ 		Object.defineProperty(ns, 'default', { enumerable: true, value: value });
/******/ 		if(mode & 2 && typeof value != 'string') for(var key in value) __webpack_require__.d(ns, key, function(key) { return value[key]; }.bind(null, key));
/******/ 		return ns;
/******/ 	};
/******/
/******/ 	// getDefaultExport function for compatibility with non-harmony modules
/******/ 	__webpack_require__.n = function(module) {
/******/ 		var getter = module && module.__esModule ?
/******/ 			function getDefault() { return module['default']; } :
/******/ 			function getModuleExports() { return module; };
/******/ 		__webpack_require__.d(getter, 'a', getter);
/******/ 		return getter;
/******/ 	};
/******/
/******/ 	// Object.prototype.hasOwnProperty.call
/******/ 	__webpack_require__.o = function(object, property) { return Object.prototype.hasOwnProperty.call(object, property); };
/******/
/******/ 	// __webpack_public_path__
/******/ 	__webpack_require__.p = "/packs-test/";
/******/
/******/
/******/ 	// Load entry module and return exports
/******/ 	return __webpack_require__(__webpack_require__.s = "./app/javascript/packs/drawMap.js");
/******/ })
/************************************************************************/
/******/ ({

/***/ "./app/javascript/draw_map.js":
/*!************************************!*\
  !*** ./app/javascript/draw_map.js ***!
  \************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
eval("__webpack_require__.r(__webpack_exports__);\n/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, \"default\", function() { return drawMap; });\n/* harmony import */ var _needle_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./needle.js */ \"./app/javascript/needle.js\");\n/* harmony import */ var _linked_thumbnail_js__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ./linked_thumbnail.js */ \"./app/javascript/linked_thumbnail.js\");\n\n\nfunction pinHTML(location) {\n  return new _linked_thumbnail_js__WEBPACK_IMPORTED_MODULE_1__[\"default\"](location.title_ssi, location.id, location.type_ssi, location.anchor).toHtml();\n}\nfunction reDrawMap(coordinates, needle) {\n  const coords = `${coordinates.lat},${coordinates.lng}`.replace(/\\./g, '+');\n  $.ajax({\n    url: `/nearbys/${coords}`,\n    jsonp: 'callback',\n    dataType: 'jsonp',\n    success: function (nearbyLocations) {\n      nearbyLocations.forEach(location => {\n        needle.pinIt(location.coordinates_llsi.split(','), pinHTML(location));\n      });\n    },\n    error: function (xhr, type, exception) {\n      console(`${type} ---- ${exception}`);\n    }\n  });\n}\nfunction drawMap(coordinates, nearbyLocations, mapName) {\n  const needle = new _needle_js__WEBPACK_IMPORTED_MODULE_0__[\"default\"](coordinates, mapName);\n  nearbyLocations.forEach(location => {\n    needle.pinIt(location.coordinates_llsi.split(','), pinHTML(location), `${location.title_ssi.substring(0, 50)}...`);\n  });\n  needle.onMove(reDrawMap, needle);\n  return needle;\n}\n\n//# sourceURL=webpack://MDL%5Bname%5D/./app/javascript/draw_map.js?");

/***/ }),

/***/ "./app/javascript/draw_map_with_popup.js":
/*!***********************************************!*\
  !*** ./app/javascript/draw_map_with_popup.js ***!
  \***********************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
eval("__webpack_require__.r(__webpack_exports__);\n/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, \"default\", function() { return drawMapWithPopup; });\n/* harmony import */ var _draw_map_js__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./draw_map.js */ \"./app/javascript/draw_map.js\");\n/* harmony import */ var _linked_thumbnail_js__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ./linked_thumbnail.js */ \"./app/javascript/linked_thumbnail.js\");\n\n\nfunction drawMapWithPopup(title, id, type, coordinates, nearbyLocations, mapName) {\n  const pinHTML = new _linked_thumbnail_js__WEBPACK_IMPORTED_MODULE_1__[\"default\"](title, id, type).toHtml();\n  Object(_draw_map_js__WEBPACK_IMPORTED_MODULE_0__[\"default\"])(coordinates, nearbyLocations, mapName).pinIt(coordinates, pinHTML).openPopup();\n}\n\n//# sourceURL=webpack://MDL%5Bname%5D/./app/javascript/draw_map_with_popup.js?");

/***/ }),

/***/ "./app/javascript/linked_thumbnail.js":
/*!********************************************!*\
  !*** ./app/javascript/linked_thumbnail.js ***!
  \********************************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
eval("__webpack_require__.r(__webpack_exports__);\n/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, \"default\", function() { return LinkedThumbnail; });\nclass LinkedThumbnail {\n  constructor(title, id, type, anchorPath) {\n    this.title = title;\n    this.id = id;\n    this.type = type;\n    this.anchorPath = anchorPath;\n    this.toHtml = this.toHtml.bind(this);\n    this.thumbnail = this.thumbnail.bind(this);\n  }\n  toHtml() {\n    return [`${this.recordLink('thumbnail', this.thumbnail())}`, `${this.recordLink(this.title, this.title)}`].join(' ');\n  }\n  recordLink(alt, data) {\n    return `<a href=\"/catalog/${this.id}?pn=false#${this.anchorPath}\" alt=\"${alt}\" class=\"map-pin-link\">${data}</a>`;\n  }\n  thumbnail() {\n    return `<div><img alt=\"${this.title}\" src=\"/thumbnails/${this.id}/${this.type}\" /></div>`;\n  }\n}\n\n//# sourceURL=webpack://MDL%5Bname%5D/./app/javascript/linked_thumbnail.js?");

/***/ }),

/***/ "./app/javascript/needle.js":
/*!**********************************!*\
  !*** ./app/javascript/needle.js ***!
  \**********************************/
/*! exports provided: default */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
eval("__webpack_require__.r(__webpack_exports__);\n/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, \"default\", function() { return Needle; });\n// \"[Pine] Needle,\" a Leaflet wrapper\nclass Needle {\n  static config(coordinates) {\n    return {\n      attribution: '&copy; <a href=\"http://osm.org/copyright\">OpenStreetMap</a> contributors',\n      center: coordinates,\n      id: 'cj17xqnh8003j2rquui5gm3ar',\n      minZoom: 7\n    };\n  }\n  constructor(coordinates) {\n    let mapName = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : 'mdl_map';\n    this.coordinates = coordinates;\n    this.mapName = mapName;\n    this._map = this._map.bind(this);\n    this._tileIt = this._tileIt.bind(this);\n    this.pinIt = this.pinIt.bind(this);\n    this._attachMap = this._attachMap.bind(this);\n    this._attachMap();\n    this.onMove = this.onMove.bind(this);\n  }\n  onMove(handler) {\n    for (var _len = arguments.length, args = new Array(_len > 1 ? _len - 1 : 0), _key = 1; _key < _len; _key++) {\n      args[_key - 1] = arguments[_key];\n    }\n    this.map.on('dragend', function (e) {\n      handler(e.target.getCenter(), ...args);\n    });\n  }\n  pinIt(coordinates, pinHTML, altText) {\n    return L.marker(coordinates, {\n      alt: `Pin for: ${altText}`\n    }).bindPopup(pinHTML).addTo(this.map);\n  }\n\n  // Initialize the map and attach it to the DOM\n  _attachMap() {\n    this.map = this._map();\n    this._tileIt();\n  }\n  _tileIt() {\n    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', Needle.config(this.coordinates)).addTo(this.map);\n  }\n  _map() {\n    if (!this.maplib) {\n      this.maplib = L.map(this.mapName).setView(this.coordinates, 10);\n    }\n    return this.maplib;\n  }\n}\n\n//# sourceURL=webpack://MDL%5Bname%5D/./app/javascript/needle.js?");

/***/ }),

/***/ "./app/javascript/packs/drawMap.js":
/*!*****************************************!*\
  !*** ./app/javascript/packs/drawMap.js ***!
  \*****************************************/
/*! exports provided: drawMap, drawMapWithPopup */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
eval("__webpack_require__.r(__webpack_exports__);\n/* harmony import */ var _draw_map__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ../draw_map */ \"./app/javascript/draw_map.js\");\n/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, \"drawMap\", function() { return _draw_map__WEBPACK_IMPORTED_MODULE_0__[\"default\"]; });\n\n/* harmony import */ var _draw_map_with_popup__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ../draw_map_with_popup */ \"./app/javascript/draw_map_with_popup.js\");\n/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, \"drawMapWithPopup\", function() { return _draw_map_with_popup__WEBPACK_IMPORTED_MODULE_1__[\"default\"]; });\n\n\n\n\n//# sourceURL=webpack://MDL%5Bname%5D/./app/javascript/packs/drawMap.js?");

/***/ })

/******/ });