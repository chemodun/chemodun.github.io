'use strict';

// Read the files out of a .tar.gz, in memory, with node builtins only.
//
// The site has one dependency and the extraction half has none, which is what
// lets the weekly workflow skip `npm ci` entirely. A tar is 512-byte headers each
// followed by the file's bytes padded to 512, so the reader that gets 19 .xpl
// files out of a GitHub tarball is shorter than the install would be.

const zlib = require('zlib');

const str = (buf, off, len) => buf.toString('utf8', off, off + len).replace(/\0.*$/, '').trim();

// Returns [{ name, data }] for regular files whose path passes `keep`.
function readTarGz(gz, keep = () => true) {
  const tar = zlib.gunzipSync(gz);
  const out = [];
  for (let off = 0; off + 512 <= tar.length;) {
    const header = tar.subarray(off, off + 512);
    if (header.every((b) => b === 0)) break; // two zero blocks end the archive
    let name = str(header, 0, 100);
    const prefix = str(header, 345, 155);
    if (prefix) name = prefix + '/' + name;
    const size = parseInt(str(header, 124, 12) || '0', 8) || 0;
    const type = String.fromCharCode(header[156]) || '0';
    const body = off + 512;
    // '0'/'\0' are a regular file; everything else here is a directory or a long-name
    // extension, and neither carries content this pipeline wants.
    if ((type === '0' || type === '\0') && keep(name)) out.push({ name, data: tar.subarray(body, body + size) });
    off = body + Math.ceil(size / 512) * 512;
  }
  return out;
}

module.exports = { readTarGz };
