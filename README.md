# Installation

# Sass 
```bash
brew install --devel sass/sass/sass
```

# Build
```
./build.sh --debug
```

# Deploy

Build release package and release a new version
```
./build.sh --release <release-type: (patch | minor | major]> --publish <optional, default:false>
```
Default to `patch`

Patch will increase the semver by 0.0.1
Minor will increase the semver by 0.1.0
Major will increase the semver by 1.0.0
