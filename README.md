# PharoEDA Errors

This project provides error handling mechanisms for PharoEDA.

## Motivation

PharoEDA applications need to deal with errors. Sometimes logging them is enough. Sometimes a sophisticated mechanism is needed.
This project provides the supported mechanisms available to any PharoEDA application.

## Design

PharoEDA-Errors contains pluggable strategy implementations, so each can replace one another.

## Usage

This repository gets loaded when you load PharoEDA itself.

However, you can load it manually with Metacello:

```smalltalk
Metacello new repository: 'github://osoco/pharo-eda-errors:main'; baseline: #PharoEDAErrors; load
```

## Credits

- Background of the Pharo image by <a href="https://pixabay.com/users/stevepb-282134/?utm_source=link-attribution&amp;utm_medium=referral&amp;utm_campaign=image&amp;utm_content=876597">Steve Buissinne</a> from <a href="https://pixabay.com/?utm_source=link-attribution&amp;utm_medium=referral&amp;utm_campaign=image&amp;utm_content=876597">Pixabay</a>.
