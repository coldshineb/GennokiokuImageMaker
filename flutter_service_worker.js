'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/NOTICES": "5ba9173407434d840a9cee06bc3b1dd1",
"assets/AssetManifest.bin.json": "3fe17632143edc623be9b083683d9b30",
"assets/FontManifest.json": "ffcbdd66588b5749a2d471747b92b76b",
"assets/assets/font/FZLTHProGlobal-Regular.TTF": "2ebd63d3b95c125d19beecbb68dde077",
"assets/assets/font/STZongyi.ttf": "d33e9908f9cac9b28bd096ceebeef989",
"assets/assets/font/FZLTHProGlobal-Demibold.TTF": "840850dedc42b75e3ae1e5e807a297c4",
"assets/assets/font/FZLTHProGlobal-Bold.TTF": "9e5f787a9ef19b5284e7e11c33605f1e",
"assets/assets/font/HYYanKaiW.ttf": "e98379b85cc08373fb766f4cc6a99ca6",
"assets/assets/image/railwayTransitLogoVertical.svg": "5bae5579810dcc3b6b8443b0f1b305ca",
"assets/assets/image/arrivalStationInfoDirectionToLeft.svg": "c00c5d813de6fefa95fefd1d15119ecc",
"assets/assets/image/arrivalStationInfoBodyWithoutEntrance.svg": "38a05579067fa7aaec4bb05952e42d02",
"assets/assets/image/arrivalStationInfoHere.svg": "d54d16996a8b896ef31c4915e93c3e45",
"assets/assets/image/operationDirectionBody.svg": "d7cf3b09eba763203d1b72ae7f296f71",
"assets/assets/image/railwayTransitLogo.svg": "ffaf7aea3c721365af8aa6bb92b394a8",
"assets/assets/image/operationDirectionBodyLoop.svg": "7a1f07ba95f0e7931de4efc71ad29808",
"assets/assets/image/arrivalStationInfoDirectionToRight.svg": "057856199f7a1a77b29393c1a44f0a06",
"assets/assets/image/arrivalStationInfoTransfer.svg": "d3e71ffbc7173ebc755b206d748e2463",
"assets/assets/image/arrivalStationInfoBody.svg": "8ddf1950e43a661774fdb066dbc3d2dc",
"assets/fonts/MaterialIcons-Regular.otf": "0f54014025e0511088cb9a458615d833",
"assets/AssetManifest.json": "c01704d227a0ffb2c31cde2688bf5980",
"assets/AssetManifest.bin": "29e79851a6e67623145528407ad4949a",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"index.html": "6fa18e555d4e8a9d3162ccd12304ca8d",
"/": "6fa18e555d4e8a9d3162ccd12304ca8d",
"flutter.js": "383e55f7f3cce5be08fcf1f3881f585c",
"canvaskit/canvaskit.wasm": "9251bb81ae8464c4df3b072f84aa969b",
"canvaskit/skwasm.worker.js": "bfb704a6c714a75da9ef320991e88b03",
"canvaskit/canvaskit.js": "738255d00768497e86aa4ca510cce1e1",
"canvaskit/canvaskit.js.symbols": "74a84c23f5ada42fe063514c587968c6",
"canvaskit/skwasm.wasm": "4051bfc27ba29bf420d17aa0c3a98bce",
"canvaskit/skwasm.js.symbols": "c3c05bd50bdf59da8626bbe446ce65a3",
"canvaskit/skwasm.js": "5d4f9263ec93efeb022bb14a3881d240",
"canvaskit/chromium/canvaskit.wasm": "399e2344480862e2dfa26f12fa5891d7",
"canvaskit/chromium/canvaskit.js": "901bb9e28fac643b7da75ecfd3339f3f",
"canvaskit/chromium/canvaskit.js.symbols": "ee7e331f7f5bbf5ec937737542112372",
"flutter_bootstrap.js": "ebe4e6813603d70971a014e5a54b00b4",
"main.dart.js": "65187952b2e2f097d5803a3559f8b025",
"icons/Icon-maskable-512.png": "9ed3a656c42749f16b4d3472eeb7922c",
"icons/Icon-maskable-192.png": "ab2e8dcda2df2d57172fb19d1cf6f135",
"icons/Icon-512.png": "9ed3a656c42749f16b4d3472eeb7922c",
"icons/Icon-192.png": "ab2e8dcda2df2d57172fb19d1cf6f135",
"manifest.json": "d6d63c0d3667c089447a27d5ad9452a5",
"version.json": "77d22c6d08cba6be42ad3f114a303a0a",
"favicon.png": "e6c64f9c292917f9c1e906dd252fd058"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
