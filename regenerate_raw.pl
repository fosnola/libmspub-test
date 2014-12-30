#!/usr/bin/perl

$html = 1;

sub GenRaw {

    $PUBVL = '1.0 2.0 3.0 8.0 8.5 9.0 10.0 11.0 12.0 14.0 15.0';

    @pubVersionList = split( /\s+/, $PUBVL );

    foreach $pubVersion (@pubVersionList) {

        # remove all diff files, since they are possible outdated now
        $diffs = 'testset/' . $pubVersion . '/*.diff';
        `rm -f $diffs`;

        $regrInput = 'testset/' . $pubVersion . '/regression.in';
        $FL        = `cat $regrInput`;

        @fileList = split( /\n/, $FL );
        foreach $file (@fileList) {
            $filePath = 'testset/' . $pubVersion . '/' . $file;
            `pub2raw $filePath >$filePath.raw 2>&1`;
            `pub2xhtml $filePath > $filePath.xhtml 2> /dev/null`;
            `xmllint --c14n --nonet --dropdtd $filePath.xhtml > $filePath.xhtml.tmp 2>/dev/null`;
            `xmllint --format $filePath.xhtml.tmp > $filePath.xhtml 2>/dev/null`;
            `rm $filePath.xhtml.tmp`;
            `pub2odg $filePath > $filePath.odg 2> /dev/null`;
            `xmllint --c14n --nonet --dropdtd $filePath.odg > $filePath.odg.tmp 2>/dev/null`;
            `xmllint --format $filePath.odg.tmp > $filePath.odg 2>/dev/null`;
            `rm $filePath.odg.tmp`;
        }
    }
}

# Main function
&GenRaw;

1;
