#!/usr/bin/python

import sys, os, time
import heuristicbyte

#
# system check
#
if os.name == "posix":
	newline = "\n"
elif os.name == "nt":
	newline = "\r\n"
elif os.name == "dos":
	newline = "\r\n"
else:
	newline = "\n"


#
# functions
#
def get_var_and_val (defcfgpath, lineno, linestr):
	pos = linestr.find("=")
	if pos < 0:
		raise ValueError("Wrong defconfig string!\n%s:%i: %s"
				% (defcfgpath, lineno, linestr))
	else:
		var = linestr[:pos].strip()
		var = var.expandtabs(1)
		if var.find(" ") >= 0:
			raise ValueError("Wrong defconfig variable!\n%s:%i: %s"
					% (defcfgpath, lineno, linestr))
		val = linestr[pos+1:].strip()
		#if val.find(" ") >= 0:
		#	raise ValueError("Wrong defconfig value!\n%s:%i: %s"
		#			 % (defcfgpath, lineno, linestr))
	return var, val

def generate_env (var, val):
	block = ""
	if val == "n":
		val = "false"
	elif val == "y":
		val = "true"
	return "%sexport %s=%s" % (block, var, val) + newline

def generate_make (var, val):
	return "%s = %s" % (var, val) + newline

def generate_c (var, val):
	block = ""
	if val == "n":
		block = "//"
	elif val == "y":
		val = "1"
	return "%s#define %s %s" % (block, var, val) + newline

def convert_value (val):
	if val[:5] == "SIZE@":
		val = heuristicbyte.human2bytes(val[5:])
	return val


#
# arguments check
#
if len(sys.argv) != 4:
	sys.stderr.write("Usage: " + sys.argv[0] + " <genconfig type> <defconfig path> <genconfig path>" + newline)
	sys.exit(0)

gentype = sys.argv[1]
defcfgpath = sys.argv[2]
gencfgpath = sys.argv[3]

if gentype == "-e":
	print "Generate xconfig file for Shell environment ..."
elif gentype == "-m":
	print "Generate xconfig file for Makefile ..."
elif gentype == "-c":
	print "Generate xconfig file for C code ..."
else:
	raise ValueError("Wrong generation type!")
	sys.exit(1)

if os.path.exists(defcfgpath) != True:
	raise ValueError("Not exist defconfig file!")
	sys.exit(1)


#
# generate time
#
gendate = time.asctime()
print gendate


#
# header text
#
if gentype == "-e":
	comment = "# "
	header  = "#!/bin/bash" + newline
	header += newline
	footer  = newline
elif gentype == "-m":
	comment = "# "
	header  = "#!/usr/bin/make" + newline
	header += newline
	footer  = newline
elif gentype == "-c":
	comment = "// "
	header  = "#ifndef _XBUILD_XCONFIG_H_" + newline
	header += "#define _XBUILD_XCONFIG_H_" + newline
	header += newline
	footer  = "#endif  // _XBUILD_XCONFIG_H_" + newline
header += comment + "Automatically generated xconfig: don't edit" + newline
header += comment + gendate + newline
header += newline


#
# generate text
#
lineno = 0
genline = ""
defconfig = open(defcfgpath, 'r')
for linestr in defconfig:
	lineno += 1
	linestr = linestr.strip()
	if linestr[:1] == "#":
		continue
	elif linestr == "":
		continue
	else:
		var, val = get_var_and_val(defcfgpath, lineno, linestr)
		val = convert_value(val)
		if gentype == "-e":
			genline += generate_env(var, val)
		elif gentype == "-m":
			genline += generate_make(var, val)
		elif gentype == "-c":
			genline += generate_c(var, val)
defconfig.close()


#
# create genconfig file
#
genconfig = open(gencfgpath, 'w')
genconfig.writelines(header)
genconfig.writelines(genline)
genconfig.writelines(footer)
genconfig.close()

