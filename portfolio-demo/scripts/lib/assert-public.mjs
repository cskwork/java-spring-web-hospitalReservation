import { createHash } from 'node:crypto';
// Fingerprints only: do not copy original configuration values into new source.
const blocked = new Set(['158d20dc1bee9740c76e0f1e25a1fffb8a138800781c8b68bcf9812df4a66af1', '017f6bce6fddbfdcd4e1e180297306356fcfd728eeb2fb58a02aecc1d6a69d5d', '0dc8efe3abf67d00615bc4519b369a4c0f37f90c19699ab717b8e239a0caf46b', 'f1167f6e8624f09bf039c51b48509625e720fa2c787af0fae83b919694699f4d']);
export function assertNoKnownSecrets(text) {
  for (const token of text.match(/[A-Za-z0-9_]{8,}/g) || []) {
    if (blocked.has(createHash('sha256').update(token).digest('hex'))) {
      throw new Error('Known original configuration value must not be published');
    }
  }
}
