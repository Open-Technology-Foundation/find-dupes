# find-dupes

Find and optionally delete duplicate files based on content hash.

Recursively scans a directory, groups files by SHA-256 hash, reports duplicates with modification timestamps, and can delete them (keeping the oldest).

```bash
git clone https://github.com/Open-Technology-Foundation/find-dupes.git && cd find-dupes && sudo make install
```

## Features

- **Size pre-filtering** -- only hashes files that share a size, skipping unique files entirely
- **Hard link awareness** -- detects same-inode files and excludes them from duplicate groups
- **Extension filtering** -- scan specific file types or all files
- **Safe deletion** -- keeps the oldest file, prompts before deleting (unless `--force`)
- **Backslash-safe** -- correctly handles filenames containing `\` characters

## Usage

```
find-dupes [OPTIONS] DIRECTORY
```

## Options

| Option | Description |
|--------|-------------|
| `-e, --extensions EXT` | Comma-separated extensions (default: `.txt,.md`). Use `"*"` for all files |
| `-d, --delete` | Delete duplicate files (keeps oldest) |
| `-f, --force` | Delete without confirmation prompt |
| `-v, --verbose` | Verbose output (default) |
| `-q, --quiet` | Suppress informational output |
| `-V, --version` | Print version and exit |
| `-h, --help` | Print help and exit |

Short options can be bundled: `-df` is equivalent to `-d -f`.

## Examples

```bash
# Find duplicate text/markdown files
find-dupes /path/to/dir

# Find duplicate images
find-dupes /path/to/dir -e ".jpg,.png,.gif"

# Scan all file types
find-dupes /path/to/dir -e "*"

# Delete duplicates (prompted)
find-dupes /path/to/dir -d

# Delete duplicates without asking
find-dupes /path/to/dir -df
```

## How It Works

The script uses a three-phase pipeline:

1. **Size grouping** -- files are grouped by size using `stat`. Files with a unique size cannot be duplicates and are skipped.
2. **Content hashing** -- only files sharing a size are hashed with `sha256sum`. Files with identical hashes are grouped as duplicates.
3. **Inode deduplication** -- hard links (same `dev:inode`) within a group are collapsed, preventing false positives.

When deleting, the oldest file (by modification time) in each group is preserved.

## Install

```bash
git clone https://github.com/Open-Technology-Foundation/find-dupes.git
cd find-dupes
sudo make install
```

This installs:
- `find-dupes` to `/usr/local/bin/`
- manpage to `/usr/local/share/man/man1/`
- bash completion to `/etc/bash_completion.d/` (if the directory exists)

To customise the install prefix:

```bash
sudo make PREFIX=/opt/local install
```

To uninstall:

```bash
sudo make uninstall
```

## Requirements

- Bash 5.0+
- GNU coreutils (`sha256sum`, `stat`, `find`, `xargs`)

## License

MIT

#fin
