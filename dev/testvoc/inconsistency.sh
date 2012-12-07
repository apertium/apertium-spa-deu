#!/bin/bash

TMPDIR=/tmp

lt-expand ../../apertium-es-de.es.dix | grep -v '<prn><enc>' | grep -v 'REGEX' | grep -v ':>:' | sed 's/:<:/%/g' | sed 's/:/%/g' | cut -f2 -d'%' | sed 's/^/^/g' | sed 's/$/$/g' | grep -v 'REGEX' | tee $TMPDIR/tmp_testvoc1.txt |
        apertium-pretransfer|
        lt-proc -b ../../es-de.autobil.bin | tee $TMPDIR/tmp_testvoc2.txt | sed 's/$/^.<sent>\/.<sent>$/g' |
        apertium-transfer -b ../../apertium-es-de.es-de.t1x  ../../es-de.t1x.bin |
        apertium-interchunk ../../apertium-es-de.es-de.t2x  ../../es-de.t2x.bin |
        apertium-postchunk ../../apertium-es-de.es-de.t3x  ../../es-de.t3x.bin  | sed 's/\^\.<sent>\/\.<sent>\$$//g' | tee $TMPDIR/tmp_testvoc3.txt |
        lt-proc -d ../../es-de.autogen.bin > $TMPDIR/tmp_testvoc4.txt
paste -d _ $TMPDIR/tmp_testvoc1.txt $TMPDIR/tmp_testvoc2.txt $TMPDIR/tmp_testvoc3.txt $TMPDIR/tmp_testvoc4.txt | sed 's/\^.<sent>\$//g' | sed 's/_/   --------->  /g'

