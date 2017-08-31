# initial.d

A Toyota AE86 for your terminals.

![Screenshot](http://nilsding.org/dl/initiald.png)

Inspired by [hexe][], [gti][], and sl.

## Requirements

* A D2 compiler that can be run using `rdmd`

## Usage

Just run `./initial.d` ;)

If you want to compile it instead, just run this:

``` sh
dmd -J. -of=initial-d ./initial.d
```

This will create an `initial-d` executable in your current working directory.

## License

BSD 2-clause

[hexe]: https://github.com/nilsding/hexe
[gti]: https://github.com/rwos/gti
