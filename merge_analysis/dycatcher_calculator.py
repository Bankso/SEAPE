{
  "nbformat": 4,
  "nbformat_minor": 0,
  "metadata": {
    "colab": {
      "name": "Untitled2.ipynb",
      "provenance": [],
      "authorship_tag": "ABX9TyPGtHX8SO0/F0gg2tU71T2q"
    },
    "kernelspec": {
      "name": "python3",
      "display_name": "Python 3"
    },
    "language_info": {
      "name": "python"
    }
  },
  "cells": [
    {
      "cell_type": "code",
      "execution_count": null,
      "metadata": {
        "id": "O4nujETBlNiV"
      },
      "outputs": [],
      "source": [
        "import random\n",
        "import csv\n",
        "import math\n",
        "import sys\n",
        "import os\n",
        "import numpy as np\n",
        "import pathlib\n",
        "import pybedtools\n",
        "from pathlib import Path\n",
        "from pybedtools import BedTool\n",
        "\n",
        "'''\n",
        "Inputs are a BED format file with or without strand info, out directory, logical indicator for strand info, and sizes of BED file adjustments\n",
        "\n",
        "Primary outputs are the set of new BED regions from input sizes, corresponding merged sites, merge sites adjusted to dyads, and dyads adjusted to input \"footprint\" size.\n",
        "\n",
        "Outputs are then used for bedtools calculations to provide:\n",
        "- original BED entries overlapped by each merged \"footprint\", printed together in a new file (-C flag)\n",
        "- counts of the number of original dyads involved in each merged interval \"footprint\"\n",
        "'''\n",
        "\n",
        "infile = sys.argv[1] # A bed format file of dyads or regions (mp is calculated in conversion), dyads req. for calcs\n",
        "outdir = sys.argv[2] # A directory for files to be placed and new directories to be made\n",
        "strand = sys.argv[3] # Logical (TRUE or FALSE) input file has strand info that should be copied? For range extension only\n",
        "sizes = list(sys.argv[4:]) # A list of values to be used as symmetric modifiers of the \"footprint\" size during calcs\n",
        "\n",
        "os.mkdir(outdir)\n",
        "out_name = Path(infile).stem\n",
        "out_root = str(outdir + '/' + out_name)\n",
        "sep = '_'\n",
        "name_list = out_name.split(sep)[0:2]\n",
        "name = sep.join(name_list)\n",
        "\n",
        "#Build new bed regions based on input dyads and requested intervals\n",
        "print('Converting dyads to ' + str(len(sizes)) + ' interval(s)')\n",
        "for s in sizes:\n",
        "\tbed_name = str(out_root + '_' + str(2*int(s)) + '.bed')\n",
        "\tnew_bed = open(bed_name, 'w+')\n",
        "\twith open(dyads) as file:\n",
        "\t\tvalues = csv.reader(file, delimiter = '\\t')\n",
        "\t\ta = list(values)\n",
        "\t\tfor i in range(len(a)):\n",
        "\t\t\tv = int(s)\n",
        "\t\t\te = a[i]\n",
        "\t\t\tchr = e[0]\n",
        "\t\t\tm_p = floor(int(int(e[2]) - ((int(e[2]) - int(e[1]))/2)))\n",
        "\t\t\tif v <= m_p:\n",
        "\t\t\t\tb_v = str(m_p - v)\n",
        "\t\t\t\ta_v = str(m_p + v)\n",
        "\t\t\telse:\n",
        "\t\t\t\tb_v = str(0)\n",
        "\t\t\t\ta_v = str(m_p*2)\n",
        "\t\t\t\tprint('Negative entry detected and fixed')\n",
        "\n",
        "\t\t\tnew_bed.write(chr)\n",
        "\t\t\tnew_bed.write('\\t')\n",
        "\t\t\tnew_bed.write(b_v)\n",
        "\t\t\tnew_bed.write('\\t')\n",
        "\t\t\tnew_bed.write(a_v)\n",
        "\t\t\tnew_bed.write('\\t')\n",
        "\t\t\tnew_bed.write(str(name + '_' + str(2*int(s)) + '_site_' + str(i + 1)))\n",
        "\t\t\tnew_bed.write('\\t')\n",
        "\t\t\tif strand == 'TRUE':\n",
        "\t\t\t\tnew_bed.write('\\t')\n",
        "\t\t\t\tnew_bed.write(e[4])\n",
        "\t\t\t\tnew_bed.write('\\n')\n",
        "\t\t\telse:\n",
        "\t\t\t\tnew_bed.write('\\n')\n",
        "\tnew_bed.close\n",
        "\tfile.close\n",
        "\n",
        "print('Dyads converted to BED intervals from requested ranges')\n",
        "\n",
        "#Use bedtools to merge overlapping regions in each of the new bed files\n",
        "merdir=str(outdir + '/merged_intervals')\n",
        "os.mkdir(merdir)\n",
        "for bed in outdir:\n",
        "\tif os.path.isfile(bed):\n",
        "\t\tmname = Path(bed).stem\n",
        "\t\tmout = str(merdir + '/' + mname + '_merged.bed')\n",
        "\t\tmbed = bed.merge()\n",
        "\t\tmbed.saveas(mout)\n",
        "print('Overlapping intervals merged for all BEDs')\n",
        "\n",
        "#Remake dyads after merging overlaps\n",
        "dydir=str(outdir + '/merged_dyads')\n",
        "os.mkdir(dydir)\n",
        "for mset in merdir:\n",
        "\tdname = Path(mset).stem\n",
        "\tdout = str(merdir + '/' + dname + '_dyads.bed')\n",
        "\tdyfile = open(dout, 'w+')\n",
        "\twith open(mset) as merval:\n",
        "\t\tvals = csv.reader(merval)\n",
        "\t\tm = list(vals)\n",
        "\t\tfor r in range(len(m)):\n",
        "\t\t\tp = m[r]\n",
        "\t\t\tchrm = p[0]\n",
        "\t\t\tmc = floor(int(int(p[2]) - ((int(p[2]) - int(p[1]))/2)))\n",
        "\t\t\tdyfile.write(chrm)\n",
        "\t\t\tdyfile.write('\\t')\n",
        "\t\t\tdyfile.write(str(mc))\n",
        "\t\t\tdyfile.write('\\t')\n",
        "\t\t\tdyfile.write(str(mc + 1))\n",
        "\t\t\tdyfile.write('\\t')\n",
        "\t\t\tdyfile.write(str(name + '_site_' + str(r + 1)))\n",
        "\t\t\tdyfile.write('\\t')\n",
        "\t\t\tdyfile.write('\\n')\n",
        "\n",
        "print('Dyads calculated from merged regions for all BEDs')\n",
        "\n",
        "#Make footprints using the region sizes defined at input and used to merge\n",
        "fpdir=str(outdir + '/new_prints')\n",
        "os.mkdir(fpdir)\n",
        "for dset in dydir:\n",
        "\tfpname = Path(dset).stem\n",
        "\tfpout = str(fpdir + '/' + fpname + '_prints.bed')\n",
        "\tinfo = Path(fpout).stem\n",
        "\tfpfile = open(fpout, 'w+')\n",
        "\tfv = info.split('_')[-4]\n",
        "\twith open(dset) as dyval:\n",
        "\t\tdvs = csv.reader(dyval)\n",
        "\t\td = list(dvs)\n",
        "\t\tfor t in range(len(d)):\n",
        "\t\t\tq = d[t]\n",
        "\t\t\tchrd = q[0]\n",
        "\t\t\tud = int(q[1]) - int(fv)\n",
        "\t\t\tdd = int(q[1]) + int(fv)\n",
        "\t\t\tfpfile.write(chrd)\n",
        "\t\t\tfpfile.write('\\t')\n",
        "\t\t\tfpfile.write(str(ud))\n",
        "\t\t\tfpfile.write('\\t')\n",
        "\t\t\tfpfile.write(str(dd))\n",
        "\t\t\tfpfile.write('\\t')\n",
        "\t\t\tfpfile.write(str(name + '_site_' + str(t + 1)))\n",
        "\t\t\tfpfile.write('\\t')\n",
        "\t\t\tfpfile.write('\\n')\n",
        "\n",
        "# Check how well each set of footprints in a directory covers the original dyad set\n",
        "ovdir=str(outdir + '/dyad_cov')\n",
        "for fpset in fpdir:\n",
        "\tovname = Path(fpset).stem\n",
        "\tovout = str(ovdir + '/' + ovname + '_cov_all_dy.tsv')\n",
        "\tctout = str(ovdir + '/' + ovname + '_counts.tsv')\n",
        "\tcounts = open(ctout, 'w+')\n",
        "\tovlp = open(ovout, 'w+')\n",
        "\tb=list(csv.reader(fpset, delimiter = '\\t'))\n",
        "\tfor j in range(len(b)):\n",
        "\t\tf=b[j]\n",
        "\t\tchrj=f[0]\n",
        "\t\trup=f[1]\n",
        "\t\trdown=f[2]\n",
        "\t\tdipc = 0 #Dyad in print counter for each dyad\n",
        "\t\tc=list(csv.reader(infile, delimiter = '\\t'))\n",
        "\t\tfor k in range(len(c)):\n",
        "\t\t\tg=c[k]\n",
        "\t\t\tchrk=g[0]\n",
        "\t\t\tmp=g[1]\n",
        "\t\t\tddown=g[2]\n",
        "\n",
        "\t\t\tif chrj == chrk:\n",
        "\t\t\t\tif mp >= rup and mp <= rdown: # the dyad is contained in the entry\n",
        "\t\t\t\t\tdipc = dipc + 1\n",
        "\t\t\t\t\tovlp.write(chrj)\n",
        "\t\t\t\t\tovlp.write('\\t')\n",
        "\t\t\t\t\tovlp.write(str(rup))\n",
        "\t\t\t\t\tovlp.write('\\t')\n",
        "\t\t\t\t\tovlp.write(str(rdown))\n",
        "\t\t\t\t\tovlp.write('\\t')\n",
        "\t\t\t\t\tovlp.write(str(f[3]))\n",
        "\t\t\t\t\tovlp.write('\\t')\n",
        "\t\t\t\t\tovlp.write(chrk)\n",
        "\t\t\t\t\tovlp.write('\\t')\n",
        "\t\t\t\t\tovlp.write(str(dup))\n",
        "\t\t\t\t\tovlp.write('\\t')\n",
        "\t\t\t\t\tovlp.write(str(ddown))\n",
        "\t\t\t\t\tovlp.write('\\n')\n",
        "\t\t\t\telse: # The midpoint is not in the region\n",
        "\t\t\t\t\tbreak\n",
        "\t\t\telse: # The entries aren't on the same chr\n",
        "\t\t\t\tbreak\n",
        "\t\t#Record the number of times each print overlapped a dyad in each count set\n",
        "\t\tcounts.write(str(f[3]))\n",
        "\t\tcounts.write('\\t')\n",
        "\t\tcounts.write(str(dipc))\n",
        "\t\tcounts.write('\\n')\n",
        "print('Footprint coverage of original dyads and counts calculated for all sets')\n",
        "\n",
        "print('Run complete - Happy plotting!')\n"
      ]
    }
  ]
}