PERLDIR = /home/ou/archive/scripts/deprecated/slide_making
FILEDIR = tmp_files

.PHONY: outline prepare references adjust compile join clean

outline:
	$(PERLDIR)/extract_outline.pl
	mkdir -p $(FILEDIR)

references:
	$(PERLDIR)/create_references.pl

adjust:
	$(PERLDIR)/adjust_source.pl

compile:
	$(PERLDIR)/compile_all.pl

join:
	$(PERLDIR)/join.pl

clean:
	rm -rf $(FILEDIR)/
