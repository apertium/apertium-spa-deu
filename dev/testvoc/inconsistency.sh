#!/bin/bash

TMPDIR=/tmp

lt-expand ../../apertium-es-de.de.dix | grep -v 'REGEX' | grep -v ':>:' | sed 's/:<:/%/g' | sed 's/:/%/g' | cut -f2 -d'%' | sed 's/^/^/g' | sed 's/$/$/g' | grep -v 'REGEX' | tee $TMPDIR/tmp_testvoc1.txt |
        apertium-pretransfer|
        lt-proc -b ../../de-es.autobil.bin | tee $TMPDIR/tmp_testvoc2.txt |
        apertium-transfer -b ../../apertium-es-de.de-es.t1x  ../../de-es.t1x.bin | 
        apertium-interchunk ../../apertium-es-de.de-es.t2x  ../../de-es.t2x.bin |
        apertium-postchunk ../../apertium-es-de.de-es.t3x  ../../de-es.t3x.bin  | tee $TMPDIR/tmp_testvoc3.txt |
        lt-proc -d ../../de-es.autogen.bin > $TMPDIR/tmp_testvoc4.txt
paste -d _ $TMPDIR/tmp_testvoc1.txt $TMPDIR/tmp_testvoc2.txt $TMPDIR/tmp_testvoc3.txt $TMPDIR/tmp_testvoc4.txt | sed 's/\^.<sent>\$//g' | sed 's/_/   --------->  /g'

