// Serves _site/ so the site can be opened the way it is published.
//
//   node src/serve.js [port]
//
// The site is a user site: every link is root-relative, so opening _site/**/index.html
// through file:// resolves "/" to the filesystem root and nothing navigates. There has
// to be a server, and this one has no dependencies so it also works offline.

const fs = require('fs');
const path = require('path');
const http = require('http');

const ROOT = path.join(__dirname, '..', '_site');
const PORT = Number(process.argv[2] || process.env.PORT || 8080);

const TYPES = {
  '.html': 'text/html; charset=utf-8', '.css': 'text/css; charset=utf-8',
  '.js': 'text/javascript; charset=utf-8', '.json': 'application/json; charset=utf-8',
  '.svg': 'image/svg+xml', '.png': 'image/png', '.jpg': 'image/jpeg',
  '.lua': 'text/plain; charset=utf-8', '.ico': 'image/x-icon', '.woff2': 'font/woff2', '.txt': 'text/plain; charset=utf-8',
};

// A directory URL serves its index.html, which is what Pages does.
function resolve(urlPath) {
  const rel = decodeURIComponent(urlPath.split('?')[0].split('#')[0]);
  const file = path.join(ROOT, path.normalize(rel).replace(/^[/\\]+/, ''));
  if (!file.startsWith(ROOT)) return null;
  if (fs.existsSync(file) && fs.statSync(file).isDirectory()) {
    return path.join(file, 'index.html');
  }
  return file;
}

function createServer() {
  return http.createServer((req, res) => {
    const file = resolve(req.url);
    if (!file || !fs.existsSync(file) || fs.statSync(file).isDirectory()) {
      res.writeHead(404, { 'content-type': 'text/plain' });
      return res.end('404 ' + req.url);
    }
    res.writeHead(200, {
      'content-type': TYPES[path.extname(file).toLowerCase()] || 'application/octet-stream',
      'cache-control': 'no-store',
    });
    fs.createReadStream(file).pipe(res);
  });
}

// Port 0 picks a free one, which is what check-pages.js wants.
function listen(port = PORT) {
  return new Promise((res) => {
    const server = createServer().listen(port, '127.0.0.1', () => res(server));
  });
}

if (require.main === module) {
  listen().then((server) => {
    if (!fs.existsSync(ROOT)) console.log('_site/ is missing - run the build first');
    console.log('http://localhost:' + server.address().port + '/');
  });
}

module.exports = { ROOT, createServer, listen };
