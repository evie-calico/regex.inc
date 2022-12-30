# regex.inc

regex.inc is a regex parser written in rgbasm.
Not *assembly*, but the *macro language*.
Its primary use is picking apart the arguments to complex macros, but feel free to get creative.

Here's an example (you can test this by running `./run.sh`):
```
	include "regex.inc"

	; converts a 0-100 percentage to 0-255 if a % sign is present
	macro convert_percent ; value[%]
		regex "([^%]+)(%?)", "\1", value, percent
		if strlen("{percent}")
			def result = result * 255 / 100
		endc
		println "\1 becomes {d:result}"
		purge result, value, percent
	endm
```

This is simpler than the built-in solution:
```
	include "regex.inc"

	; converts a 0-100 percentage to 0-255 if a % sign is present
	macro convert_percent ; value[%]
		def percent = strin("\1", "%")
		if percent
			def value equs strsub("\1", 1, percent - 1)
			def result = value * 255 / 100
		else
			def result = \1
		endc
		println "\1 becomes {d:result}"
		purge result, value, percent
	endm
```

It's also cooler.
Regexes are cool.

This can be used to write some pretty silly macros.
Like this:
```
	macro jump_if ; a <op> <value>, dest
		regex "a? *([=<>]+) *(.+)", "\1", op, value
		
		println "cp {value}"
		if !STRCMP("{op}", "==")
			jr z, \2
		elif !STRCMP("{op}", "!=")
			jr nz, \2
		elif !STRCMP("{op}", "<")
			jr c, \2
		elif !STRCMP("{op}", ">=")
			jr nc, \2
		elif !STRCMP("{op}", "<=")
			jr z, \2
			jr c, \2
		elif !STRCMP("{op}", ">")
			jr z, :+
			jr nc, \2
			:
		else
			fail "invalid jump_if comparison: {op}"
		endc
	endm

	jump_if a == 100, .where
```
