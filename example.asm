include "regex.inc"

	; converts a 0-100 percentage to 0-255 if a % sign is present
	macro convert_percent ; value[%]
		regex "([^%]+)(%?)", "\1", value, percent
		def result = value
		if strlen("{percent}")
			def result = result * 255 / 100
		endc
		println "\1 becomes {d:result}"
		purge result, value, percent
	endm

	convert_percent 1%
	convert_percent 50%
	convert_percent 100%
	convert_percent 100
	convert_percent 240
