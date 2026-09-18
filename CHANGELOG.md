# Changelog

All notable changes to this project will be documented in this file.

The project follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).
Versioned release policy is described in [RELEASING.md](RELEASING.md).

## [Unreleased]

## [0.1.2] - 2026-09-18

### Changed

- Build the catalog with Acton 1.2.0, which bundles Tolk 1.4.2. No interface changed; every entry's `compiler_version` did

## [0.1.1] - 2026-09-15

This is a test build.

## [0.1.0] - 2026-09-15

### Added

- Standard TEP-74 Jetton Master and Wallet interfaces without implementation-specific storage, errors or code hashes
- Telegram Wallet rev00 ABI, immutable trampoline fixture, and source provenance
- Versioned releases publishing the compact ABI catalog `abi-catalog.json` with its SHA-256 checksum, described in `RELEASING.md`
