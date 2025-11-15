const CACHE_NAME = 'notas-shell-v1';
const DATA_CACHE = 'notas-data-v1';
const OFFLINE_URL = 'offline.html';
const FILES_TO_CACHE = [
  '/',
  '/index.html',
  '/manifest.json',
  '/favicon.png'
];

self.addEventListener('install', (evt) => {
  self.skipWaiting();
  evt.waitUntil(
    caches.open(CACHE_NAME).then((cache) => cache.addAll(FILES_TO_CACHE))
  );
});

self.addEventListener('activate', (evt) => {
  evt.waitUntil(
    caches.keys().then(keys => Promise.all(keys.map(key => {
      if (key !== CACHE_NAME && key !== DATA_CACHE) return caches.delete(key);
    })))
  );
  self.clients.claim();
});

self.addEventListener('fetch', (evt) => {
const url = new URL(evt.request.url);

  if (evt.request.mode === 'navigate') {
    evt.respondWith(fetch(evt.request).catch(() => caches.match(OFFLINE_URL)));
    return;
  }

  evt.respondWith(
    caches.match(evt.request).then(resp => resp || fetch(evt.request).then(r => {
      return r;
    }))
  );
});
