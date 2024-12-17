'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter.js": "4b2350e14c6650ba82871f60906437ea",
"CNAME": "d129f76bb37a660e71a486a0c19c4a78",
"main.dart.js": "549d6d535d6f95b1617f7f5dc644d59b",
"assets/FontManifest.json": "ffcbdd66588b5749a2d471747b92b76b",
"assets/AssetManifest.bin": "fc4e8b0f3b255db42d5e22bc25d4b261",
"assets/fonts/MaterialIcons-Regular.otf": "a1816acfe11611d3b281a959ad98661e",
"assets/assets/font/HYYanKaiW.ttf": "e98379b85cc08373fb766f4cc6a99ca6",
"assets/assets/font/FZLTHProGlobal-Bold.TTF": "9e5f787a9ef19b5284e7e11c33605f1e",
"assets/assets/font/FZLTHProGlobal-Demibold.TTF": "840850dedc42b75e3ae1e5e807a297c4",
"assets/assets/font/FZLTHProGlobal-Regular.TTF": "2ebd63d3b95c125d19beecbb68dde077",
"assets/assets/font/STZongyi.ttf": "d33e9908f9cac9b28bd096ceebeef989",
"assets/assets/image/arrivalStationInfoBody.svg": "8ddf1950e43a661774fdb066dbc3d2dc",
"assets/assets/image/operationDirectionBodyLoop.svg": "7a1f07ba95f0e7931de4efc71ad29808",
"assets/assets/image/ledDirection.svg": "f209569f781bda768bb065328838f0e3",
"assets/assets/image/icon.png": "c86de06268a9a898803c3026d726e8b6",
"assets/assets/image/railwayTransitLogo.svg": "ffaf7aea3c721365af8aa6bb92b394a8",
"assets/assets/image/arrivalStationInfoDirectionToRight.svg": "057856199f7a1a77b29393c1a44f0a06",
"assets/assets/image/arrivalStationInfoBodyWithoutEntrance.svg": "38a05579067fa7aaec4bb05952e42d02",
"assets/assets/image/railwayTransitLogoVertical.svg": "5bae5579810dcc3b6b8443b0f1b305ca",
"assets/assets/image/arrivalStationInfoHere.svg": "d54d16996a8b896ef31c4915e93c3e45",
"assets/assets/image/arrivalStationInfoTransfer.svg": "d3e71ffbc7173ebc755b206d748e2463",
"assets/assets/image/arrivalStationInfoDirectionToLeft.svg": "c00c5d813de6fefa95fefd1d15119ecc",
"assets/assets/image/operationDirectionBody.svg": "d7cf3b09eba763203d1b72ae7f296f71",
"assets/NOTICES": "254aed0811022e8d3a7cccfe6b1b21af",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.json": "0716c7bfdf395a7efb80d64bb2d0640a",
"assets/AssetManifest.bin.json": "4b4f1969787b2daf7a71a065f293ae6a",
"index.html": "13f7e815bb018ae87952a06567da8192",
"/": "13f7e815bb018ae87952a06567da8192",
"manifest.json": "d6d63c0d3667c089447a27d5ad9452a5",
"canvaskit/canvaskit.js": "26eef3024dbc64886b7f48e1b6fb05cf",
"canvaskit/canvaskit.js.symbols": "efc2cd87d1ff6c586b7d4c7083063a40",
"canvaskit/chromium/canvaskit.js": "b7ba6d908089f706772b2007c37e6da4",
"canvaskit/chromium/canvaskit.js.symbols": "e115ddcfad5f5b98a90e389433606502",
"canvaskit/chromium/canvaskit.wasm": "ea5ab288728f7200f398f60089048b48",
"canvaskit/skwasm.js": "ac0f73826b925320a1e9b0d3fd7da61c",
"canvaskit/skwasm.js.symbols": "96263e00e3c9bd9cd878ead867c04f3c",
"canvaskit/canvaskit.wasm": "e7602c687313cfac5f495c5eac2fb324",
"canvaskit/skwasm.wasm": "828c26a0b1cc8eb1adacbdd0c5e8bcfa",
"canvaskit/skwasm.worker.js": "89990e8c92bcb123999aa81f7e203b1c",
"icons/Icon-maskable-192.png": "ab2e8dcda2df2d57172fb19d1cf6f135",
"icons/Icon-192.png": "ab2e8dcda2df2d57172fb19d1cf6f135",
"icons/Icon-512.png": "9ed3a656c42749f16b4d3472eeb7922c",
"icons/Icon-maskable-512.png": "9ed3a656c42749f16b4d3472eeb7922c",
"favicon.png": "e6c64f9c292917f9c1e906dd252fd058",
"version.json": "19cb6f3c8e11aca96e71284b7548d40b",
"flutter_bootstrap.js": "78eb3950e8dda03c986fb6ba40768452"};
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
