#!/bin/env python

# a2x extension for odt backend
#
# backend options
#
# --base_doc=path  The odt document to use for styles etc.
# --temp_dir=path   The directory in which to create a tempdir to zip up

import tempfile, shutil, os, os.path, zipfile, subprocess

class tempdir:
	def __init__(self, in_dir=None, keep=False):
		self.dir = None
		self.in_dir = in_dir
		self.keep = keep
	def __enter__(self):
		self.dir = tempfile.mkdtemp(dir=self.in_dir)
		return self.dir
	def __exit__(self, et, ev, tb):
		if not self.keep and self.dir : shutil.rmtree(self.dir, True)

supported_extensions = { ".jpg" : "jpeg", ".png" : "png", ".svg" : "svg" }

class odt_archive:
	def __init__(self, a2x, temp=None, keep=False):
		self.a2x = a2x
		self.temp = temp
		self.keep = keep

	def make_archive(self, base_doc, doc, out_file):
		with tempdir(self.temp, self.keep) as td:
			bz = zipfile.ZipFile(base_doc)
			bz.extractall(td)
			cx = os.path.join(td,"content.xml")
			if os.path.exists(cx) : os.remove(cx)
			shell( '%s --backend=odt -a "a2x-format=%s" -a not_flat_odf %s --out-file "%s" %s' %
				(self.a2x.asciidoc, self.a2x.format, self.a2x.asciidoc_opts, cx, doc))

			mfd = os.path.join(td, "META-INF")
			mfp = os.path.join(mfd, "manifest.xml")
			nmfp = os.path.join(mfd, "new_manifest.xml")
			mre = re.compile(r"(.*?)</manifest:manifest>")
			ire = re.compile(r"<!-- ([^#]+)#([^\s]+) -->")
			with open(nmfp, "w") as nmf:
				with open(mfp, "r") as mf:
					for l in mf:
						m = mre.match(l)
						if m is None:
							nmf.write(l)
						else:
							nmf.write(m.group(1))
				with open(cx, "r") as cxf:
					for cl in cxf:
						mc = ire.match(cl)
						if mc is not None:
							shutil.copyfile(mc.group(1), os.path.join(td, mc.group(2)))
							nmf.write('\n <manifest:file-entry manifest:media-type="image/%s" manifest:full-path="%s"/>' %
								(supported_extensions[os.path.splitext(mc.group(2))[1]],
								 mc.group(2)))
				nmf.write("\n</manifest:manifest>")
			os.remove(mfp)
			os.rename(nmfp, mfp)

			of = os.path.abspath(out_file)
			if os.path.exists(of) : os.remove(of)
			### Make sure we have the mimetype added first, uncompressed
			oz = zipfile.ZipFile(of, "w", zipfile.ZIP_DEFLATED)
			try:
				oz.write(os.path.join(td, 'mimetype'), 'mimetype', zipfile.ZIP_STORED)
				for path, dirs, files in os.walk(td):
					for f in files:
						if f == 'mimetype': continue
						ff = os.path.normpath(os.path.join(path,f))
						oz.write(ff,os.path.relpath(ff,td))
			finally:
				oz.close()

def to_odt(self):
	opts = AttrDict(base_doc=os.path.join('/etc/asciidoc/backends/odt/asciidoc.ott'), temp_dir=None) # TODO remove hardcoded dir
	u = [ o.strip().split('=') for o in self.backend_opts.strip().split('--') if o != '' ]
	opts.update(u)
	if opts.base_doc is None:
		die("No base document found")
	odf_file = self.dst_path('.odt')
	a = odt_archive(self, opts.temp_dir, self.keep_artifacts)
	a.make_archive(opts.base_doc, self.asciidoc_file, odf_file)
