# Releasing

Releases publish the compiled ABI catalog as a GitHub release asset, so
downstream tools pin an exact catalog by version and checksum instead of
committing a copy of it.

## Versioning

Versions follow [Semantic Versioning](https://semver.org/) and describe the
published catalog as downstream tools see it:

- **Major** — a change that can break a consumer relying on stable contract IDs:
  removing or renaming an ID, moving a code hash to another ID, or changing the
  catalog `schemaVersion`. Before 1.0.0 these bump the minor version.
- **Minor** — additive content: new contract entries, code hashes, known
  addresses, messages or getters.
- **Patch** — corrections that keep IDs and hashes where they are, such as
  descriptions, links, or an ABI fixed to match the deployed code.

Moving the release workflow to another Acton release changes every entry's
`compiler_version`, and therefore the asset checksum, even when no layout
changes. Release it at least as a patch, and compare the catalogs before and
after to decide whether it is more.

## Publishing a release

1. Move the `[Unreleased]` entries in `CHANGELOG.md` under a new
   `## [X.Y.Z] - YYYY-MM-DD` heading.
2. Set `version` under `[package]` in `Acton.toml` to `X.Y.Z`.
3. Merge both changes into `master`.
4. Tag the merge commit and push the tag:

   ```sh
   git tag vX.Y.Z
   git push origin vX.Y.Z
   ```

The [release workflow](.github/workflows/release.yml) rejects a tag that does
not match `Acton.toml` or has no `CHANGELOG.md` section, builds the catalog with
the Acton release pinned in `[toolchain].acton`, and publishes:

- `abi-catalog.json` — the compact catalog, exactly as `cargo xtask bundle`
  writes it;
- `abi-catalog.json.sha256` — its checksum in `sha256sum` format.

The release notes record the source commit, the Acton version and the checksum.

## Reproducing a release

Check out the tag, install the Acton version named in its release notes, and
compare against the published checksum:

```sh
cargo xtask bundle --out abi-catalog.json
sha256sum -c abi-catalog.json.sha256
```

Output built with `--pretty` is formatted for reading and never matches it.

## Consuming a release

Pin both the version and the checksum, and verify the file before use:

```sh
curl -fsSLO https://github.com/ton-blockchain/abis/releases/download/vX.Y.Z/abi-catalog.json
echo "<sha256>  abi-catalog.json" | sha256sum -c
```
